%define debug_package %{nil}
%global pkgname ha_cluster_exporter
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
Summary:       HA Cluster exporter
License:       Apache License 2.0
URL:           https://github.com/ClusterLabs/ha_cluster_exporter

Source0:       ha_cluster_exporter-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     ha_cluster_exporter

%description
[Use with BlueBanquise] This is a bespoke Prometheus exporter used to enable the monitoring of Pacemaker based HA clusters.

%prep
%setup -n ha_cluster_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -D -m 755 ha_cluster_exporter %{buildroot}/usr/local/bin/ha_cluster_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/ha_cluster_exporter

%changelog
* Mon Apr 15 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Wed Nov 17 2022 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging

