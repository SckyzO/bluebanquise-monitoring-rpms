%define debug_package %{nil}
%global pkgname rackpower_exporter
%{!?pkgversion: %global pkgversion 1.0}
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
Summary:       Prometheus exporter for RackPower
License:       Apache License 2.0
URL:           https://eviden.com

# The source is now a tarball containing the python script and default config
Source0:       %{pkgname}-%{version}.tar.gz

BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

# Add dependencies required by the python script
BuildRequires: python3-devel
Requires:      python3-pyyaml
Requires:      python3-urllib3
Requires:      python3-prometheus_client
Requires:      python3-clustershell

Obsoletes:     rackpower_exporter

%description
[Use with BlueBanquise] Prometheus exporter for Sequana 3 Rack Power 

%prep
%setup -q -n %{pkgname}-%{version}

%build
# Nothing to build, it's a python script

%pre

%install
# Install the python script
%{__install} -D -m 755 rackpower_exporter %{buildroot}%{_bindir}/rackpower_exporter

# Install the default configuration file
%{__mkdir} -p %{buildroot}/etc/rackpower_exporter
%{__install} -D -m 644 rackpower.yml %{buildroot}/etc/rackpower_exporter/rackpower.yml

%files
%defattr(-,root,root,-)
%{_bindir}/rackpower_exporter
%config(noreplace) /etc/rackpower_exporter/rackpower.yml
%dir /etc/rackpower_exporter

%changelog
* Wed Jun 17 2024 Thomas Bourcey <thomas.bourcey@eviden.com> - 1.0.0
- Initial packaging
