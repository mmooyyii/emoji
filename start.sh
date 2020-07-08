#!/bin/sh

./rebar3 compile
erl \
-pa _build/default/lib/*/ebin \
-name "emoji@127.0.0.1" \
-run load_all_module start \
-setcookie abc