# File-Killer
List user and system files you want to remove.

## Acknowledgement
Thanks to AndrewWCarson for reviewing this script and providing extremely valuable feedback regarding `dscacheutil`.

## Usage
To remove files from a managed macOS system, simply add file paths relative to `$HOME` in the `USER_FILES` array and/or absolute paths in the `SYSTEM_FILES` array. Paths in `USER_FILES` are iterated through each user's home directory on the system.
