#!/bin/sh

#
# Export javascript
#

export openshift_dir=../../../../openshift/php/farmastampati

echo "exporting javascript of aspx pages ..."
for file in $(find | grep ^./js | sed -e 's/^.\///g' | grep aspx.js$)
do
	bdir=`dirname $openshift_dir/$file`
	[ -d $bdir ] || mkdir $bdir
	uglifyjs $file > $openshift_dir/$file
done

echo "exporting other javascripts ..."
for file in $(find | grep ^./js | sed -e 's/^.\///g' | grep .js$ | grep -v aspx.js$)
do
	bdir=`dirname $openshift_dir/$file`
	[ -d $bdir ] || mkdir $bdir
	if [ -f $openshift_dir/$file ]
		then
		diff $file $openshift_dir/$file >/dev/null 2>&1
		[ "$?" == "0" ] || cp -vf $file $openshift_dir/
	else 
		[ -f $file ] && cp -vf $file $openshift_dir/$file	
	fi	
done

echo "exporting other files ..."
for file in $(find | grep ^./js | sed -e 's/^.\///g' | grep -v js$)
do
	bdir=`dirname $openshift_dir/$file`
	[ -d $bdir ] || mkdir $bdir
	if [ -f $openshift_dir/$file ]
		then
		diff $file $openshift_dir/$file >/dev/null 2>&1
		[ "$?" == "0" ] || cp -vf $file $openshift_dir/
	else 
		[ -f $file ] && cp -vf $file $openshift_dir/$file	
	fi	
done

