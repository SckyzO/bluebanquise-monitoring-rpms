%define debug_package %{nil}
%global pkgname slurm_exporter
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
Summary:       Prometheus exporter for performance metrics from Slurm.
License:       Apache License 2.0
URL:           https://github.com/vpenso/prometheus-slurm-exporter

Source0:       slurm_exporter-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     slurm_exporter

%description
[Use with BlueBanquise] Prometheus collector and exporter for metrics extracted from the Slurm resource scheduling system.

%prep
%setup -n slurm_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -D -m 755 prometheus-slurm-exporter %{buildroot}/usr/local/bin/slurm_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/slurm_exporter

%changelog
* Tue Apr 25 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Wed Nov 17 2022 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
