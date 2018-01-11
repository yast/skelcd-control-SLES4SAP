#
# spec file for package skelcd-control-SLES4SAP
#
# Copyright (c) 2016 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


######################################################################
#
# IMPORTANT: Please do not change the control file or this spec file
#   in build service directly, use
#   https://github.com/yast/skelcd-control-SLES4SAP4SAP repository
#
#   See https://github.com/yast/skelcd-control-SLES4SAP4SAP/blob/master/CONTRIBUTING.md
#   for more details.
#
######################################################################

Name:           skelcd-control-SLES4SAP
# xsltproc for converting SLES control file to SLES-for-VMware
BuildRequires:  libxslt-tools
# xmllint (for validation)
BuildRequires:  libxml2-tools
# RNG validation schema
BuildRequires: yast2-installation-control

# original SLES control file
BuildRequires: skelcd-control-SLES >= 15.0.0
BuildRequires: diffutils

Provides:       system-installation() = SLES_SAP

#
######################################################################

Url:            https://github.com/yast/skelcd-control-SLES4SAP
AutoReqProv:    off
Version:        15.0.1
Release:        0
Summary:        SLES4SAP control file needed for installation
License:        MIT
Group:          Metapackages
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source0:        installation.SLES4SAP.xsl

%description
SLES4SAP control file needed for installation

%prep

%build
# transform ("patch") the original SLES installation file
xsltproc %{SOURCE0} /installation.xml > installation.xml
#xsltproc %{SOURCE0} /installation.xml > installation1.xml
#xmllint --format installation1.xml > installation.xml
diff -u /installation.xml installation.xml || :

%check
#
# Verify syntax
#
#xmllint --noout --relaxng /usr/share/YaST2/control/control.rng installation.xml

%install
#
# Add installation file
#
install -m 644 installation.xml $RPM_BUILD_ROOT/

%files
%defattr(644,root,root,755)
/installation.xml

%changelog
