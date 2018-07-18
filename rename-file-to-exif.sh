#!/bin/bash

filename=""
path=""
# check if script has argument

if [ -z "$1" ] ; then
   echo "Error: Missing filename to modify"
   exit 0
fi

# get path to file

# check if absolut path
if [[ ${1:0:1} == '/' ]] ; then
   # get last '/' in the path to separate path and filename

   argument_len=${#1} # get lenth of argument

   # search for last '/' in argument starting with last character
   for path_index in `seq $argument_len -1 0`;
   do
      if [[ ${1:$path_index:1} == '/' ]] ; then # finding last '/'
         filename=${1:$path_index+1:$argument_len}  # store filename
         path=${1:0:$(($argument_len - ${#filename}))} # store path
         break
      fi
   done

else
   filename="$1"
   path=$(pwd)'/'
fi

# check if dynamic path
#if [[ ${1:0:3} == '../' ]] ; then
#  echo "dynamic path!"
#   exit 0
#fi

# check if filename already have right format
if [[ $filename =~ ^[0-9]{8}_[0-9]{6} ]] ; then
   echo "No modifying on filename: $filename - already in right format"
   exit 0
fi


#check if file has jpg|JPG extend

filename_len=${#filename}
filename_extend=${filename:filename_len-3:3}


if ! [[ $filename_extend =~ [Jj][Pp][Gg]$ ]] ; then
  echo "Error: file extension has not [Jj][Pp][Gg]$"
  echo "The script will now quit"
  exit 0
fi

command="identify -verbose $path\"$filename\" | grep \"exif:DateTimeOriginal:\""

year=""
month=""
day=""
hour=""
minute=""
second=""
filename_new=""

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

