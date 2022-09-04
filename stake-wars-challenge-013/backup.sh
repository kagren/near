#!/bin/bash

DATE=$(date +%Y-%m-%d-%H-%M)
DATADIR=/home/near/.near/data/
BACKUPDIR=/home/near/backups/near_${DATE}

mkdir $BACKUPDIR

sudo systemctl stop neard

wait

echo "NEAR node was stopped" | ts

if [ -d "$BACKUPDIR" ]; then
    echo "Backup started" | ts

    cp -rf $DATADIR ${BACKUPDIR}/

    echo "Backup completed" | ts
else
    echo $BACKUPDIR is not created. Check your permissions.
    exit 0
fi

sudo systemctl start neard

echo "NEAR node was started" | ts

# Tar and compress the folder
tar czf $BACKUPDIR.tar.gz $BACKUPDIR
# Remove backup dir
rm -rf $BACKUPDIR

# Keep only last 5 backups
rm `ls -t /home/near/backups/ | awk 'NR>5'`
