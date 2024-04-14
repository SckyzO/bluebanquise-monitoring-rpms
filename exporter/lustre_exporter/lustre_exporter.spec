%define debug_package %{nil}
%global pkgname lustre_exporter
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
Summary:       Prometheus exporter for Lustre
License:       Apache License 2.0
URL:           https://github.com/treydock/lustre_exporter

Source0:       lustre_exporter-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     lustre_exporter

%description
[Use with BlueBanquise] Prometheus exporter for Lustre 

%prep
%setup -n lustre_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d %{buildroot}/etc/lustre_exporter
%{__install} -d -m 755 %{buildroot}/etc/lustre_exporter

%{__install} -D -m 755 lustre_exporter %{buildroot}/usr/local/bin/lustre_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/lustre_exporter

%changelog
* Tue Apr 25 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Mon Mar 20 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
