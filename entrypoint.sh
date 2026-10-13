#!/bin/sh
# Wrapper entrypoint: receives luacheck arguments as individual positional parameters
# and passes them directly to luacheck, avoiding shell injection.
exec luacheck --no-cache "$@"
