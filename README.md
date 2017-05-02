puppet-serf
===========

[![Build Status](https://secure.travis-ci.org/inkblot/puppet-serf.png)](http://travis-ci.org/inkblot/puppet-serf)

## Description
Deploy and control the [Serf](https://serfdom.io/) cluster agent.

=======

Overview
--------

The Serf module provides an interface for deploying and managing the Serf
cluster agent, including installation of the agent by various methods, control
over agent configuration, and assurance that it is running.

Setup
-----

For best results, use this module in a hiera-configured Puppet environment. In
such an environment, it is only necessary to include the following in your node
definitions:

```puppet
include serf
```

Supply of class parameter values may then occur through hiera implicit lookup.

Classes
-------

## Class `serf`

This is the main class in the module. In general, this is the class that should
be included in the node catalog in order install, configure, and run a Serf
agent.

### Parameters

#### `node_name`

The name that the agent will use on the Serf network to self-identify. Default:
`'${::fqdn}'`

#### `protocol`

The protocol version that the Serf agent will use when communicating with other
agents in its network. Default: `'4'`

#### `advertise`

The IP address that the agent will use on the Serf network. This address is the
one that other agents will attempt to connect to. In general, the `bind`
parameter should be set to the same value or to `'0.0.0.0'` so that incoming
connections to the advertised address reach an open port. Firewall and/or NAT
rules in your environment may alter this relationship. Default:
`'${::ipaddress}'`

#### `bind`

The local IP address that Serf will bind to in order to accept incoming
connections. The default value effectively disables Serf's ability to build a
network of nodes, but is included as a safe default for new deployments that
might not be fully hardened. In a secured operating environment, `'0.0.0.0'` or
`'${::ipaddress}'` may be an acceptable estate-wide value. Default:
`'127.0.0.1'`

#### `discover`

A cluster name to query and respond to via mDNS. Serf can use this to
autodiscover peers in a multicast-capable environment. Default: `''`

#### `encrypt_key`

The Base-64 encoded 16-byte key that the Serf agent will use to encrypt and
decrypt its communication with the Serf network. This value must be the same
across all nodes in the cluster. The easist way to generate a value for this
parameter is to run the command `serf keygen` on a system where serf is already
installed. In lieu of such a system, `dd if=/dev/random count=16 | base64` will
also work. The default value is not suitable for a production environment.
Default: `''`

#### `event_handlers`

An array of files that the Serf agent will use as event handlers. These files
must 1) exist, 2) be executable and 3) implement the
[interface](https://www.serfdom.io/intro/getting-started/event-handlers.html)
described in Serf's documentation in order for them to work. No event handlers
are configured by default. Default: `[]`

#### `tags`

A hash of tags that the Serf agent will have on startup. Additional tags may be
added and any tag may be removed on a running Serf agent via its RPC interface.
By default, the agent is configured with no tags. Default: `{}`

#### `start_join`

An array of DNS names or IP addresses that the Serf agent will use on startup
to establish communication with the Serf network. Default: `[]`

#### `profile`

The timing profile for the agent. Valid values are `'lan'`, `'wan'`, and
`'local'`.  This selects a regime of timeouts related to network membership,
non-communication, and failure that is appropriate for various stock
environments. Serf's internal default is `lan`, and the module default will
defer to this. Default: `''`

#### `rpc_address`

The address that Serf will bind to for the agent's RPC interface. This
interface allows clients to affect various states and actions in the Serf
network as well as to gather information from the Serf network. A blank value
will disable the RPC interface. Default: `'127.0.0.1'`.

#### `rpc_port`

The port that Serf will open for RPC requests. Default: `'7373'`

#### `rpc_auth`

An authorization token for RPC requests. Serf will reject requests that do not
present the correct authorization token. A blank value will disable RPC
authorization, causing the agent to accept any RPC request. The default value
is not suitable for a production environment. Default: `''`

#### `log_level`

The minimum log message severity which is required before Serf will output a
log message. Log messages will be sent to syslog's LOCAL0 facility. Default:
`'info'`

#### `install_class`

The name of the Puppet class that will be included into the catalog in order to
install Serf. Any arbitrary Puppet class may fill this role, however the
supplied class must cause the `serf` binary to be present in the filesystem. If
this file is located somewhere other than `/usr/local/bin`, then the
`install_path` parameter will need to be set appropriately so that the module
can use the installed file. The module includes two classes which may be used
to install Serf, `serf::install::download` and `serf::install::package`, which
are documented separately. Default: `serf::install::download`

#### `config_dir`

The directory where the module creates the Serf configuration file. Default:
`'/etc/serf'`

#### `config_owner`

The user that will own Serf's configuration file. Default: `'root'`

#### `config_group`

The group that will own Serf's configuration file. Default: `'root'`

#### `service_class`

The name of the Puppet class that will be included into the catalog in order to
configure Serf as a service. Any arbitrary Puppet class may fill this role,
however the supplied class must leave the system in a state such that Puppet's
`service` resource recognises `serf` as valid and extant. The module includes
three classes which may be used for this purpose, `serf::service::initscript`,
`serf::service::systemd` and `serf::service::upstart`, which are documented separately.
An empty value of `''` may be used if no additional configuration is necessary
in order to satisfy the `service` resource requirement (for example, when using
`serf::install::package` to install a package that contains appropriate service
configuration). Default: on Debian-based, and Redhat family 6 platforms:`serf::service::initscript`,
on Ubuntu: `serf::service::upstart`, on Redhat family 7 : `serf::service::systemd`

#### `service_enable`

Serf service status. Default: `'running'`

#### `service_enable`

Serf service state at boot. Default: `'true'`

#### `install_path`

The path where the `serf` binary is located. Installation of the file at this
location is the responsibility of the `install_class`. The default
`install_class` responds to this parameter. Default: `'/usr/local/bin'`


## Class `serf::install::download`

This class installs the `serf` binary by downloading the zip file from Serf's
official download site and extracting the file.

### Parameters

#### `version`

The version of Serf to install. This may be any version that is available from
Serf's official download site, but it must be an explicit version. Default:
`'0.6.3'`

#### `install_path` (Private)

The path where the `serf` binary is located. This parameter need not be set.
Default: `${::serf::install_path}`

## Class `serf::install::package`

This class installs the `serf` binary by installing a package using Puppet's
`package` resource. The package may include appropriate configuration files to
run the Serf agent as a service, and will most likely not install the binary in
`/usr/local/bin`, and so when using this class you may also need to set
`serf::install_path` and `serf::service_class` appropriately.

### Parameters

#### `version`

The version of Serf to install. This may be any permissible value of the
`package` resource's `ensure` parameter. Default: `present`

## Class `serf::service::initscript`

This class configures Serf as a service by installing an initscript-style
startup script.

### Parameters

#### `install_path` (Private)

The path where the `serf` binary is located. This parameter need not be set.
Default: `${::serf::install_path}`

#### `config_dir` (Private)

The path where the `serf.conf` configuration file is located. This parameter
need not be set. Default: `${::serf::config_dir}`

## Class `serf::service::systemd`

This class configures Serf as a service by installing an systemd-style
startup script.

### Parameters

#### `install_path` (Private)

The path where the `serf` binary is located. This parameter need not be set.
Default: `${::serf::install_path}`

#### `config_dir` (Private)

The path where the `serf.conf` configuration file is located. This parameter
need not be set. Default: `${::serf::config_dir}`

## Class `serf::service::upstart`

This class configures Serf as a service by installing an upstart configuration
file.

### Parameters

#### `install_path` (Private)

The path where the `serf` binary is located. This parameter need not be set.
Default: `${::serf::install_path}`

#### `config_dir` (Private)

The path where the `serf.conf` configuration file is located. This parameter
need not be set. Default: `${::serf::config_dir}`

Platform Support
----------------

This module is known to work on:

* Ubuntu 14.04 Trusty Tahr
* Ubuntu 12.04 Precise Pangolin
* Debian 7.x wheezy
* Redhat/CentOS 7
* Redhat/ CentOS 6
* Raspbian

Pull requests enabling use of the module on additional platforms are welcome.

Author
------

Nate Riffe <inkblot@movealong.org>

Thanks
------

David Collom - for the first serf module that I used before I decided to write my own.
