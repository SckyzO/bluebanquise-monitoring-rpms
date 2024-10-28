%define debug_package %{nil}
%global pkgname lctl_ping_exporter
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
Summary:       Prometheus exporter for Lustre lctl Ping
License:       Apache License 2.0
URL:           https://www.bull!.fr

Source0:       lctl_ping_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     lctl_ping_exporter

%description
[Use with BlueBanquise] Prometheus exporter for Lustre lctp ping 

%prep
%setup -n lctl_ping_exporter-%{version}

%build

%pre

%install
%{__install} -D -m 755 lctl_ping_exporter %{buildroot}/usr/local/bin/lctl_ping_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/lctl_ping_exporter

%changelog
* Wed Jun 17 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
