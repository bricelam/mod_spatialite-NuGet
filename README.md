# mod_spatialite-NuGet
This repositry creates a NuGet package containing the [SpatiaLite](https://www.gaia-gis.it/fossil/libspatialite) extension to SQLite.

Currently, only Windows binaries are provided. There are limitations that prevent this mechanism from working on Mac OS and Linux. We reccomend using a software package manager like Homebrew or APT on other platforms.

``` sh
# Debian/Ubuntu
apt-get install libsqlite3-mod-spatialite

# Mac OS
brew install libspatialite
```

Some users may experience segmentation faults with newer versions of PROJ (a dependency of SpatiaLite). You can work around these issues by installing a custom build of SpatiaLite that disables PROJ support.

``` sh
curl https://www.gaia-gis.it/gaia-sins/libspatialite-4.3.0a.tar.gz | tar -xz
cd libspatialite-4.3.0a

if [[ `uname -s` == Darwin* ]]; then
    # Mac OS requires some minor patching
    sed -i "" "s/shrext_cmds='\`test \\.\$module = .yes && echo .so \\|\\| echo \\.dylib\`'/shrext_cmds='.dylib'/g" configure
fi

./configure --disable-proj
make
make install
```
