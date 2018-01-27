#!/bin/bash
#
# Copyright 2018 Benjamin Moralez
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

USER_FILES=(
  ''
)

SYSTEM_FILES=(
)

LOG_FILE='/Library/Addigy/logs/file-removal.log'

removeFiles(){
  logFileRemoval "${TARGET_FILE}"
  /bin/rm -Rf "${TARGET_FILE}"
}

logFileRemoval(){
  if [[ ! -e $LOG_FILE ]]; then
    /usr/bin/touch "$LOG_FILE"
  fi
  /usr/bin/printf "%s Removing: '%s'\n" "$(/bin/date "+%Y/%m/%d %H:%M:%S")" "$*" | tee -a "$LOG_FILE"
}

OIFS="$IFS"
IFS=$'\n'

for USER in $(/usr/bin/dscl . list /Users UniqueID | /usr/bin/awk '$2 >= 500 {print $1}'); do
  HOME_DIR=$(/usr/bin/dscacheutil -q user -a name $USER | /usr/bin/grep -E '^dir: ' | /usr/bin/awk '{ print $2 }')
  export HOME_DIR
  for FILE_ABSTRACTION in "${USER_FILES[@]}"; do
    FILE_ABSTRACTION="$(/usr/bin/printf "$FILE_ABSTRACTION" | /usr/bin/sed 's_^\~__' | /usr/bin/sed 's_^/__')"
    TARGET_FILE="${HOME_DIR}/${FILE_ABSTRACTION}"
    if [[ $FILE_ABSTRACTION != '' ]]; then
      removeFiles "$TARGET_FILE"
    fi
  done
done

for TARGET_FILE in "${SYSTEM_FILES[@]}"; do
  removeFiles "$TARGET_FILE"
done

IFS="$OIFS"
