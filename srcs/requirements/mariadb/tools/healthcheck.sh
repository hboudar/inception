#!/bin/bash

ROOT_PASS=$(cat /run/secrets/root_pass)
mysqladmin ping -uroot -p"${ROOT_PASS}" --silent
