#!/bin/sh

#
# Export Visual Studio Project into Shared folder
#

#export outdir="/v/SW.NET/SW.NET SORGENTI/SOFTWARE/FarmaStampatiMobi"
export outdir="/c/Temp/FarmaStampatiMobi"

rm -rf "$outdir"
mkdir "$outdir"

cp -av images "$outdir"
cp -av libs "$outdir"
cp -av Properties "$outdir"
cp -av src "$outdir"
cp -av js "$outdir"
cp -f *.html "$outdir"
cp -f *.aspx "$outdir"
cp -f *.cs "$outdir"
cp -f *.asax "$outdir"
cp -f Web.config.release "$outdir/Web.config"

sed -e 's/fiweb/FarmastampatiMobi/g' < fiweb.csproj > "$outdir/FarmastampatiMobi.csproj"

#for file in $(find -name dh*.js)
#do
#	echo "exporting $file ..."
#	uglifyjs -m --keep-fnames $file > "$outdir/$file"
#	#sed -e 's/\"js\//\"http:\/\/php-farma01.rhcloud.com\/farmastampati\/js\//g' < $file > "$outdir/$file"
#done

for file in dh0.js dh1.js dh2.js dh3.js
do
	echo "exporting $file ..."
	uglifyjs -m --keep-fnames $file > "$outdir/$file"
done

#[ -d "output" ] || mkdir output
#for file in dh0.js dh1.js dh2.js dh3.js
#do
#	echo "exporting $file ..."
#	uglifyjs -m --keep-fnames $file > "output/$file"
#done

