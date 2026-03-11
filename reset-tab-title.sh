#!/bin/sh
# Restore the previously saved tab title
printf '\e[23;0t' > /dev/tty
