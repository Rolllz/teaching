Name:           my_app
Version:        1.0
Release:        1%{?dist}
Summary:        A simple web app

License:        GPLv3
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  golang
BuildRequires:  systemd-rpm-macros

Provides:	%{name} = %{version}

%description
A simple web app

%global debug_package %{nil}

%prep
%autosetup


%build
go mod init my_app
go build -v -o %{name}


%install
install -Dpm 0755 %{name} %{buildroot}%{_bindir}/%{name}
install -Dpm 0755 config.json %{buildroot}%{_sysconfdir}/%{name}/config.json
install -Dpm 644 %{name}.service %{buildroot}%{_unitdir}/%{name}.service

%check
# go test should be here... :)

%post
%systemd_post %{name}.service

%preun
%systemd_preun %{name}.service

%files
%dir %{_sysconfdir}/%{name}
%{_bindir}/%{name}
%{_unitdir}/%{name}.service
%config(noreplace) %{_sysconfdir}/%{name}/config.json

%changelog
* Tue Feb 13 2024 Ivan Razepov - 1.0-1
- First release%changelog
