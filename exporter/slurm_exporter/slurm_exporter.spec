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
URL:           https://github.com/sckyzo/slurm_exporter

Source0:       %{pkgname}-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%global __requires_exclude ^libc\.so\.6.*$  

Obsoletes:     %{pkgname}

%description
[Use with BlueBanquise] Prometheus collector and exporter for metrics extracted from the Slurm resource scheduling system.

%prep
%setup -q -c -T
tar -xf %{SOURCE0}

%build

%install
%{__install} -D -m 755 slurm_exporter %{buildroot}/usr/local/bin/slurm_exporter

%files
%defattr(-,root,root,-)
%attr(0755,root,root) /usr/local/bin/slurm_exporter

%changelog
* Fri Feb 14 2024 Thomas Bourcey<thomas.bourcey@eviden.com> - 1.1
- Replace vpenso by cea slurm_exporter 0.20.1

* Tue Jan 2 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Adjusted spec file for archive without directory structure.

* Wed Nov 16 2022 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging.

