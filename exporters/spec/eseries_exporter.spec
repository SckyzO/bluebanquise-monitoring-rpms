%define debug_package %{nil}
%global pkgname eseries_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       NetApp E-Series Prometheus exporter
License:       Apache License 2.0
URL:           https://github.com/treydock/eseries_exporter

Source0:       eseries_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     eseries_exporter

%description
[Use with BlueBanquise] The E-Series exporter collects metrics from NetApp E-Series via the SANtricity Web Services Proxy.

%prep
%setup -n eseries_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d -m 755 %{buildroot}/etc/%{name}

%{__install} -D -m 755 eseries_exporter %{buildroot}/usr/local/bin/eseries_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/eseries_exporter

%changelog
* Wed Nov 17 2022 Thomas Bourcey <sckyzo@gmail.com> - 1.4.0
- Initial packaging
