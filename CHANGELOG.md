# Changelog

All notable changes to this project will be documented in this file.

## Release 2.2.0

**Features**

* Added Puppet 9 support (Ruby 4.x agent runtime). The supported Puppet range
  is now `>= 7.24.0 < 10.0.0`.
* Updated to PDK 4.0.1 templates.
* Refreshed supported operating systems to match Puppet Core 9.1.0 agent
  platforms: RHEL, Rocky and AlmaLinux 8/9/10, Oracle Linux 8/9, Amazon
  Linux 2023, Debian 11/12/13, Ubuntu 22.04/24.04/26.04, SLES 12/15, Fedora 41,
  macOS 14/15/26 and Windows 11 and Server 2016/2019/2022/2025. Removed
  end-of-life platforms (CentOS, EL7, Ubuntu 20.04, Fedora 38/40, macOS 12/13
  and Windows 10).
* The task logic is now wrapped in an `AgentRunTags` module and covered by unit
  tests. It no longer requires `English`.
* CI runs validation and unit tests on Puppet 8 / Ruby 3.2 and Puppet 9 /
  Ruby 4.0, using a `PUPPET_FORGE_TOKEN` secret for puppetcore gems.

## Release 2.1.0

**Features**

* Consolidated the task into a single, cross-platform Ruby implementation
  (`tasks/agent_run_tags.rb`) that runs on Linux, macOS and Windows using the
  Puppet agent's bundled Ruby. This replaces the separate shell and PowerShell
  scripts introduced in 2.0.0 with one file to maintain.
* The task now reads its parameters from stdin (`input_method: stdin`).

**Breaking changes**

* The `flags` parameter is now an `Array[String]` (one flag per element, eg
  `flags=["--noop", "--debug"]`) rather than a single space-separated string.

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
