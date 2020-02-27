#!/bin/sh

# Rar-rename: deobfuscation of rar-archives without par-files
# see: http://parchive.sourceforge.net/docs/specifications/parity-volume-spec/article-spec.html
# SEE https://forums.sabnzbd.org/viewtopic.php?f=9&t=24467


set -vx 
getfilename () {
echo $1
#7z l -ba -slt $1
7z l -slt $1
}

GetVolumeIndex () {
###echo $1
##7z l -ba -slt $1
LGetVolumeIndexNr7z=$(7z l -slt -bse1 $1 | grep "Volume Index =" | sed -e 's/Volume Index =//')
#LGetVolumeIndexNrUnRar=$(unrar vta $1 1>&2 | grep "Flags: " | sed -e 's/^.*Flags: volume //')
LGetVolumeIndexNrUnRar=$(unrar vta $1 | grep "Flags: " | sed -e 's/^.*Flags: volume //')
LGetVolumeIndexNr=$LGetVolumeIndexNrUnRar
#echo $LGetVolumeIndexNr
if [ "$LGetVolumeIndexNr" != "" ]
 then
  LGetVolumeIndexNr=$(printf "%02d\n" $LGetVolumeIndexNr)
  #NO zero padding # LGetVolumeIndexNr=$(printf "%06d\n" $LGetVolumeIndexNr)
  echo $LGetVolumeIndexNr
fi
}

filedoit () {
filename="$1"
echo "$filename"
filenameSKIP=$(echo $filename | grep "rartemp." )
echo "$filenameSKIP"
if [ "$filenameSKIP" == "" ]
 then
  #7z l -slt -bse1 $1 | grep -v "Can not open the file as archive" && GetVolumeIndexNr=$(GetVolumeIndex $1)
  ###7z l -slt -bse1 "$1"
  ###unrar l "$1"
  ###unrar vta -ierr "$1"
  GetVolumeIndexNr=$(GetVolumeIndex $1)
  if [ "$GetVolumeIndexNr" != "" ]
   then
    #LGetVolumeIndexNr=$(printf "%06d\n" $LGetVolumeIndexNr)
  ###base=$(basename -- "$filename"; echo .); base=${base%.}; dir=$(dirname -- "$filename"; echo .); dir=${dir%.}
  base=$(basename -- "$filename"; ); base=${base%.}; dir=$(dirname -- "$filename"; ); dir=${dir%.}
    #####echo "debug: cp "$base" rartemp.part$GetVolumeIndexNr.rar"
    ##### cp "$base" rartemp.part$GetVolumeIndexNr.rar
    echo "debug: cp "$base" rartemp.r$GetVolumeIndexNr"
    cp "$base" rartemp.r$GetVolumeIndexNr
  fi
fi

echo $GetVolumeIndexNr
###GetVolumeIndexNr=$(GetVolumeIndex $1)
 
#7z l -ba -slt $1
#7z l -slt $1
}

set +vx 

#find . -name "$1" -exec 7z l {} \;
#busybox find . -name "$1" -exec getfilename {} \;

busybox find . | while read file; do filedoit "$file"; done

