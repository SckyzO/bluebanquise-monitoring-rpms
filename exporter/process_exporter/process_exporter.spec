%define debug_package %{nil}
%global pkgname process_exporter
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
Summary:       Prometheus exporter that mines /proc to report on selected processes
License:       Apache License 2.0
URL:           https://github.com/ncabatoff/process-exporter

Source0:       process_exporter-%{version}.linux-amd64.tar.gz
BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Obsoletes:     process_exporter

%description
[Use with BlueBanquise] Prometheus exporter that mines /proc to report on selected processes.

Some apps are impractical to instrument directly, either because you don't control the code 
or they are written in a language that isn't easy to instrument with Prometheus. We must 
instead resort to mining /proc.

%prep
%setup -n process-exporter-%{version}.linux-amd64

%build

%pre

%install
%{__install} -D -m 755 process-exporter %{buildroot}/usr/local/bin/process_exporter

%files
%defattr(-,root,root,-)
%attr(-, root, root) /usr/local/bin/process_exporter

%changelog
* Tue Apr 25 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.1
- Complete overhaul of the spec file and added support for RHEL 9 builds.

* Wed Nov 17 2022 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
