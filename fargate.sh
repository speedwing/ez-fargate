#!/usr/bin/env bash

set -o errexit

SELF=$(basename $0)
UPDATE_BASE=https://raw.githubusercontent.com/speedwing/ez-fargate/master

runSelfUpdate() {

  # Copy over modes from old version
  OCTAL_MODE=$(stat -f %Mp%Lp $SELF)
  if ! chmod $OCTAL_MODE "$0.tmp" ; then
    echo "Failed: Error while trying to set mode on $0.tmp."
    exit 1
  fi

  # Spawn update script
  cat > updateScript.sh << EOF
#!/bin/bash
# Overwrite old file with new
if mv "$0.tmp" "$0"; then
  echo "Done. Update complete."
  rm \$0
else
  echo "Failed!"
fi
EOF

  echo -n "Updating script and exiting, update version control!"
  exec /bin/bash updateScript.sh
}

# Download latestversion
echo -n "Downloading latest version..."
if ! wget --quiet --output-document="$0.tmp" $UPDATE_BASE/$SELF ; then
    echo "Failed: Error while trying to wget new version!"
    echo "File requested: $UPDATE_BASE/$SELF"
    exit 1
fi
echo "Done."

CURRENT_MD5=$(md5 -q $SELF)
LATEST_MD5=$(md5 -q $0.tmp)

if [ ! "$a" == "$b" ];   then
    runSelfUpdate
fi

echo "Executing Script!"
