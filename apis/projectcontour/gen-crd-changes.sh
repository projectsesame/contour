#!/bin/bash

# ======================================================================
# 脚本名称: git_multi_file_tag_history_md.sh
# 脚本功能: 分析多个指定文件的 Git 提交历史，找出每个提交最早所在的标签，
#           并按标签对所有提交进行分组排序显示。
#           同一提交修改了多个文件时，只列出一次，并在文件路径列合并文件列表。
#           结果以 Markdown 表格格式输出到指定文件。表格包含完整的文件路径列。
#           每个标签分组的表格会添加序号。
# 作者: [您的姓名/昵称]
# 创建日期: [根据当前日期填写，例如: 2023-10-27]
# 修改日期: [根据当前日期填写，例如: 2025-04-18]
# ======================================================================

# --- 配置与输入检查 ---
if [ "$#" -lt 2 ]; then
  echo "错误：请输入输出文件路径和至少一个文件路径作为参数。" >&2
  echo "用法: $0 <输出文件路径> <文件路径1> [文件路径2 ...]" >&2
  exit 1
fi

output_file="$1"
shift # 移除第一个参数 (输出文件)，剩余参数为文件列表
file_paths=("$@") # 将剩余参数存入数组

# 检查是否在 Git 仓库中
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "错误：当前目录不是一个 Git 仓库。" >&2
    exit 1
fi

echo "分析结果将保存到: $output_file" >&2
echo "---" >&2

# 清空或创建输出文件
echo -n "" > "$output_file"

# --- 预处理：获取并排序所有标签 (只需获取一次，用于查找提交所属标签) ---
echo "正在获取并按创建日期排序标签..." >&2
git fetch --tags --quiet # 拉取最新标签
# 按标签创建日期排序（creatordate 最可靠，涵盖 annotated 和 lightweight）
mapfile -t sorted_tags < <(git tag --sort=creatordate)

