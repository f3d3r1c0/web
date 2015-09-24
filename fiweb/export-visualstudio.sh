#!/bin/sh

#
# Export Visual Studio Project into Shared folder
#

export outdir="/v/SW.NET/SW.NET SORGENTI/SOFTWARE/FarmaStampatiMobi"

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

uglifyjs -m --keep-fnames default-cached.js > "$outdir/default-cached.js"

#for file in $(find *.aspx)
#do
#	sed -e 's/\"js\//\"http:\/\/php-farma01.rhcloud.com\/farmastampati\/js\//g' < $file > "$outdir/$file"
#done

