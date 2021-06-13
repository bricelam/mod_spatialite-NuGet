dotnet run -p test\Spatialite.Tests

dotnet publish test\Spatialite.Tests
test\Spatialite.Tests\bin\Debug\netcoreapp3.1\publish\Spatialite.Tests.exe

dotnet publish test/Spatialite.Tests -r win10-x64
test\Spatialite.Tests\bin\Debug\netcoreapp3.1\win10-x64\publish\Spatialite.Tests.exe

dotnet publish test/Spatialite.Tests -r win10-x86
test\Spatialite.Tests\bin\Debug\netcoreapp3.1\win10-x86\publish\Spatialite.Tests.exe
