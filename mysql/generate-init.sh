#!/bin/sh
set -e
export $(grep -v '^#' .env | xargs)
envsubst <init.sql.template >init.sql
