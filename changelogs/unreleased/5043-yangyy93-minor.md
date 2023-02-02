## Sample minor change

Contour now supports exporting tracing data to [OpenTelemetry][1]

The Contour configuration file and ContourConfiguration CRD will be extended with a new optional `tracing` section. This configuration block, if present, will enable tracing and will define the trace properties needed to generate and export trace data.

### Contour supports the following configurations
- Custom service name, the default is `contour`.
- Custom sampling rate, the default is `100`.
- Custom the maximum length of the request path, the default is `256`.
- Customize span tags from literal,environment variables and request headers.

[1]: https://opentelemetry.io/
