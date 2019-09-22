cd src

curl https://www.gaia-gis.it/gaia-sins/libspatialite-4.3.0a.tar.gz | tar -xz

cd libspatialite-4.3.0a

if [[ `uname -s` == MINGW* ]]; then
    sed -i configure.ac -e "s|mingw32|${MINGW_CHOST}|g"

    curl -O https://raw.githubusercontent.com/msys2/MINGW-packages/5051440a86a02aef20bf54dfcbbf3e0a3171bf51/mingw-w64-libspatialite/01-fix-pkgconfig.patch
    patch -p1 -i 01-fix-pkgconfig.patch

    autoreconf

    rid="win-x64"
    if [ $MSYSTEM = "MINGW32" ]; then
        rid="win-x86"
    fi

    configureArgs="--host=${MINGW_CHOST} --target=${MINGW_CHOST} --build=${MINGW_CHOST} --prefix=${MINGW_PREFIX}"
    sharedLibExt=".dll"
elif [[ `uname -s` == Darwin* ]]; then
    sed -i "" "s/shrext_cmds='\`test \\.\$module = .yes && echo .so \\|\\| echo \\.dylib\`'/shrext_cmds='.dylib'/g" configure

    rid="osx-x64"
    sharedLibExt=".dylib"
else
    rid=$1
    if [ -z "${rid}"]; then
        echo "Please specify a RID."
        exit 1
    fi

    sharedLibExt=".so"
fi

mkdir build
cd build

../configure ${configureArgs} \
    --disable-proj \
    --disable-freexl \
    --disable-libxml2 \
    --disable-examples
make

cd ../../..

mkdir artifacts
cd artifacts

mkdir runtimes
cd runtimes

mkdir ${rid}
cd ${rid}

mkdir native
cd native

if [[ `uname -s` == MINGW* ]]; then
    if [ $MSYSTEM = "MINGW32" ]; then
        cp /mingw32/bin/libgcc_s_dw2-1.dll .
    else
        cp /mingw64/bin/libgcc_s_seh-1.dll .
    fi

    cp ${MINGW_PREFIX}/bin/libgeos.dll .
    cp ${MINGW_PREFIX}/bin/libgeos_c.dll .
    cp ${MINGW_PREFIX}/bin/libiconv-2.dll .
    cp ${MINGW_PREFIX}/bin/libstdc++-6.dll .
    cp ${MINGW_PREFIX}/bin/libwinpthread-1.dll .
    cp ${MINGW_PREFIX}/bin/zlib1.dll .
fi

cp ../../../../src/libspatialite-4.3.0a/build/src/.libs/mod_spatialite.dll .
