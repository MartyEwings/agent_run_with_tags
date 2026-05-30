# Changelog

All notable changes to this project will be documented in this file.

## Release 2.0.0

**Features**

* Modernised to PDK 3.4.0 templates.
* The task is now cross-platform: a single task with `shell` (Bash) and
  `powershell` (Windows) implementations, presented as one task in the console.
* Added Windows support via a new PowerShell implementation.
* Refreshed supported operating systems to current Enterprise Linux 7/8/9
  (RedHat, CentOS, Oracle, Rocky, AlmaLinux), Debian 11/12, Ubuntu
  20.04/22.04/24.04, SLES 12/15, Fedora 38/40, macOS and Windows 10/11 and
  Server 2016–2025.
* Updated Puppet requirement to `>= 7.24.0 < 9.0.0` (Puppet 7 and 8, covering
  current Puppet Enterprise releases).
* Rewrote the README around use cases and both Puppet Enterprise and open
  source Puppet/Bolt.

**Breaking changes**

* The `param1` and `param2` parameters have been replaced by a single,
  space-separated `flags` parameter, eg `flags='--noop --debug'`.
* Dropped support for end-of-life operating systems and Puppet 4/5/6.

## Release 1.0.1

Fixes for empty variables https://github.com/MartyEwings/agent_run_with_tags/issues/2)
Formatting

## Release 1.0.0

Updated to PDK 1.10.0


## Release 0.1.0

**Features**

**Bugfixes**

**Known Issues**
