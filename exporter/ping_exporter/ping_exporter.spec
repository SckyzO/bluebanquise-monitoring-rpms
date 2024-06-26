%define debug_package %{nil}
%global pkgname ping_exporter
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
Summary:       Prometheus exporter for ICMP echo
License:       Apache License 2.0
URL:           https://github.com/czerwonk/ping_exporter

Source0:       ping_exporter-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     ping_exporter

%description
[Use with BlueBanquise] Prometheus exporter for ICMP echo requests using https://github.com/digineo/go-ping

This is a simple server that scrapes go-ping stats and exports them via HTTP for Prometheus consumption. 
The go-ping library is build and maintained by Digineo GmbH.

%prep
%setup -n ping_exporter-%{version}.Linux-x86_64

%build

%pre

%install
%{__install} -D -m 755 ping_exporter %{buildroot}/usr/local/bin/ping_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/ping_exporter

%changelog
* Tue Apr 25 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Wed Nov 17 2022 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
