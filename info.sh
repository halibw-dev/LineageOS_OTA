#!/bin/bash

d=$(date +%Y%m%d)
oldd=$(grep filename los-20.json | cut -d '-' -f 3)
md5=$(md5sum ../lineage/out/target/product/oxygen/lineage-20.0-"${d}"-UNOFFICIAL-oxygen.zip | cut -d ' ' -f 1)
oldmd5=$(grep '"id"' los-20.json | cut -d':' -f 2)
utc=$(grep ro.build.date.utc ../lineage/out/target/product/oxygen/system/build.prop | cut -d '=' -f 2)
oldutc=$(grep datetime los-20.json | cut -d ':' -f 2)
size=$(wc -c ../lineage/out/target/product/oxygen/lineage-20.0-"${d}"-UNOFFICIAL-oxygen.zip | cut -d ' ' -f 1)
oldsize=$(grep size los-20.json | cut -d ':' -f 2)
oldurl=$(grep url los-20.json | cut -d ' ' -f 8)

# This is where the magic happens

sed -i "s!${oldmd5}! \"${md5}\",!g" los-20.json
sed -i "s!${oldutc}! \"${utc}\",!g" los-20.json
sed -i "s!${oldsize}! \"${size}\",!g" los-20.json
sed -i "s!${oldd}!${d}!" los-20.json
echo Enter the new Download URL
read -r url
sed -i "s!${oldurl}!\"${url}\",!g" los-20.json
