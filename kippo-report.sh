#!/bin/bash

LOG_DIR="/opt/kippo/log"
DL_DIR="/opt/kippo/dl"

PLAYLOG="/opt/kippo/utils/playlog.py"
SESSION_ID="0"  # I've never seen a Kippo logfile with multiple IDs, if I'm wrong, let me know

REPORT_FILE=`/bin/mktemp`

#Number of days worth of sessions to list.
DAYS=1

ECHO="/bin/echo -e"
FILE="/usr/bin/file"


# TTY sessions in last $DAYS
# () make an array rather than string
RECENT_TTY=(`/usr/bin/find $LOG_DIR/tty -ctime -$DAYS`)

$ECHO "***Sessions***\n\n" >> $REPORT_FILE

for TTY in "${RECENT_TTY[@]}"
do
        $ECHO "---START:$TTY---" >> $REPORT_FILE

        # set -m to 0 to reduce run time
        $PLAYLOG -m 0 $TTY $SESSION_ID >> $REPORT_FILE

        $ECHO "\n---END:$TTY---\n\n" >> $REPORT_FILE

done

# new downloads in last $DAYS
RECENT_DL=(`/usr/bin/find $DL_DIR/ -ctime -$DAYS`)

$ECHO "***DOWNLOADS***\n\n" >> $REPORT_FILE
for DL in "${RECENT_DL[@]}"
do
        $FILE $DL >> $REPORT_FILE
done

/bin/cat $REPORT_FILE
