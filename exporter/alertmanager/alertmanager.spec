%define debug_package %{nil}
%global pkgname alertmanager
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
Summary:       Prometheus Alertmanager.
License:       ASL 2.0

Source0:       alertmanager-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     alertmanager

%description
[Use with BlueBanquise] The Alertmanager handles alerts sent by client applications such as the
Prometheus server. It takes care of deduplicating, grouping, and routing them to
the correct receiver integration such as email, PagerDuty, or OpsGenie. It also
takes care of silencing and inhibition of alerts.

%prep
%setup -q -n alertmanager-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d -m 755 %{buildroot}/etc/alertmanager

%{__install} -d -m 755 %{buildroot}/usr/local/bin
%{__install} -D -m 755 alertmanager %{buildroot}/usr/local/bin/alertmanager
%{__install} -D -m 755 amtool %{buildroot}/usr/local/bin/amtool

%{__install} -d -m 750 %{buildroot}/var/lib/prometheus/alertmanager

%files
%defattr(-,root,root)
%attr(-, root, root) /usr/local/bin/alertmanager
%attr(-, root, root) /usr/local/bin/amtool
%dir /var/lib/prometheus/alertmanager

%changelog
* Tue Apr 25 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Wed Nov 17 2022 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0
- Initial packaging
