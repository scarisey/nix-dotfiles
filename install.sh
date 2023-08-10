#!/bin/bash
SCRIPTNAME=$(basename "$0")
RUNDIR=$(dirname "$(realpath $0)")

if [[ "$(command -v nix)" = "" ]]; then
	echo "Nix is not installed"
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	mkdir -p ~/.local/state/nix/profiles/
else
	echo "Nix already installed"
fi
exit 0
