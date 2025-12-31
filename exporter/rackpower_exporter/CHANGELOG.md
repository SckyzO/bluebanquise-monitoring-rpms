# Changelog - RackPower Exporter

## [1.1.0] - "High-Resolution & Fusion" Version
### Added & Improved
- **High-Resolution Data Collection**: The exporter now retrieves the full history of values provided by the Redfish API (`Values` array) instead of just the latest point.
- **Hardware Timestamps**: Integrated precise sensor-provided timestamps (`TimestampInMicrosecond`) for every data point, ensuring absolute accuracy in Grafana/Prometheus regardless of scrape timing.
- **Asynchronous Custom Collector**: Implemented a Prometheus `CustomCollector` interface coupled with an internal memory buffer. Network collection runs in the background, preventing Prometheus scrape timeouts on slow networks.
- **Automatic Rack Detection**: Automatic extraction of the rack ID (e.g., `sequana_11`) from the PMC hostname using regular expressions.
- **OpenMetrics Standardization**:
    - Unified all power metrics under a single name: `sequana3_rack_power_watts`.
    - Enhanced granularity using labels: `pmc`, `rack_id`, and `pump_included` (true/false).

## [1.0.5] - "Robustness & Standards" Version
### Architecture
- **Object-Oriented Refactor**: Migrated the script to a class-based structure (`RackPowerExporter`) for better maintainability and testability.
- **Prometheus Compliance**:
    - Moved metrics to the standard `/metrics` endpoint.
    - Added a landing page on the root path `/`.
    - Changed default port to **9101** to avoid conflicts with the standard Node Exporter.
- **Health Monitoring Metrics**:
    - `sequana3_pmc_up`: Per-PMC availability status.
    - `sequana3_exporter_scrapes_total`: Total count of collection cycles.
    - `sequana3_exporter_errors_total`: Global counter for network or parsing errors.

### Performance
- **Parallelization**: Implemented `ThreadPoolExecutor` to query all PMCs simultaneously, drastically reducing collection time for large infrastructures.

## [1.0.0] - "Security & Packaging" Version
### Security
- **YAML Configuration**: Introduced YAML support (`/etc/rackpower_exporter/rackpower.yml`) to centralize parameters.
- **Credential Management**: Removed command-line credentials in favor of the configuration file to prevent sensitive data leakage via process listing.
- **SSL/TLS Support**: Added optional CA bundle support (`ca_bundle`) for secure HTTPS communication with PMCs.

### Packaging & Build
- **RPM Specfile Refactor**: The RPM now natively manages Python dependencies (`pyyaml`, `clustershell`, `prometheus_client`).
- **Automated Build**: Updated `custom_build.sh` to properly generate the source archive and handle build-time permissions.

---

### Technical Summary
| Feature | Initial Version | Current Version |
| :--- | :--- | :--- |
| **Logic** | Simple Python Script | OO + Multi-threaded |
| **Queries** | Sequential (Slow) | Parallel (Fast) |
| **Data Resolution** | 1 point per scrape | Full Batch History |
| **Accuracy** | Server Local Time | Hardware Sensor Time |
| **Monitoring** | No health metrics | Full Diagnostic Metrics |
| **Packaging** | Opaque binary | Standard Source RPM |
