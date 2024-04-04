%define debug_package %{nil}
%global pkgname apache_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       Prometheus exporter for Apache
License:       MIT License
URL:           https://github.com/Lusitaniae/apache_exporter

Source0:       apache_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     apache_exporter

%description
[Use with BlueBanquise] Prometheus exporter for Apache 

%prep
%setup -n apache_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d %{buildroot}/etc/apache_exporter
%{__install} -d -m 755 %{buildroot}/etc/apache_exporter

%{__install} -D -m 755 apache_exporter %{buildroot}/usr/local/bin/apache_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/apache_exporter

%changelog
* Mon Mar 20 2024 Thomas Bourcey <sckyzo@gmail.com> - 1.0.0
- Initial packaging
