#!/bin/bash

npm install
psql -a -f pgscript.sql
