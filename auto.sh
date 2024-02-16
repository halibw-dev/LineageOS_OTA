build_cache=$(grep -r 'ro.lineage.version=' /mnt/m2/lineage/out/target/product/oxygen/system/build.prop | cut -d '=' -f 2 | cut -b 6-13)
oldd=$(grep filename los-21.json | cut -d '-' -f 3)
echo "Wait ..."
md5=$(md5sum /mnt/m2/lineage/out/target/product/oxygen/lineage-21.0-"${build_cache}"-UNOFFICIAL-oxygen.zip | cut -d ' ' -f 1)
oldmd5=$(grep '"id"' los-21.json | cut -d':' -f 2)
utc=$(grep ro.build.date.utc /mnt/m2/lineage/out/target/product/oxygen/system/build.prop | cut -d '=' -f 2)
oldutc=$(grep datetime los-21.json | cut -d ':' -f 2)
size=$(wc -c /mnt/m2/lineage/out/target/product/oxygen/lineage-21.0-"${build_cache}"-UNOFFICIAL-oxygen.zip | cut -d ' ' -f 1)
oldsize=$(grep size los-21.json | cut -d ':' -f 2)
oldurl=$(grep url los-21.json | cut -d ' ' -f 8)

sed -i "s!${oldmd5}! \"${md5}\",!g" los-21.json
sed -i "s!${oldutc}! \"${utc}\",!g" los-21.json
sed -i "s!${oldsize}! \"${size}\",!g" los-21.json
sed -i "s!${oldd}!${build_cache}!" los-21.json
url="https://sourceforge.net/projects/max-2-pixelexperience-ota/files/LineageOS/lineage-21.0-"$build_cache"-UNOFFICIAL-oxygen.zip/download"
sed -i "s!${oldurl}!\"${url}\",!g" los-21.json

echo 'Start uploading file ...'
. ~/upload.sh

if [ $? -ne 0 ];then
	for ((i = 0; i <= 3; i++));
	do
		echo 'Upload attempts: "$i"'
		. ~/upload.sh
	done
fi

# Auto submit
date=$(date +%Y%m%d)
message="Update los-21.json "\`$date\`""
git add .
git commit -m "$message"
git push origin HEAD
