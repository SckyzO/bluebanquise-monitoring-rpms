%define debug_package %{nil}
%global pkgname 389ds_exporter
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
Summary:       Prometheus exporter for 389-DS LDAP Server
License:       Apache License 2.0
URL:           https://github.com/ozgurcd/389DS-exporter

Source0:       389ds_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     389ds_exporter

%description
[Use with BlueBanquise] Prometheus exporter for 389-DS LDAP Server 

%prep
%setup -n 389ds_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d %{buildroot}/etc/389ds_exporter
%{__install} -d -m 755 %{buildroot}/etc/389ds_exporter

%{__install} -D -m 755 389ds_exporter %{buildroot}/usr/local/bin/389ds_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/389ds_exporter

%changelog
* Tue Apr 25 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Mon Mar 20 2023 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
