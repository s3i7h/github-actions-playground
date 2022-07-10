#!/usr/bin/env bash
# envrn.sh - The ultimate bash task runner

# define each task as bash functions

_check_poetry() {
    if ! which poetry >/dev/null 2>&1; then
        echo -n "poetry not installed. would you like to install and continue? [Y/n]:"
        read -n1 ans
        if [ "$ans" != "n" ]; then
            curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
            return 0
        fi
        return 1
    fi
}

_check_installed() {
    if [ "$(poetry env info -p)" == "" ]; then
        echo -n "poetry env is not set up. would you like to run poetry install? [Y/n]:"
        read -n1 ans
        if [ "$ans" != "n" ]; then
            poetry install
            return 0
        fi
        return 1
    fi
}

setup() {
    _check_poetry || return 1
    poetry install
}

run() {
    _check_poetry || return 1
    _check_installed || return 1
    poetry run python src/main.py 2 3
}

test() {
    _check_poetry || return 1
    _check_installed || return 1
    poetry run python -m pytest
}

shell() {
    exec $SHELL
}

# add descriptions to each task

help() {
    cat << EOF
Usage: envrn.sh TASK|COMMAND [OPTIONS]

TASK:
    setup:  set up the project
    run:    run the main script
    shell:  enters a new shell with .env read into
    help:   show this message
COMMAND:
    any command that will be run with .env read into
EOF
}

# --------------- envrn.sh -----------------
# (C) 2021 Yuichiro Smith <contact@yu-smith.com>
# This script is distributed under the Apache 2.0 License
# See the full license at https://github.com/yu-ichiro/envrn.sh/blob/main/LICENSE

# save the original PWD
__PWD__=$PWD
# save the path of directory which ./envrn.sh is included
__DIR__="$(
  src="${BASH_SOURCE[0]}"
  while [ -h "$src" ]; do
    dir="$(cd -P "$(dirname "
    }$src")" && pwd)"
    src="$(readlink "$src")"
    [[ $src != /* ]] && src="$dir/$src"
  done
  printf %s "$(cd -P "$(dirname "$src")" && pwd)"
)"
# move to __DIR__
cd -P $__DIR__

_load_env() {
    # load envs declared as ENV_VAR=VALUE in files, process substitutions without overriding existing envs
    files="$(cat "$@" <(echo) <(declare -x | sed -E 's/^declare -x //g'))"
    set -a; eval "$files"; set +a;
}

if [ -e '.env' ];then
    _load_env .env
fi

task=${1:-help}
shift
$task "$@"
