#!/usr/bin/env bash

# Puppet Task Name: agent_run_tags (shell implementation)
#
# Triggers a Puppet agent run restricted to the supplied --tags, with any
# optional extra agent flags. Parameters are provided as environment variables
# (PT_tags, PT_flags) by the task runner.

set -euo pipefail

# Locate the puppet binary. PATH is not guaranteed to include the agent's bin
# directory when invoked non-interactively, so fall back to the AIO location.
if command -v puppet >/dev/null 2>&1; then
  PUPPET="$(command -v puppet)"
elif [ -x /opt/puppetlabs/bin/puppet ]; then
  PUPPET=/opt/puppetlabs/bin/puppet
else
  echo "Unable to locate the puppet executable on PATH or in /opt/puppetlabs/bin" >&2
  exit 1
fi

# Split the optional, space-separated flags into an array without tripping over
# an unset or empty value (read -ra yields an empty array for empty input). The
# ${FLAGS[@]+...} guard expands to nothing on an empty array, which keeps older
# bash (eg 4.2 on RHEL 7) from erroring under `set -u`.
read -ra FLAGS <<< "${PT_flags:-}"

exec "${PUPPET}" agent --test --tags "${PT_tags}" ${FLAGS[@]+"${FLAGS[@]}"}
