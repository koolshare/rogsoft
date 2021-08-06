@echo off
REM Win10打包离线包工具

for %%i in ("%cd%") do set dir=%%~ni
echo 当前插件为：%dir%

cd %dir%
set /p platform=<.valid
echo 当前平台为：%platform%

set /p version=<version
echo 当前版本号：%version%

cd ../

tar -czf %dir%_%platform%_%version%.tar.gz %dir%

for /f "skip=1 delims=" %%b in ('certutil -hashfile "%dir%_%platform%_%version%.tar.gz" MD5') do (
    if not defined md5 (set md5=%%b)
)

echo 打包完成！MD5为：%md5%
pause