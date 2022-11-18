%define debug_package %{nil}
%global pkgname ha_cluster_exporter
%{!?pkgrevision: %global pkgrevision 1}
%if 0%{?rhel} == 8
 %define dist .el8
%endif

Name:          %{pkgname}
Version:       %{pkgversion}
Release:       %{pkgrevision}%{?dist}
Summary:       HA Cluster exporter
License:       Apache License 2.0
URL:           https://github.com/ClusterLabs/ha_cluster_exporter

Source0:       ha_cluster_exporter-%{version}.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     ha_cluster_exporter

%description
[Use with BlueBanquise] This is a bespoke Prometheus exporter used to enable the monitoring of Pacemaker based HA clusters.

%prep
%setup -n ha_cluster_exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -D -m 755 ha_cluster_exporter-amd64 %{buildroot}/usr/local/bin/ha_cluster_exporter


%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/ha_cluster_exporter

%changelog
* Wed Nov 17 2022 Thomas Bourcey <sckyzo@gmail.com> - 1.4.0
- Initial packaging
