%define debug_package %{nil}
%global pkgname grok_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       Prometheus exporter for Grok
License:       Apache License 2.0
URL:           https://github.com/sysdiglabs/grok_exporter

Source0:       grok_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
[Use with BlueBanquise] Prometheus exporter for Grok 

%prep
%setup -n grok_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d %{buildroot}/etc/grok_exporter
%{__install} -d -m 755 %{buildroot}/etc/grok_exporter

%{__install} -D -m 755 grok_exporter %{buildroot}/usr/local/bin/grok_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/grok_exporter

%changelog
* Mon Mar 20 2024 Thomas Bourcey <sckyzo@gmail.com> - 1.0.0
- Initial packaging
