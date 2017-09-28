#!/bin/bash

JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE-full.xml"}
JBOSS_OPTS=$JBOSS_HOME/bin/$JBOSS_MODE.conf

function wait_for_wildfly() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 1
  done
}
#issue#1. Possible solution is to set user.timezone environment variable
#echo "==> Patching Java TimeZone info..."
#PATCH_STR='JAVA_OPTS="$JAVA_OPTS -Duser.timezone=UTC+02:00"'
#todo: fix escaping for grep
#grep -q -F 'JAVA_OPTS="$JAVA_OPTS -Duser.timezone=UTC+02:00"' $JBOSS_OPTS || echo "$PATCH_STR\n" >> $JBOSS_OPTS

echo "==> Starting WildFly..."
$JBOSS_HOME/bin/$JBOSS_MODE.sh -c --server-config=standalone-full.xml > /dev/null &

echo "==> Waiting..."
wait_for_wildfly

echo "==> Executing..."
$JBOSS_CLI -c --file=`dirname "$0"`/command.cli

echo "==> Shutting down WildFly..."
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi
