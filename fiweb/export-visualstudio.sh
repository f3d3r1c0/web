#!/bin/sh

#
# Export Visual Studio Project into Shared folder
#

export outdir="/v/SW.NET/SW.NET SORGENTI/SOFTWARE/FarmaStampatiMobi"

cmd /k "del /Q /S /F \"$outdir\""

cp -av images/ "$outdir"
cp -av libs/ "$outdir"
cp -av Properties/ "$outdir"
cp -av src/ "$outdir"
cp -f *.html "$outdir"

cp -f Global.asax* "$outdir/"
cp -f Web.config.release "$outdir/Web.config"
sed -e 's/fiweb/FarmastampatiMobi/g' < fiweb.csproj > "$outdir/FarmastampatiMobi.csproj"


for file in $(find *.aspx)
do
	sed -e 's/\"js\//\"http:\/\/php-farma01.rhcloud.com\/farmastampati\/js\//g' < $file > "$outdir/$file"
done

for file in $(find *.html)
do
	sed -e 's/\"js\//\"http:\/\/php-farma01.rhcloud.com\/farmastampati\/js\//g' < $file > "$outdir/$file"
done

