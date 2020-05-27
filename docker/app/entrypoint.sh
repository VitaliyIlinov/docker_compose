#!/bin/bash

if [ -z "$(find /docker/entrypoint.d -maxdepth 1 -type f  -name \"*.sh\" 2>/dev/null)" ]; then
    for file in /docker/entrypoint.d/*.sh; do
        chmod +x ${file};
        echo ${file} >> /var/log/php/sh_file.log
        ${file};
    done
fi

while true; do sleep 30; done;