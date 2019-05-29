
# agent_run_with_tags

## Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with agent_run_with_tags](#setup)
    * [What agent_run_with_tags affects](#what-agent_run_with_tags-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with agent_run_with_tags](#beginning-with-agent_run_with_tags)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

The Task in this module fills a hole in orchestrators native abilities. It allows you to run puppet agent with the `--tags` options on linux nodes running a bash shell.

By default it requires a comma separated list of tags (no spaces). There are also 2 additional optional parameters param1 and param2 which can be used to pass standard puppet agent flags, such as `--noop` or `--debug`

## Setup

### Beginning with agent_run_with_tags  

Install the module, the tasks will be populated in the tasks dropdown in the PE console

## Usage

This task can be run against any linux node with a bash shell, it takes up to 3 parameters:

* `tags` (mandatory) - a comma separated list of tags (no spaces)
* `param1` (optional) parameter that can be used to pass any agent flag, valid options include `--debug --noop --fingerprint`
* `param2` (optional) a second parameter incase one is not enough

## Reference

## Limitations

Restricted to use on linux platforms with a bash shell

## Development