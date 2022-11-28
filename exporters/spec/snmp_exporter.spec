%define debug_package %{nil}
%global pkgname snmp_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       SNMP Exporter for Prometheus
License:       Apache License 2.0
URL:           https://github.com/prometheus/snmp_exporter

Source0:       snmp_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     snmp_exporter

%description
[Use with BlueBanquise] This exporter is the recommended way to expose SNMP data in a format which 
Prometheus can ingest. While SNMP uses a hierarchical data structure and Prometheus uses an n-dimnensional 
matrix, the two systems map perfectly, and without the need to walk through data by hand. snmp_exporter 
maps the data for you.




%prep
%setup -n snmp_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d -m 755 %{buildroot}/etc/snmp_exporter

%{__install} -D -m 755 snmp_exporter %{buildroot}/usr/local/bin/snmp_exporter


%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/snmp_exporter

%changelog
* Wed Nov 17 2022 Thomas Bourcey <sckyzo@gmail.com> - 1.0.0
- Initial packaging
