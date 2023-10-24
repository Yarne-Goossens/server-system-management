#!/bin/bash
rsync -av -e "ssh -p 22345" "/etc/" "r0887519@leia.uclllabs.be:backups/etc_backup_$(date +'%Y.%m.%d_%H:%M:%S')"
