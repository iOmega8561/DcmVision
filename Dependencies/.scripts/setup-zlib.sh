if [[ -z "${SDKROOT}" || -z "${SCRIPTPATH}" || -z "$PARALLEL" ]]; then
    exit 1
fi

cd "$SCRIPTPATH"

if [ ! -d "zlib-src" ]; then
    git clone https://github.com/madler/zlib.git zlib-src
fi

cd zlib-src

CC="clang -isysroot $SDKROOT -arch arm64" \
./configure \
    --static \
    --prefix=$SCRIPTPATH/zlib

make -j$PARALLEL && mkdir "$SCRIPTPATH/zlib"
make install && make clean && cd ..


rm -fr zlib-src
