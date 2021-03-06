# foreman\_discovery

This plugin enables MaaS hardware discovery in Foreman.

# Documentation

The main documentation can be found in [Foreman Discovery 2.0 Manual] (http://theforeman.org/plugins/foreman_discovery/2.0/).

## Latest code

If a source-based install of Foreman is in use, the develop
branch of the plugin can be obtained by updating the Gemfile in this way:

    gem 'foreman_discovery', :git => "https://github.com/theforeman/foreman_discovery.git"

# API

see the [API README](README.api.md)

## Reporting bugs

We use [RedMine instance](http://projects.theforeman.org/projects/discovery/issues)
instead of github.com issues. Please report issues there.

## Grace Note: Testing

If you only wish to test the plugin code itself, you don't need to create the PXE boot
image above, or have a TFTP server to run it from. Simply POST a hash of Host Facts to
`/api/v2/discovered_hosts/facts` to create a Discovered Host in the UI.

# Copyright

Copyright (c) 2012-2014 Greg Sutcliffe and The Foreman developers

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
