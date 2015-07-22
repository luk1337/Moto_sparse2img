usage() {
    echo "usage: ./convert.sh [factory image zip]"
    exit
}

FILE="$1"

if [[ ! $FILE =~ \.zip$ ]]; then
    usage
fi

# unzip
echo "# Extracting factory image..."
unzip -qq $FILE -d tmp

# convert
echo "# Converting sparse images to EXT4 image..."
./simg2img tmp/system.img_sparsechunk.* tmp/system.img.tmp
offset=`LANG=C grep -aobP -m1 '\x53\xEF' tmp/system.img.tmp | head -1 | awk '{print $1 - 1080}'`
dd if=tmp/system.img.tmp of=system.img ibs=$offset skip=1 >& tmp/dd.log

# cleanup
echo "# Cleaning up..."
rm -rf tmp

echo "# Done!"
