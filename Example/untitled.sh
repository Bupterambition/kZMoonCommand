#!bin/bash
for fname in `ls`;do newname=`echo $fname | gsed -r 's/MGJ//g'`;echo $newname;mv $fname $newname;done
