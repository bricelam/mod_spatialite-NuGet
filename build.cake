var target = Argument<string>("target");

Task("Pack")
    .Does(
        () =>
        {
            StartProcess(
                @"C:\msys64\msys2_shell.cmd",
                @"-c ""pacman -S --needed --noconfirm mingw-w64-i686-libspatialite mingw-w64-x86_64-libspatialite""");

                var root32 = @"C:\msys64\mingw32\";
                var target32 = @"src\mod_spatialite\runtimes\win-x86\native";
                var root64 = @"C:\msys64\mingw64\";
                var target64 = @"src\mod_spatialite\runtimes\win-x64\native";
                var values = new (string root, string target)[]
                {
                    (root32, target32),
                    (root64, target64)
                };
                CreateDirectory(target32);
                CreateDirectory(target64);
                foreach (var value in values)
                    CopyFiles(
                        new[]
                        {
                            value.root + @"bin\libfreexl-1.dll",
                            value.root + @"bin\libgeos.dll",
                            value.root + @"bin\libgeos_c.dll",
                            value.root + @"bin\libiconv-2.dll",
                            value.root + @"bin\liblzma-5.dll",
                            value.root + @"bin\libproj-13.dll",
                            value.root + @"bin\libstdc++-6.dll",
                            value.root + @"bin\libwinpthread-1.dll",
                            value.root + @"bin\libxml2-2.dll",
                            value.root + @"bin\zlib1.dll",
                            value.root + @"lib\mod_spatialite.dll"
                        },
                        value.target);

            CopyFiles(new[] { root32 + @"bin\libgcc_s_dw2-1.dll" }, target32);
            CopyFiles(new[] { root64 + @"bin\libgcc_s_seh-1.dll" }, target64);

            NuGetPack(@"src\mod_spatialite\mod_spatialite.nuspec", new NuGetPackSettings());
        });

RunTarget(target);
