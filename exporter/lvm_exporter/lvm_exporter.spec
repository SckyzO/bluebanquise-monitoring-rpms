%define debug_package %{nil}
%global pkgname lvm_exporter
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
Summary:       Prometheus exporter for LVM metrics.
License:       Apache License 2.0
URL:           https://github.com/hansmi/prometheus-lvm-exporter

Source0:       lvm_exporter-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     lvm_exporter

%description
[Use with BlueBanquise] Prometheus exporter for the Logical Volume Manager. It is only compatible with Linux
and has been tested with LVM 2.03. All fields related to physical volumes, volume groups and logical volumes 
are reported, either as a standalone metric for numeric values or as a label on a per-entity info metric.

%prep
%setup -n prometheus-lvm-exporter_%{version}_linux_amd64

%build

%pre

%install
%{__install} -D -m 755 prometheus-lvm-exporter %{buildroot}/usr/local/bin/lvm_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/lvm_exporter

%changelog
* Mon Apr 15 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Wed Nov 17 2022 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
