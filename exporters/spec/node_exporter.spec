%define debug_package %{nil}
%global pkgname node_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       Prometheus exporter for hardware and OS metrics
License:       Apache License 2.0
URL:           https://github.com/prometheus/node_exporter

Source0:       node_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     node_exporter

%description
[Use with BlueBanquise] Prometheus exporter for hardware and OS metrics exposed by *NIX kernels,
written in Go with pluggable metric collectors.

%prep
%setup -n node_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d %{buildroot}/etc/node_exporter
%{__install} -d -m 755 %{buildroot}/etc/node_exporter

%{__install} -D -m 755 node_exporter %{buildroot}/usr/local/bin/node_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/node_exporter

%changelog
* Wed Nov 17 2022 Thomas Bourcey <sckyzo@gmail.com> - 1.0.0
- Initial packaging
