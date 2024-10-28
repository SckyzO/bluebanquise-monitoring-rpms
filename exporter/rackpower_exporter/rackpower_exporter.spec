%define debug_package %{nil}
%global pkgname rackpower_exporter
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
Summary:       Prometheus exporter for RackPower
License:       Apache License 2.0
URL:           https://www.bull!.fr

Source0:       rackpower_exporter-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     rackpower_exporter

%description
[Use with BlueBanquise] Prometheus exporter for Sequana 3 Rack Power 

%prep
%setup -n rackpower_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -D -m 755 rackpower_exporter %{buildroot}/usr/local/bin/rackpower_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/rackpower_exporter

%changelog
* Wed Jun 17 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
