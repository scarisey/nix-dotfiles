#!/bin/sh
SCRIPTNAME=$(basename "$0")
RUNDIR=$(dirname "$(realpath $0)")

if ! command -v nix &> /dev/null
then
  echo "Nix is not installed"
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  mkdir -p ~/.local/state/nix/profiles/
  echo "Please run install.sh again"
  exit 0
fi


nix run ${RUNDIR} switch
