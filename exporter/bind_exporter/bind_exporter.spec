%define debug_package %{nil}
%global pkgname bind_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif
%if 0%{?rhel} == 9
 %define dist .el9
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       Bind Exporter for Prometheus
License:       Apache License 2.0
URL:           https://github.com/prometheus-community/bind_exporter

Source0:       bind_exporter-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     bind_exporter

%description
[Use with BlueBanquise] Export BIND (named/dns) v9+ service metrics to Prometheus.

%prep
%setup -n bind_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -D -m 755 bind_exporter %{buildroot}/usr/local/bin/bind_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/bind_exporter

%changelog
* Tue Apr 25 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Wed Nov 17 2022 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
