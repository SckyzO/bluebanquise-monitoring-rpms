%define debug_package %{nil}
%global pkgname prometheus
%if 0%{?rhel} == 8
  %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       2%{?dist}
Summary:       An open-source systems monitoring and alerting toolkit with an active ecosystem.
License:       ASL 2.0
URL:           https://prometheus.io/
Source0:       %{pkgname}-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


%description
[Use with BlueBanquise] Prometheus is a systems and service monitoring system. It collects metrics from
configured targets at given intervals, evaluates rule expressions, displays the
results, and can trigger alerts f some condition is observed to be true.

%prep
%setup -q -n %{pkgname}-%{version}.linux-amd64

%build

%pre


%install
%{__install} -d -m 750 %{buildroot}/var/lib/prometheus
%{__cp} -r consoles %{buildroot}/var/lib/prometheus
%{__cp} -r console_libraries %{buildroot}/var/lib/prometheus
%{__install} -d -m 750 %{buildroot}/var/lib/prometheus/data

%{__install} -d -m 755 %{buildroot}/etc/prometheus

%{__install} -d -m 755 %{buildroot}/usr/local/bin
%{__install} -m 755 prometheus %{buildroot}/usr/local/bin/prometheus
%{__install} -m 755 promtool %{buildroot}/usr/local/bin/promtool


%files
%defattr(-,root,root)
%config(noreplace) /etc/prometheus/prometheus.yml
/var/lib/prometheus/consoles
/var/lib/prometheus/console_libraries
/var/lib/prometheus/data
%attr(-,root,root)/usr/local/bin/prometheus
%attr(-,root,root)/usr/local/bin/promtool

%changelog
* Wed Nov 17 2022 Thomas Bourcey <sckyzo@gmail.com> - 2.40.0
- Initial packaging
