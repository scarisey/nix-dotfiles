#!/bin/sh
SCRIPTNAME=$(basename "$0")
RUNDIR=$(dirname "$(realpath $0)")

nix run ${RUNDIR} -- switch --flake ${RUNDIR}
