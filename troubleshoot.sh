#!/usr/bin/env bash

sudo dnf -y install setroubleshoot-server

sudo ausearch \
              -m avc,user_avc,selinux_err,user_selinux_err \
              -ts recent > ausearch.out

