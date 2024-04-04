%define debug_package %{nil}
%global pkgname podman_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       Prometheus exporter for Podman
License:       Apache License 2.0
URL:           https://github.com/treydock/podman_exporter

Source0:       podman_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
[Use with BlueBanquise] Prometheus exporter for Podman 

%prep
%setup -n podman_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d %{buildroot}/etc/podman_exporter
%{__install} -d -m 755 %{buildroot}/etc/podman_exporter

%{__install} -D -m 755 podman_exporter %{buildroot}/usr/local/bin/podman_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/podman_exporter

%changelog
* Mon Mar 20 2024 Thomas Bourcey <sckyzo@gmail.com> - 1.0.0
- Initial packaging
