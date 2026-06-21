#!/usr/bin/env bash
set -euo pipefail

RUNTIME_LIB="$HOME/Projects/sorbet/gems/sorbet-runtime/lib"

ruby -I "$RUNTIME_LIB" "./test.rb"