if [ ${#sorted_tags[@]} -eq 0 ]; then
  echo "警告：仓库中没有找到任何标签。" >&2
fi

# 预缓存标签日期 (使用 ISO 8601 格式，便于排序)
declare -A tag_dates_cache
echo "正在缓存标签日期 (ISO 格式)..." >&2
# 用于未知日期排序的占位符，确保其在已知日期和 N/A 之间
tag_date_unknown_placeholder="YYYY-MM-DDTHH:MM:SS+ZZZZ"
# 用于 N/A 日期排序的占位符，确保其在最后
tag_date_na_placeholder="ZZZZ-ZZ-ZZTZ:ZZ:ZZ+ZZZZ"

for tag in "${sorted_tags[@]}"; do
    tag_date_iso=$(git for-each-ref "refs/tags/$tag" --format='%(creatordate:iso8601)' 2>/dev/null)
    # 处理可能的空日期或错误
    if [[ -z "$tag_date_iso" ]]; then
        # 尝试获取 tag 指向的 commit 的日期作为后备
        # 使用 ^{commit} 确保即使是 lightweight tag 也能获取其指向的 commit
        tag_date_iso=$(git log -1 --format=%cI "$tag^{commit}" 2>/dev/null || git log -1 --format=%cI "$tag" 2>/dev/null || echo "$tag_date_unknown_placeholder")
    fi
     # 如果仍然失败，使用占位符
    if [[ "$tag_date_iso" == "$tag_date_unknown_placeholder" ]] || [[ -z "$tag_date_iso" ]]; then
         echo "警告: 无法确定标签 '$tag' 的创建日期，将使用占位符。" >&2
         tag_dates_cache["$tag"]="$tag_date_unknown_placeholder"
    else
         tag_dates_cache["$tag"]="$tag_date_iso"
    fi
done
echo "标签处理完毕。" >&2
echo "---" >&2


# --- 创建一个临时文件存储所有文件的待排序数据 ---
# 这个临时文件将累积所有文件的提交历史。
# 格式: SortKeyTagDate<TAB>CommitDateISO<TAB>CommitHash<TAB>AuthorName<TAB>FoundTag<TAB>FoundTagDateISO_ForDisplay<TAB>CommitSubject<TAB>FilePath
tmp_file=$(mktemp)
# 确保脚本退出时删除临时文件
trap 'rm -f "$tmp_file"' EXIT


# --- 循环处理每个文件，获取其历史并追加到**同一个**临时文件 ---
echo "正在收集所有文件的提交历史并查找每个提交所属的最早标签..." >&2
any_file_processed=false # 标志，用于检查是否有任何文件成功处理并写入临时文件

for file_path in "${file_paths[@]}"; do
    echo "--> 处理文件: $file_path" >&2

    # 检查当前文件是否存在于 HEAD 或工作目录
    # 注意: 如果文件在历史中存在但当前被删，!-f "$file_path" 会判断为不存在，但git cat-file可以找到HEAD中的信息
    # 这里我们主要关心的是git log --follow是否能针对这个路径找到历史
    # git log --follow -- "$file_path" 会在找不到文件时失败，这是正常的
    # 所以这里的存在检查可以简化，或者依赖git log的返回码，但显式检查更清晰
     if ! git rev-parse --verify "HEAD:./$file_path" >/dev/null 2>&1 && [ ! -f "$file_path" ]; then
         echo "警告：文件 '$file_path' 在仓库 HEAD 或工作目录中未找到，可能没有相关历史，跳过。" >&2
         continue # 跳过当前文件处理下一个
     fi


    any_file_processed=true

    # 获取当前文件的提交历史链 (--follow 跟踪重命名/移动)
    # 对于每个提交，查找其最早包含的标签，并与提交信息及文件路径一起写入临时文件
    git log --follow --format='%H%x09%an%x09%cI%x09%s' -- "$file_path" | while IFS=$'\t' read -r commit_hash author_name commit_date_iso commit_subject; do

        found_tag="N/A"
        found_tag_date_iso="N/A" # 初始状态

        # 遍历**所有排序好的标签列表**，寻找包含此 commit 的**最早创建**的标签
        # 这个循环会在找到第一个（即最早创建的）包含当前commit的tag后立即停止
        for tag in "${sorted_tags[@]}"; do
            # git merge-base --is-ancestor $commit $tag 检查 $commit 是否是 $tag (或 $tag 指向的 commit) 的祖先
            # 即 $tag (或 $tag指向的commit) 是否包含 $commit
            if git merge-base --is-ancestor "$commit_hash" "$tag^{commit}" > /dev/null 2>&1 || git merge-base --is-ancestor "$commit_hash" "$tag" > /dev/null 2>&1; then
                found_tag="$tag"
                found_tag_date_iso="${tag_dates_cache["$tag"]}" # 从缓存获取 ISO 日期
                break # 找到第一个（即最早创建的）包含此 commit 的 tag，停止搜索
            fi
        done

        # 准备用于**总排序**的 Tag 日期键 (将 Unknown 放在已知日期后，N/A 放在最后)
        sort_key_tag_date="$found_tag_date_iso"
        if [[ "$found_tag_date_iso" == "N/A" ]]; then
            sort_key_tag_date="$tag_date_na_placeholder" # N/A 排在最后
        elif [[ "$found_tag_date_iso" == "$tag_date_unknown_placeholder" ]]; then
             sort_key_tag_date="$tag_date_unknown_placeholder" # 未知日期排在 N/A 之前，但在已知日期之后
        fi

        # 将此提交的信息、找到的标签信息，以及它**来自的文件路径**写入**总临时文件**
        # 格式: SortKeyTagDate<TAB>CommitDateISO<TAB>CommitHash<TAB>AuthorName<TAB>FoundTag<TAB>FoundTagDateISO_ForDisplay<TAB>CommitSubject<TAB>**FilePath**
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
            "$sort_key_tag_date" \
            "$commit_date_iso" \
            "$commit_hash" \
            "$author_name" \
            "$found_tag" \
            "$found_tag_date_iso" \
            "$commit_subject" \
            "$file_path" \
            >> "$tmp_file" # 注意这里是追加到总临时文件

    done
done # 循环处理每个文件结束

echo "所有文件历史收集完毕并写入临时文件。" >&2
echo "---" >&2

# 检查是否有任何文件的历史被成功收集到临时文件
if [ "$any_file_processed" != true ] || [ ! -s "$tmp_file" ]; then
    echo "没有为任何指定的文件找到相关提交历史。" >&2
    echo "*(No relevant commit history found for any specified files)*" > "$output_file" # 在输出文件里也说明
    exit 0 # 没有历史则直接退出
fi


# --- 定义表格列宽 (用于Markdown表格内部对齐，Markdown解析器不强制要求) ---
# 实际Markdown表格宽度由内容和Markdown渲染器决定
date_width=20
sha_width=10
author_width=20
subject_width=40 # 主题列
filepath_width=40 # 新增文件路径列宽 (用于Markdown源文件对齐和头部分隔线)

# Helper function to print markdown table separator line
print_md_separator() {
    # Print a markdown table header separator like |---|---|...|
    # The number of dashes should match the column width for better readability in source,
    # but Markdown only requires at least 3 dashes.
    printf "|%s|%s|%s|%s|%s|\n" \
        "$(printf -- "-%.0s" $((date_width > 3 ? date_width : 3)))" \
        "$(printf -- "-%.0s" $((sha_width > 3 ? sha_width : 3)))" \
        "$(printf -- "-%.0s" $((author_width > 3 ? author_width : 3)))" \
        "$(printf -- "-%.0s" $((subject_width > 3 ? subject_width : 3)))" \
        "$(printf -- "-%.0s" $((filepath_width > 3 ? filepath_width : 3)))" # 文件路径列
}


# --- **一次性**排序**所有**文件的合并结果，合并同一提交的文件路径，然后分组输出到主输出文件 (Markdown 格式) ---
echo "正在排序所有文件的合并历史，合并同一提交的文件路径，按标签分组并格式化输出到 '$output_file'..." >&2

# 对**总临时文件**中的所有数据进行排序 (按标签和提交日期)
# 然后使用 awk 按提交哈希合并文件路径
# 最后将结果管道给 shell 进行分组和格式化输出
sort -t$'\t' -k1,1 -k2,2 "$tmp_file" | \
awk -F'\t' '
{
  # Fields from temporary file:
  # $1: SortKeyTagDate
  # $2: CommitDateISO
  # $3: CommitHash
  # $4: AuthorName
  # $5: FoundTag
  # $6: FoundTagDateISO_ForDisplay
  # $7: CommitSubject
  # $8: FilePath

  commit_hash = $3;
  file_path = $8;

  # If this is a new commit hash (or the first line)
  if (commit_hash != prev_commit_hash) {
    # If we just finished processing a commit block (i.e., not the very first line)
    if (prev_commit_hash != "") {
      # Output the consolidated line for the previous commit block
      # Fields to output:
      # 1: Prev_SortKeyTagDate
      # 2: Prev_CommitDateISO
      # 3: Prev_CommitHash
      # 4: Prev_AuthorName
      # 5: Prev_FoundTag
      # 6: Prev_FoundTagDateISO_ForDisplay
      # 7: Prev_CommitSubject
      # 8: Consolidated_FilePaths (comma-separated)
      print prev_sort_key "\t" prev_commit_date_iso "\t" prev_commit_hash "\t" prev_author_name "\t" \
            prev_found_tag "\t" prev_found_tag_date_iso_display "\t" prev_commit_subject "\t" file_paths_list;
    }

    # Start accumulating for the new commit hash
    file_paths_list = file_path; # Initialize list with the current file path
    # Store current line fields as previous for the next iteration (only fields needed for the combined output)
    prev_sort_key = $1;
    prev_commit_date_iso = $2;
    prev_commit_hash = commit_hash; # Use the variable for clarity
    prev_author_name = $4;
    prev_found_tag = $5;
    prev_found_tag_date_iso_display = $6;
    prev_commit_subject = $7;

  } else {
    # Same commit hash as the previous line, append the file path
    file_paths_list = file_paths_list ", " file_path;
  }
}
END {
  # Output the consolidated line for the very last commit block, if any data was processed
  if (prev_commit_hash != "") {
     print prev_sort_key "\t" prev_commit_date_iso "\t" prev_commit_hash "\t" prev_author_name "\t" \
           prev_found_tag "\t" prev_found_tag_date_iso_display "\t" prev_commit_subject "\t" file_paths_list;
  }
}' - | { # Awk outputs to stdout, pipe that to the final shell while loop

    current_tag_group=""
    group_commit_count=0 # 初始化分组提交计数器
    table_counter=0    # 初始化表格序号计数器 (跨文件从1开始计数)

    echo "## CRD Change History" # Markdown 标题
    
    # 读取**awk合并后**的数据，现在每行代表一个唯一的提交哈希，包含合并后的文件路径
    while IFS=$'\t' read -r _sort_key commit_date_iso commit_hash author_name found_tag found_tag_date_iso_display commit_subject combined_file_paths; do # 注意读取了合并后的文件路径字段

        # 格式化提交日期用于显示 (YYYY-MM-DD HH:MM:SS)
        commit_date_short=$(echo "$commit_date_iso" | cut -c 1-19 | sed 's/T/ /')

        # 格式化标签日期用于 GROUP HEADER (只显示日期YYYY-MM-DD)
        tag_date_group_header="N/A" # 默认

        if [[ "$found_tag" != "N/A" ]]; then
            if [[ "$found_tag_date_iso_display" == "$tag_date_unknown_placeholder" ]]; then
                tag_date_group_header="Unknown Date"
            elif [[ "$found_tag_date_iso_display" != "N/A" ]] && [[ "$found_tag_date_iso_display" != "$tag_date_na_placeholder" ]]; then
                 # 提取日期部分 for group header
                 tag_date_group_header=$(echo "$found_tag_date_iso_display" | cut -c 1-10)
            fi
        fi

        # 检测标签分组变化 (**跨文件统一检测**)
        if [[ "$found_tag" != "$current_tag_group" ]]; then
            if [[ -n "$current_tag_group" ]]; then
                # 打印上一组的统计行数 (如果不是第一个组)
                echo "**Total: $group_commit_count**"
                echo "" # 组间空行
                echo "---" # 组间水平分隔线 (Markdown)
                echo "" # 组间空行
            fi

            # 递增表格序号 (跨文件统一计数)
            ((table_counter++))

            # 打印新的标签组头 (Markdown 标题)
            if [[ "$found_tag" == "N/A" ]]; then
                 echo "## $table_counter: Commits with no associated release tag (yet)"
            else
                 echo "## $table_counter: Tag/Release: $found_tag/$tag_date_group_header" # 使用只包含日期的变量
            fi
            echo "" # 标题后空行

            # 打印 Markdown 表格头 (包含文件路径列)
            printf "| %-${date_width}s | %-${sha_width}s | %-${author_width}s | %-${subject_width}s | %-${filepath_width}s |\n" \
                "Commit Date" "SHA" "Author" "Message" "File Path(s)" # 增加文件路径列名，并改名为 File Path(s)

            # 打印 Markdown 表格头分隔线 (包含文件路径列)
            print_md_separator

            # 重置分组计数器并更新当前分组标签
            group_commit_count=0
            current_tag_group="$found_tag"
        fi

        # 递增当前分组的计数器
        ((group_commit_count++))

        commit_hash_short=$(echo "$commit_hash" | cut -c 1-10)
        author_name_short="${author_name}" # 直接使用作者名

        # 打印当前提交行 (Markdown 表格行 - 包含**合并后**的文件路径列)
        # 移除 .WIDTH 截断，显示完整的文件路径字符串
        printf "| %-${date_width}s | %-${sha_width}s | %-${author_width}.${author_width}s | %-${subject_width}.${subject_width}s | %s |\n" \
            "$commit_date_short" \
            "$commit_hash_short" \
            "$author_name_short" \
            "$commit_subject" \
            "$combined_file_paths" # 使用合并后的文件路径字段

    done

    # 打印最后一个组的统计行数 (如果存在任何提交)
    if [[ -n "$current_tag_group" ]]; then
         echo "**Total: $group_commit_count**"
    fi
} > "$output_file" # 将所有输出重定向到主输出文件

echo "分析完成，结果已保存到 '$output_file'" >&2

# 临时文件将由 trap 自动清理
exit 0