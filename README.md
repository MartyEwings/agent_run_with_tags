# agent_run_with_tags

#### Table of Contents

1. [Description](#description)
2. [Use cases](#use-cases)
3. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with agent_run_with_tags](#beginning-with-agent_run_with_tags)
4. [Usage](#usage)
    * [From the Puppet Enterprise console](#from-the-puppet-enterprise-console)
    * [With open source Puppet and Bolt](#with-open-source-puppet-and-bolt)
    * [Parameters](#parameters)
5. [Reference](#reference)
6. [Limitations](#limitations)
7. [Development](#development)

## Description

`agent_run_with_tags` provides a single, cross-platform task that triggers a
Puppet agent run restricted to a specific set of [tags](https://www.puppet.com/docs/puppet/latest/lang_tags.html),
optionally passing through additional `puppet agent` flags such as `--noop` or
`--debug`.

It fills a gap in the orchestrator: while you can trigger an on-demand agent run
from the Puppet Enterprise console or with Bolt, neither lets you scope that run
to `--tags` out of the box. This task gives you that control on demand, without
having to log in to each node.

The task ships as **one task with two implementations** — a Bash script for
Linux/Unix and macOS, and a PowerShell script for Windows. The task runner picks
the correct implementation automatically based on the target's available
features (`shell` vs `powershell`), so operators only ever see and select a
single task.

## Use cases

* **Targeted convergence** — apply only the part of the catalog you care about
  (eg `profile::ntp,profile::firewall`) across a fleet without running the full
  catalog, keeping runs fast and changes contained.
* **Safe previews** — combine a tag scope with `--noop` to preview exactly what
  a specific profile or class *would* change before committing to it.
* **Incident response / config drift** — re-assert a single security or
  compliance tag (eg `profile::ssh`) across many nodes immediately after a
  detected drift, rather than waiting for the next scheduled run.
* **Troubleshooting** — pair a narrow tag scope with `--debug` to get verbose
  output for just the resources you are investigating.
* **Phased rollouts** — drive a new tag through dev → test → prod node groups
  on demand as part of a controlled change window.

## Setup

### Setup requirements

* A Puppet agent must be installed on every target node. The task calls the
  agent binary directly (and falls back to the standard all-in-one install path
  if `puppet` is not on `PATH`).
* The orchestrator/Bolt must be able to reach and run tasks on the targets
  (PE orchestrator + PXP agent, or Bolt over SSH/WinRM).

### Beginning with agent_run_with_tags

* **Puppet Enterprise:** install the module into a Puppet environment (eg via a
  `Puppetfile` and Code Manager, or by uploading it to the module path). The
  task then appears in the **Tasks** list in the PE console.
* **Open source Puppet / Bolt:** add the module to your Bolt project's
  `Puppetfile` (or drop it under `modules/`) and run `bolt module install`.

## Usage

### From the Puppet Enterprise console

1. Go to **Run** > **Task**.
2. Select the `agent_run_with_tags` task.
3. Enter the `tags` parameter (and optional `flags`).
4. Choose your targets and run. PE selects the Bash or PowerShell
   implementation automatically per node.

### With open source Puppet and Bolt

Run a tagged agent run across a group of Linux and Windows targets:

```bash
bolt task run agent_run_with_tags tags='profile::ntp,profile::ssh' --targets all_nodes
```

Preview changes for a single tag in no-op mode with verbose output:

```bash
bolt task run agent_run_with_tags tags='profile::firewall' flags='--noop --debug' --targets web_servers
```

The same invocation works against Windows targets reached over WinRM — no
separate task or different parameters are required.

### Parameters

| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| `tags`  | Yes | String | Comma-separated list of tags **with no spaces**, eg `profile::ntp,profile::ssh`. |
| `flags` | No  | String | Space-separated additional `puppet agent` flags, eg `--noop --debug --no-noop`. |

> **Note on upgrading from 1.x:** the previous `param1` / `param2` parameters
> have been replaced by a single `flags` parameter. Instead of
> `param1='--noop' param2='--debug'`, pass `flags='--noop --debug'`.

The task always runs the agent in test mode (`puppet agent --test`) so that the
run executes immediately in the foreground and its exit code is returned to the
orchestrator.

## Reference

This module contains a single Bolt task, `agent_run_with_tags::agent_run_tags`,
with implementations for:

* `agent_run_tags.sh` — used on targets exposing the `shell` feature (Linux,
  Unix, macOS).
* `agent_run_tags.ps1` — used on targets exposing the `powershell` feature
  (Windows).

## Limitations

* Requires a Puppet agent to be installed on each target.
* Tag names must be supplied as a single comma-separated string with no spaces.
* Supported operating systems are listed in
  [`metadata.json`](metadata.json). The module targets currently supported
  Puppet 7 and Puppet 8 releases (and the Puppet Enterprise versions that ship
  them).

## Development

Contributions are welcome via pull request. This module is maintained with the
[Puppet Development Kit (PDK)](https://www.puppet.com/docs/pdk/latest/pdk.html).

```bash
pdk validate    # metadata, task and ruby validation
pdk test unit   # run the spec suite
```

The `rake shellcheck` task is also available to lint the shell implementation
(requires `shellcheck` to be installed).
