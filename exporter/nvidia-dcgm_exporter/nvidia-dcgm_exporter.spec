%define debug_package %{nil}
%global pkgname nvidia-dcgm_exporter
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
Summary:       Prometheus exporter for Nvidia DCGM
License:       Apache License 2.0
URL:           https://github.com/treydock/nvidia-dcgm_exporter

Source0:       nvidia-dcgm_exporter-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     nvidia-dcgm_exporter

%description
[Use with BlueBanquise] Prometheus exporter for Nvidia DCGM 

%prep
%setup -n nvidia-dcgm_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d %{buildroot}/etc/nvidia-dcgm_exporter
%{__install} -d -m 755 %{buildroot}/etc/nvidia-dcgm_exporter

%{__install} -D -m 755 nvidia-dcgm_exporter %{buildroot}/usr/local/bin/nvidia-dcgm_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/nvidia-dcgm_exporter

%changelog
* Tue Apr 25 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Mon Mar 20 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
