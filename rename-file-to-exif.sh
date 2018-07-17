#!/bin/bash

if [ -z "$1" ] ; then
   echo "Error: Missing filename to modify"
   exit 0
fi

filename="$1"

# check if filename already have good format
if [[ $filename =~ ^[0-9]{8}_[0-9]{6} ]] ; then
   echo "No modifying on filename: $filename - already in good format"
   exit 0
fi


path=$(pwd)'/'
command="identify -verbose $path\"$filename\" | grep \"exif:DateTimeOriginal:\""

#check if file has jpg|JPG extend

filename_len=${#filename}
filename_extend=${filename:filename_len-3:3}

year=""
month=""
day=""
hour=""
minute=""
second=""
filename_new=""

if ! [[ $filename_extend =~ [JjPp][PpNn][Gg]$ ]] ; then
  echo "Error: file extension has not [Jj][Pp][Gg]$"
  echo "The script will now quit"
  exit 0
fi
echo "Loading exif information on $path$filename..."
exif_result=$(eval $command)

if [ -z "$exif_result" ] ; then
   echo "No exif information on image: $path$filename could be found."
   echo "Controlling if $path$filename has xxxx-xx-xx xx.xx.xx format"
   if [[ $filename =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]][0-9]{2}\.[0-9]{2}\.[0-9]{2} ]] ; then
      year=${filename:0:4}
      month=${filename:5:2}
      day=${filename:8:2}
      hour=${filename:11:2}
      minute=${filename:14:2}
      second=${filename:17:2}
      filename_new=$year$month$day\_$hour$minute$second\.jpg
      mv "$path$filename" "$path$filename_new"
      echo "The file: $filename has been changed to: $filename_new in path: $path"
     exit 0
   fi

else

year=${exif_result:27:4}
month=${exif_result:32:2}
day=${exif_result:35:2}
hour=${exif_result:38:2}
minute=${exif_result:41:2}
second=${exif_result:44:2}
filename_new=$year$month$day\_$hour$minute$second\.jpg


if ! [ "$filename_new" == "$filename" ] ; then
    mv "$path$filename" "$path$filename_new"
    echo "The file: $filename has been changed to: $filename_new in path: $path"
    exit 0
else
   echo "The filename has already the right format"
fi

exit 0


fi

