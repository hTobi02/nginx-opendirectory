#!/bin/bash

# mergerfs-union.sh
# Usage: ./mergerfs-union.sh /pfad/zu/quelle /pfad/zum/mountpunkt

SRC="$1"
DST="$2"

if [[ -z "$SRC" || -z "$DST" ]]; then
  echo "Nutzung: $0 <Quellverzeichnis> <Mountpunkt>"
  exit 1
fi

if [[ ! -d "$SRC" ]]; then
  echo "Fehler: Quellverzeichnis '$SRC' existiert nicht."
  exit 2
fi

if [[ ! -d "$DST" ]]; then
  echo "Mountpunkt '$DST' existiert nicht. Erstelle ihn..."
  mkdir -p "$DST" || exit 3
fi

# Get all subdirectories
DIRS=$(find "$SRC" -mindepth 1 -maxdepth 1 -type d | tr '\n' ':' | sed 's/:$//')

if [[ -z "$DIRS" ]]; then
  echo "Keine Unterordner in '$SRC' gefunden."
  exit 4
fi

# mount mergerfs
echo "Mounten mit mergerfs..."
mergerfs "$DIRS" "$DST" -o defaults,allow_other,use_ino,category.create=mfs

if [[ $? -eq 0 ]]; then
  echo "Erfolgreich gemountet: $DST"
else
  echo "Fehler beim Mounten."
  exit 5
fi