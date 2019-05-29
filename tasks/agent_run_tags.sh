#!/bin/bash

# Puppet Task Name: agent_run_tags
#
declare -a PT_params=(${PT_param1} ${PT_param2})
puppet agent -t "${PT_params[@]}" --tags "${PT_tags}"