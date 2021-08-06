@echo off
REM Win10������߰�����

for %%i in ("%cd%") do set dir=%%~ni
echo ��ǰ���Ϊ��%dir%

cd %dir%
set /p platform=<.valid
echo ��ǰƽ̨Ϊ��%platform%

set /p version=<version
echo ��ǰ�汾�ţ�%version%

cd ../

tar -czf %dir%_%platform%_%version%.tar.gz %dir%

for /f "skip=1 delims=" %%b in ('certutil -hashfile "%dir%_%platform%_%version%.tar.gz" MD5') do (
    if not defined md5 (set md5=%%b)
)

echo �����ɣ�MD5Ϊ��%md5%
pause