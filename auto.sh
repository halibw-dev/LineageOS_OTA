build_cache=$(grep -r 'ro.lineage.version=' ~/lineage/out/target/product/oxygen/system/build.prop | cut -d '=' -f 2 |  cut -b 6-13)
oldd=$(grep filename los-20.json | cut -d '-' -f 3)
echo "Wait ..."
md5=$(md5sum ../lineage/out/target/product/oxygen/lineage-20.0-"${build_cache}"-UNOFFICIAL-oxygen.zip | cut -d ' ' -f 1)
oldmd5=$(grep '"id"' los-20.json | cut -d':' -f 2)
utc=$(grep ro.build.date.utc ../lineage/out/target/product/oxygen/system/build.prop | cut -d '=' -f 2)
oldutc=$(grep datetime los-20.json | cut -d ':' -f 2)
size=$(wc -c ../lineage/out/target/product/oxygen/lineage-20.0-"${build_cache}"-UNOFFICIAL-oxygen.zip | cut -d ' ' -f 1)
oldsize=$(grep size los-20.json | cut -d ':' -f 2)
oldurl=$(grep url los-20.json | cut -d ' ' -f 8)

sed -i "s!${oldmd5}! \"${md5}\",!g" los-20.json
sed -i "s!${oldutc}! \"${utc}\",!g" los-20.json
sed -i "s!${oldsize}! \"${size}\",!g" los-20.json
sed -i "s!${oldd}!${build_cache}!" los-20.json
url="https://sourceforge.net/projects/max-2-pixelexperience-ota/files/LineageOS/lineage-20.0-"$build_cache"-UNOFFICIAL-oxygen.zip/download"
sed -i "s!${oldurl}!\"${url}\",!g" los-20.json

# Auto submit
date=$(date +%Y%m%d)
message="Update los-20.json "\`$date\`""
git add .
git commit -m "$message"
