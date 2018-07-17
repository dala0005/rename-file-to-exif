# rename-file-to-exif
This script will try to get exif information from the file that has been passed in as an argument to the script.
The script only tries to get information from the file when the file first was created.
If exif information exists, the script will change the filename to yyyy-MM-dd_hh:mm:ss.jpg

However. If the filename aldready have the filename started with yyyy-MM-dd_hh:mm:ss the script will
not try to get the exif information on that file.

If the script doesn't found exif information about that particular file, the script check
if the filename begins with the format yyyy-mm-dd hh.mm.ss (I know Instagram uses this format),
of so, the script will change the filename to yyyy-MM-dd_hh:mm:ss

Usage:
The script takes one file at a time as an argument.
ex: ./rename-file-to-exif [your file]

If you have many files to rename, you can put the script in a loop.
ex. ls | grep [Jj][Pp][Gg]$ | while read f ; do ./rename-file-to-exif $"f" ; done

It is recommended to store the script in /usr/local/bin to make the script global.


Issues:
No known issues for now.

