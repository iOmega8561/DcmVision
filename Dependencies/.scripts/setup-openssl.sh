if [[ -z "${SDKROOT}" || -z "${SCRIPTPATH}" || -z "$PARALLEL" ]]; then
    exit 1
fi

cd "$SCRIPTPATH"

if [ ! -d "openssl-src" ]; then
    git clone https://github.com/openssl/openssl.git openssl-src
fi

cd openssl-src

./Configure ios64-cross \
    no-shared \
    --prefix="$SCRIPTPATH/openssl" \
    -isysroot "$SDKROOT"

make -j$PARALLEL && mkdir "$SCRIPTPATH/openssl"
make install && make clean && cd ..

rm -fr openssl-src
