#!/usr/bin/env bash

let repo=$(checkupdates | wc -l)
let aur=$(pacaur -k | wc -l)

herbstclient emit_hook updates $((repo + aur))
