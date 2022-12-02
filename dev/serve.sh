#!/bin/sh

nix run github:NixOS/nixpkgs?rev=ec21b5b3a908e998ef4cddd24052f4dd63f7691a#caddy -- file-server --listen=:8080 --browse
