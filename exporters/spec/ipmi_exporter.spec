%define debug_package %{nil}
%global pkgname ipmi_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       Remote IPMI exporter for Prometheus
License:       Apache License 2.0
URL:           https://github.com/prometheus-community/ipmi_exporter

Source0:       ipmi_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     ipmi_exporter

%description
[Use with BlueBanquise] This is an IPMI exporter for Prometheus.
It supports both the regular /metrics endpoint, exposing metrics from the host that the exporter is running
on, as well as an /ipmi endpoint that supports IPMI over RMCP - one exporter running on one host can be used
to monitor a large number of IPMI interfaces by passing the target parameter to a scrape.

The exporter relies on tools from the FreeIPMI suite for the actual IPMI implementation.

%prep
%setup -n ipmi_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -D -m 755 ipmi_exporter %{buildroot}/usr/local/bin/ipmi_exporter


%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/ipmi_exporter

%changelog
* Wed Nov 17 2022 Thomas Bourcey <sckyzo@gmail.com> - 1.0.0
- Initial packaging
