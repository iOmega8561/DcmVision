if [[ -z "${SDKROOT}" || -z "${SCRIPTPATH}" || -z "$PARALLEL" ]]; then
    exit 1
fi

cd "$SCRIPTPATH"

if [ ! -d "vtk-src" ]; then
    git clone https://gitlab.kitware.com/vtk/vtk.git vtk-src
fi

mkdir -p vtk-src/build-ct

SDKROOT=$(xcrun --sdk macosx --show-sdk-path) \
cmake -GNinja \
    -S "$SCRIPTPATH/vtk-src" \
    -B "$SCRIPTPATH/vtk-src/build-ct" \
    -DVTK_BUILD_COMPILE_TOOLS_ONLY=ON \
    -DCMAKE_INSTALL_PREFIX="$SCRIPTPATH/vtk-compiletools"

mkdir "$SCRIPTPATH/vtk-compiletools"

cmake --build "$SCRIPTPATH/vtk-src/build-ct" \
      --parallel $PARALLEL \
      --config Release \
      --target install

