#!/bin/sh
set -e

# Load .env vars from all relevant sources
export $(grep -v '^#' .env | xargs)

# Generate sql.conf
envsubst <./config/templates/sql.conf.template >./config/pdns.d/sql.conf
envsubst <./config/templates/api.conf.template >./config/pdns.d/api.conf
