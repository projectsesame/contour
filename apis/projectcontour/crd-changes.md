## CRD Change History

---

## 35: Tag/Release: v1.25.2-baseid-podlabels/2023-08-16

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2022-05-02 12:54:38  | 92c4fc5e2b | Sunjay Bhatia        | Add query parameter hash policy (#4508)  | ./v1/httpproxy.go |
| 2022-05-09 09:13:42  | 46fa79db56 | Steve Kriss          | move ContourConfiguration enum validatio | ./v1alpha1/contourconfig.go |
| 2022-05-20 14:11:54  | 4c3b50f1ce | Steve Kriss          | apis: remove ContourConfiguration DebugL | ./v1alpha1/contourconfig.go |
| 2022-05-24 11:20:19  | 39d735c08a | yangyang             | HTTPProxy: add DirectResponsePolicy opti | ./v1/httpproxy.go |
| 2022-06-28 08:29:42  | cbec8eca9e | Tero Saarni          | Adds support for client certificate revo | ./v1/httpproxy.go |
| 2022-07-20 10:15:10  | 93c0cee19a | Sunjay Bhatia        | Consolidate access log and tls cipher su | ./v1alpha1/contourconfig.go |
| 2022-09-06 20:03:34  | 0d5fb6c4af | izturn               | gateway provisioner: support changing Ku | ./v1alpha1/contourdeployment.go |
| 2022-09-07 08:13:16  | e1a729656a | izturn               | gateway provisioner: support changing Co | ./v1alpha1/contourconfig.go, ./v1alpha1/contourdeployment.go |
| 2022-09-14 18:14:54  | 61e732888d | Sunjay Bhatia        | CORSPolicy AllowOrigin can be configured | ./v1/httpproxy.go |
| 2022-09-21 11:15:10  | 3adbe6d549 | Steve Kriss          | JWT verification (#4723)                 | ./v1/httpproxy.go |
| 2022-09-22 08:05:38  | 31787ad2d7 | Steve Kriss          | support TLS validation for JWKS servers  | ./v1/httpproxy.go |
| 2022-10-03 08:09:26  | d53f4c082a | izturn               | crd/ContourDeployment: Add ResourceLabel | ./v1alpha1/contourdeployment.go |
| 2022-10-06 10:33:41  | 423b8e6a5f | Tero Saarni          | Added support for Envoy slow start mode. | ./v1/httpproxy.go |
| 2022-10-07 08:16:05  | 70459553ef | Steve Kriss          | add optional DNS lookup family for remot | ./v1/httpproxy.go |
| 2022-10-13 09:41:30  | 271edabd73 | Steve Kriss          | add ForwardJWT option to JWTProvider (#4 | ./v1/httpproxy.go |
| 2022-10-13 14:07:14  | 0467b8408e | izturn               | crd/ContourDeployment: Add fields 'extra | ./v1alpha1/contourconfig.go, ./v1alpha1/contourdeployment.go |
| 2022-10-17 11:45:56  | b184f57a66 | izturn               | crd/ContourDeployment: Add field 'podAnn | ./v1alpha1/contourdeployment.go |
| 2022-10-17 20:52:55  | f746c7a130 | izturn               | crd/ContourDeployment: Add fields for re | ./v1alpha1/contourdeployment.go |
| 2022-10-21 06:35:44  | ece8a2491a | Gautier Delorme      | Add support for optional certificate val | ./v1/httpproxy.go |
| 2022-10-21 09:22:10  | c5cbcd9b82 | Gautier Delorme      | XFCC header support (#4797)              | ./v1/httpproxy.go |
| 2022-10-28 12:18:14  | 433fc40ae3 | yangyang             | HTTPProxy: add healthCheck port config ( | ./v1/httpproxy.go |
| 2022-11-01 10:13:19  | e700127f3e | izturn               | gateway provisioner: support changing En | ./v1alpha1/contourdeployment.go |
| 2022-11-01 11:31:02  | fac2c32ee2 | Steve Kriss          | provisioner: move LogLevel validation to | ./v1alpha1/contourdeployment.go |
| 2022-11-02 11:23:18  | 4badccc726 | izturn               | crd/ContourDeployment: Add field for set | ./v1alpha1/contourdeployment.go |
| 2022-11-28 11:36:21  | 632808ccbf | izturn               | crd/ContourDeployment: Add fields for (u | ./v1alpha1/contourdeployment.go |
| 2022-12-21 15:48:51  | f42d3394fc | Vishal Choudhary     | Added support for `ALL` DNS lookup famil | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
| 2023-01-12 13:34:43  | c06623a1c5 | Víctor Roldán Beta | expose configuration for envoy's RateLim | ./v1alpha1/contourconfig.go |
| 2023-01-17 10:15:11  | 31fdfe661e | izturn               | internal/provisioner: set NodePorts from | ./v1alpha1/contourdeployment.go |
| 2023-01-23 10:45:40  | cf769c1216 | Vishal Choudhary     | add support for Envoy's server header tr | ./v1alpha1/contourconfig.go |
| 2023-02-07 10:19:39  | b58e470930 | tigerK               | HTTPProxy: Add AllowPrivateNetwork to CO | ./v1/httpproxy.go |
| 2023-02-08 13:11:24  | 5d51513273 | Aurel Canciu         | HTTPProxy: Implement HTTP query param ma | ./v1/httpproxy.go |
| 2023-03-20 12:08:35  | fac6a99041 | Clayton Gonsalves    | feat: Add HTTP support for External Auth | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
| 2023-03-20 15:10:10  | 7d291e9d3c | Jean-Daniel Dupas    | Internal redirect implementation (#5010) | ./v1/httpproxy.go |
| 2023-03-22 12:28:00  | 5cbd2f0b26 | fangfpeng            | HTTPProxy: support Host header rewrites  | ./v1/httpproxy.go |
| 2023-04-13 09:04:41  | c813560318 | yangyang             | Add tracing support (#5043)              | ./v1alpha1/contourconfig.go |
| 2023-04-25 07:04:33  | f3eb153cce | Evan Cordell         | httpproxy: Add support for ip-based filt | ./v1/httpproxy.go |
| 2023-04-26 11:19:44  | 894693320f | Arjun Salyan         | HTTPProxy: add exact path match conditio | ./v1/httpproxy.go |
| 2023-05-01 07:39:07  | 6d4c6a099f | cui fliter           | fix typos (#5316)                        | ./v1/httpproxy.go, ./v1/tlscertificatedelegation.go |
| 2023-05-17 10:17:35  | b5469efa7d | Sotiris Nanopoulos   | Adds `critical` level for access logging | ./v1alpha1/contourconfig.go |
| 2023-05-23 14:56:32  | df302274e6 | Jean-Daniel Dupas    | [provisioner] Add `ipFamilyPolicy` field | ./v1alpha1/contourdeployment.go |
| 2023-05-26 09:36:47  | d2df163d42 | Clayton Gonsalves    | HTTPProxy: add regex support for path ma | ./v1/httpproxy.go |
| 2023-05-26 16:20:55  | e8f4c683f1 | Steve Kriss          | HTTPProxy: improve godoc for match condi | ./v1/httpproxy.go |
| 2023-06-02 15:25:39  | 8fff15bd34 | izturn               | ContourDeployment: add field podAnnotati | ./v1alpha1/contourdeployment.go |
| 2023-06-14 10:52:16  | 5a77976028 | Clayton Gonsalves    | Add max_requests_per_connection for clus | ./v1alpha1/contourconfig.go |
| 2023-06-23 11:49:36  | 615d553292 | Hassan Shamji        | Enable HTTPProxy Fractional Mirroring (# | ./v1/httpproxy.go |
| 2023-06-23 12:19:54  | a1f8c9ea68 | Rajat Vig            | Allow changing per_connection_buffer_lim | ./v1alpha1/contourconfig.go |
| 2023-06-28 08:53:00  | 585bdb0fc2 | Steve Kriss          | HTTPProxy: support health check status r | ./v1/httpproxy.go |
| 2023-06-28 14:35:31  | d0f1171bd3 | Tero Saarni          | Clarify TLS certificate delegation (#552 | ./v1/httpproxy.go |
| 2023-07-12 20:11:23  | d259b073da | Rajat Vig            | Allow changing per_connection_buffer_lim | ./v1alpha1/contourconfig.go |
| 2023-07-14 15:58:51  | 95f3eab3d6 | Shadi Altarsha       | Add support for General RateLimit Policy | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
| 2023-07-24 13:43:12  | f6c112e60a | Sotiris Nanopoulos   | HTTPProxy: support case insensitive head | ./v1/httpproxy.go |
| 2023-07-28 10:02:14  | d60959ec98 | Sotiris Nanopoulos   | Adds support for treating missing header | ./v1/httpproxy.go |
| 2023-08-09 18:39:46  | 135c8a9651 | izturn               | make Listener maximum TLS version config | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
| 2023-08-15 14:39:07  | e508a4a34f | Tero Saarni          | Added config for socket options for list | ./v1alpha1/contourconfig.go |
**Total: 54**

---

## 36: Tag/Release: v1.26.0-max-heap-size/2023-09-20

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2023-08-21 14:03:18  | 0b1d23cc45 | izturn               |  internal/provisioner: add cmd line argu | ./v1alpha1/contourdeployment.go |
**Total: 1**

---

## 37: Tag/Release: v1.26.1.2/2023-10-19

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2023-09-21 07:44:46  | 58896382ab | yangyang             | provisioner: add field overloadMaxHeapSi | ./v1alpha1/contourdeployment.go |
| 2023-10-03 09:31:23  | cc10bc8b02 | Clayton Gonsalves    | HTTPProxy: allow dynamic Host header rew | ./v1/httpproxy.go |
| 2023-10-12 15:29:48  | 641535ffb3 | Sunjay Bhatia        | Add configurability for HTTP requests pe | ./v1alpha1/contourconfig.go |
| 2023-10-13 15:58:36  | 62db87e674 | Sunjay Bhatia        | HTTP/2 max concurrent streams can be con | ./v1alpha1/contourconfig.go |
| 2023-10-19 14:11:25  | 4e2c23d53c | izturn               | crd/ContourDeployment: Add field 'podLab | ./v1alpha1/contourdeployment.go |
| 2023-10-19 14:17:07  | d7c6dea741 | yy                   | add service outlier detection            | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
**Total: 6**

---

## 38: Tag/Release: v1.27.0-sesame/2023-12-04

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2023-12-04 15:25:33  | 02ef776d2a | izturn               | feat: append stats_prefix & sync with up | ./v1alpha1/contourconfig.go |
**Total: 1**

---

## 39: Tag/Release: v1.27.0-sesame-0b8ab80/2024-01-05

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2023-10-24 12:40:33  | a216475ca1 | Clayton Gonsalves    | add support for endpoint slices (#5745)  | ./v1alpha1/contourconfig.go |
**Total: 1**

---

## 40: Tag/Release: v1.27.0-sesame-0b8ab80-2/2024-01-05

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2024-01-05 17:09:42  | 139382fbca | izturn               | sync to upstream:0b8ab80 (#9)            | ./v1alpha1/contourconfig.go, ./v1alpha1/contourdeployment.go |
**Total: 1**

---

## 41: Tag/Release: v1.27.0-61b6fae/2024-01-18

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2023-09-28 17:33:37  | 39d0717824 | gang.liu             | init commit for extProc                  | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
| 2023-10-09 14:00:52  | ca308a46c0 | gang.liu             | insert extProc by phase(TODO)            | ./v1/httpproxy.go |
| 2023-10-09 16:48:52  | f7a19060d2 | gang.liu             | make generate                            | ./v1/httpproxy.go |
| 2023-10-11 17:43:45  | 84bafd40fe | gang.liu             | set default for extProc's params         | ./v1/httpproxy.go |
| 2023-10-12 18:15:25  | 922668f93a | gang.liu             | clean up                                 | ./v1/httpproxy.go |
| 2023-10-13 18:03:16  | 9c54782a32 | gang.liu             | more todo                                | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
| 2023-10-16 18:24:21  | 07363a8efa | gang.liu             | more log                                 | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
| 2023-10-17 18:01:05  | 99a3b5246a | gang.liu             | comments & more                          | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
| 2023-10-18 17:42:37  | 2c9de3f7a3 | gang.liu             | add filters by phase & refactor          | ./v1/httpproxy.go |
| 2023-10-19 14:06:31  | 04d9840dfc | gang.liu             | make lint happy                          | ./v1/httpproxy.go |
| 2023-12-05 08:51:09  | cf8fb1c4e0 | Steve Kriss          | implement Gateway infrastructure labels/ | ./v1alpha1/contourdeployment.go |
| 2023-12-20 09:47:05  | b57fa06e7b | Clay Kauzlaric       | allow configuration of upstream TLS conn | ./v1alpha1/contourconfig.go |
| 2024-01-02 10:31:26  | b474d101f5 | Sotiris Nanopoulos   | Adds support for global circuit budget ( | ./v1alpha1/contourconfig.go |
| 2024-01-05 21:47:18  | c1dd2da722 | Clay Kauzlaric       | allow multiple SANS in upstream validati | ./v1/httpproxy.go |
| 2024-01-10 16:06:18  | 9e8e12955b | Edwin Xie            | Add max-connections-per-listener config  | ./v1alpha1/contourconfig.go |
| 2024-01-10 17:06:46  | 11396dc213 | gang.liu             | change field's definition & comments     | ./v1/httpproxy.go |
| 2024-01-16 16:53:25  | 572515a8f3 | Sunjay Bhatia        | Enable gofumpt linter (#6093)            | ./v1/tlscertificatedelegation.go |
**Total: 17**

---

## 42: Tag/Release: v1.28.1-23a029/2024-03-13

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2024-01-30 13:26:47  | 29201bbd13 | Lubron               | enable provisioning Gateways that watch  | ./v1alpha1/contourdeployment.go, ./v1/httpproxy.go |
| 2024-01-31 14:18:06  | 62f81db181 | Steve Kriss          | deprecate configuring Contour with a Gat | ./v1alpha1/contourconfig.go |
| 2024-02-09 13:29:33  | 39a7d20023 | Lubron               | add disabled-features flag to ContourDep | ./v1alpha1/contourdeployment.go, ./v1/httpproxy.go |
| 2024-02-12 17:06:20  | fa1d380122 | Sunjay Bhatia        | Enable more linters for standardizing im | ./v1alpha1/contourconfig.go, ./v1alpha1/contourdeployment.go, ./v1alpha1/extensionservice.go, ./v1/httpproxy.go, ./v1/tlscertificatedelegation.go |
| 2024-02-13 12:02:18  | 1cc89d0bfb | Steve Kriss          | Gateway API: remove gateway controller n | ./v1alpha1/contourconfig.go |
| 2024-03-12 10:59:54  | 23a02979a5 | Steve Kriss          | change default xDS server to envoy (#614 | ./v1alpha1/contourconfig.go |
| 2024-03-12 16:48:51  | fc182efc77 | gang.liu             | remove global ext_proc & add name for ex | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
**Total: 7**

---

## 43: Tag/Release: v1.28.1-23a029-one-extproc/2024-03-14

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2024-03-14 17:51:37  | d4102464ef | gang.liu             | global & vh & route only have one ext_pr | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
**Total: 1**

---

## 44: Tag/Release: v1.28.3-6558591/2024-04-25

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2024-03-15 17:23:45  | e1e8c194d2 | gang.liu             | enable disabled for globalExtProc        | ./v1/httpproxy.go |
| 2024-03-18 17:45:55  | 44ec926490 | izturn               | fix crash & enabled 'disabled' for globa | ./v1/httpproxy.go |
| 2024-03-19 10:26:32  | 7bb8868886 | gang.liu             | refactor                                 | ./v1/httpproxy.go |
| 2024-03-21 17:38:52  | 23ae148432 | gang.liu             | fix comments                             | ./v1/httpproxy.go |
| 2024-04-02 18:21:10  | b1955c6e42 | gang.liu             | refactor                                 | ./v1alpha1/contourconfig.go, ./v1/httpproxy.go |
| 2024-04-10 12:58:30  | 6f7010ad81 | izturn               | use EndpointSlices by default (#6149)    | ./v1alpha1/contourconfig.go |
**Total: 6**

---

## 45: Tag/Release: v1.30.0-3e57486/2024-08-01

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2024-07-17 14:03:05  | 49ede7e4cf | Steve Kriss          | deprecate xDS server type field (#6561)  | ./v1alpha1/contourconfig.go |
| 2024-07-25 12:43:41  | 601218d718 | Clayton Gonsalves    | Add circuit breaker support for extensio | ./v1alpha1/contourconfig.go, ./v1alpha1/extensionservice.go |
**Total: 2**

---

## 46: Tag/Release: v1.30.0-d59d534/2024-08-09

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2024-08-08 17:36:56  | 829d0f3c98 | gang.liu             | customize the cert's lifetime            | ./v1alpha1/contourdeployment.go |
**Total: 1**

---

## 47: Tag/Release: v1.30.0-54ceade/2024-10-10

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2024-10-09 18:12:58  | 7bd8979c76 | gang.liu             | customize contour bootstrap's cmdline ar | ./v1alpha1/contourdeployment.go |
**Total: 1**

---

## 48: Tag/Release: v1.30.1-0be3efa/2024-11-07

| Commit Date          | SHA        | Author               | Message                                  | File Path(s)                             |
|-|-|-|-|-|
| 2024-10-21 11:31:14  | 6fb1a29903 | Tero Saarni          | bump controller-runtime and k8s deps (#6 | ./v1/httpproxy.go |
**Total: 1**
