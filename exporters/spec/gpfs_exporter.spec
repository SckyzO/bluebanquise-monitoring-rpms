%define debug_package %{nil}
%global pkgname gpfs_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       GPFS Prometheus exporter
License:       Apache License 2.0
URL:           https://github.com/treydock/gpfs_exporter

Source0:       gpfs_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     gpfs_exporter

%description
[Use with BlueBanquise] The GPFS exporter collects metrics from the GPFS filesystem. The exporter supports the /metrics endpoint to gather GPFS metrics and metrics about the exporter.

%prep
%setup -n gpfs_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -d -m 755 %{buildroot}/etc/%{name}

%{__install} -D -m 755 gpfs_exporter %{buildroot}/usr/local/bin/gpfs_exporter
%{__install} -D -m 755 gpfs_mmdf_exporter %{buildroot}/usr/local/bin/gpfs_mmdf_exporter
%{__install} -D -m 755 gpfs_mmlssnapshot_exporter %{buildroot}/usr/local/bin/gpfs_mmlssnapshot_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/gpfs_exporter
%attr(-, root, root) /usr/local/bin/gpfs_mmdf_exporter
%attr(-, root, root) /usr/local/bin/gpfs_mmlssnapshot_exporter

%changelog
* Wed Nov 17 2022 Thomas Bourcey <sckyzo@gmail.com> - 1.4.0
- Initial packaging
