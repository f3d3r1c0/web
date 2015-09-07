#!/bin/sh

#
# Export Visual Studio Project into Shared folder
#

export outdir="/v/SW.NET/SW.NET SORGENTI/SOFTWARE/FarmaStampatiMobi"

[ -d "$outdir/bin" ] && rm -rf "$outdir/bin"
rm -rf "$outdir/obj"

[ -d "$outdir/images" ] && rm -rf "$outdir/images"
cp -av images/ "$outdir"

[ -d "$outdir/libs" ] && rm -rf "$outdir/libs"
cp -av libs/ "$outdir"

[ -d "$outdir/Properties" ] && rm -rf "$outdir/Properties"
cp -av Properties/ "$outdir"

[ -d "$outdir/src" ] && rm -rf "$outdir/src"
cp -av src/ "$outdir"

rm -f "$outdir/*.html"
cp -f *.html "$outdir"

cp -f Global.asax* "$outdir/"
cp -f Web.config.release "$outdir/Web.config"
sed -e 's/fiweb/FarmastampatiMobi/g' < fiweb.csproj > "$outdir/FarmastampatiMobi.csproj"

rm -f "$outdir/*.aspx"
for file in $(find *.aspx)
do
	sed -e 's/\"js\//\"http:\/\/php-farma01.rhcloud.com\/farmastampati\/js\//g' < $file > "$outdir/$file"
done
