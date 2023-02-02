// Copyright Project Contour Authors
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package v3

import (
	"testing"
	"time"

	envoy_config_trace_v3 "github.com/envoyproxy/go-control-plane/envoy/config/trace/v3"
	envoy_trace_v3 "github.com/envoyproxy/go-control-plane/envoy/type/tracing/v3"
	"google.golang.org/protobuf/types/known/durationpb"

	envoy_core_v3 "github.com/envoyproxy/go-control-plane/envoy/config/core/v3"
	http "github.com/envoyproxy/go-control-plane/envoy/extensions/filters/network/http_connection_manager/v3"
	envoy_type_v3 "github.com/envoyproxy/go-control-plane/envoy/type/v3"
	"github.com/projectcontour/contour/internal/dag"
	"github.com/projectcontour/contour/internal/k8s"
	"github.com/projectcontour/contour/internal/protobuf"
	"github.com/projectcontour/contour/internal/timeout"
	"github.com/stretchr/testify/assert"
	"google.golang.org/protobuf/types/known/wrapperspb"
)

func TestTracingConfig(t *testing.T) {
	tests := map[string]struct {
		tracing *dag.TracingConfig
		want    *http.HttpConnectionManager_Tracing
	}{
		"nil config": {
			tracing: nil,
			want:    nil,
		},
		"normal config": {
			tracing: &dag.TracingConfig{
				ExtensionService: k8s.NamespacedNameFrom("projectcontour/otel-collector"),
				ServiceName:      "contour",
				SNI:              "some-server.com",
				Timeout:          timeout.DurationSetting(5 * time.Second),
				OverallSampling:  100,
				MaxPathTagLength: 256,
				CustomTags: []*dag.CustomTag{
					{
						TagName: "literal",
						Literal: "this is literal",
					},
					{
						TagName:         "environmentName",
						EnvironmentName: "HOST",
					},
					{
						TagName:           "requestHeaderName",
						RequestHeaderName: ":path",
					},
				},
			},
			want: &http.HttpConnectionManager_Tracing{
				OverallSampling: &envoy_type_v3.Percent{
					Value: 100.0,
				},
				MaxPathTagLength: wrapperspb.UInt32(256),
				CustomTags: []*envoy_trace_v3.CustomTag{
					{
						Tag: "literal",
						Type: &envoy_trace_v3.CustomTag_Literal_{
							Literal: &envoy_trace_v3.CustomTag_Literal{
								Value: "this is literal",
							},
						},
					},
					{
						Tag: "environmentName",
						Type: &envoy_trace_v3.CustomTag_Environment_{
							Environment: &envoy_trace_v3.CustomTag_Environment{
								Name: "HOST",
							},
						},
					},
					{
						Tag: "requestHeaderName",
						Type: &envoy_trace_v3.CustomTag_RequestHeader{
							RequestHeader: &envoy_trace_v3.CustomTag_Header{
								Name: ":path",
							},
						},
					},
				},
				Provider: &envoy_config_trace_v3.Tracing_Http{
					Name: "envoy.tracers.opentelemetry",
					ConfigType: &envoy_config_trace_v3.Tracing_Http_TypedConfig{
						TypedConfig: protobuf.MustMarshalAny(&envoy_config_trace_v3.OpenTelemetryConfig{
							GrpcService: &envoy_core_v3.GrpcService{
								TargetSpecifier: &envoy_core_v3.GrpcService_EnvoyGrpc_{
									EnvoyGrpc: &envoy_core_v3.GrpcService_EnvoyGrpc{
										ClusterName: "extension/projectcontour/otel-collector",
										Authority:   "some-server.com",
									},
								},
								Timeout: durationpb.New(5 * time.Second),
							},
							ServiceName: "contour",
						}),
					},
				},
			},
		},
		"no custom tag": {
			tracing: &dag.TracingConfig{
				ExtensionService: k8s.NamespacedNameFrom("projectcontour/otel-collector"),
				ServiceName:      "contour",
				SNI:              "some-server.com",
				Timeout:          timeout.DurationSetting(5 * time.Second),
				OverallSampling:  100,
				MaxPathTagLength: 256,
				CustomTags:       nil,
			},
			want: &http.HttpConnectionManager_Tracing{
				OverallSampling: &envoy_type_v3.Percent{
					Value: 100.0,
				},
				MaxPathTagLength: wrapperspb.UInt32(256),
				CustomTags:       nil,
				Provider: &envoy_config_trace_v3.Tracing_Http{
					Name: "envoy.tracers.opentelemetry",
					ConfigType: &envoy_config_trace_v3.Tracing_Http_TypedConfig{
						TypedConfig: protobuf.MustMarshalAny(&envoy_config_trace_v3.OpenTelemetryConfig{
							GrpcService: &envoy_core_v3.GrpcService{
								TargetSpecifier: &envoy_core_v3.GrpcService_EnvoyGrpc_{
									EnvoyGrpc: &envoy_core_v3.GrpcService_EnvoyGrpc{
										ClusterName: "extension/projectcontour/otel-collector",
										Authority:   "some-server.com",
									},
								},
								Timeout: durationpb.New(5 * time.Second),
							},
							ServiceName: "contour",
						}),
					},
				},
			},
		},
		"no SNI set": {
			tracing: &dag.TracingConfig{
				ExtensionService: k8s.NamespacedNameFrom("projectcontour/otel-collector"),
				ServiceName:      "contour",
				SNI:              "",
				Timeout:          timeout.DurationSetting(5 * time.Second),
				OverallSampling:  100,
				MaxPathTagLength: 256,
				CustomTags:       nil,
			},
			want: &http.HttpConnectionManager_Tracing{
				OverallSampling: &envoy_type_v3.Percent{
					Value: 100.0,
				},
				MaxPathTagLength: wrapperspb.UInt32(256),
				CustomTags:       nil,
				Provider: &envoy_config_trace_v3.Tracing_Http{
					Name: "envoy.tracers.opentelemetry",
					ConfigType: &envoy_config_trace_v3.Tracing_Http_TypedConfig{
						TypedConfig: protobuf.MustMarshalAny(&envoy_config_trace_v3.OpenTelemetryConfig{
							GrpcService: &envoy_core_v3.GrpcService{
								TargetSpecifier: &envoy_core_v3.GrpcService_EnvoyGrpc_{
									EnvoyGrpc: &envoy_core_v3.GrpcService_EnvoyGrpc{
										ClusterName: "extension/projectcontour/otel-collector",
										Authority:   "extension.projectcontour.otel-collector",
									},
								},
								Timeout: durationpb.New(5 * time.Second),
							},
							ServiceName: "contour",
						}),
					},
				},
			},
		},
	}
	for name, tc := range tests {
		t.Run(name, func(t *testing.T) {
			got := TracingConfig(tc.tracing)
			assert.Equal(t, tc.want, got)
		})
	}
}
