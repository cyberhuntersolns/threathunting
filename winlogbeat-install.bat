@echo off
setlocal
set hour=%time:~0,2%
set minute=%time:~3,2%
set /A minute+=2
if %minute% GTR 59 (
 set /A minute-=60
 set /A hour+=1
)
if %hour%==24 set hour=00
if "%hour:~0,1%"==" " set hour=0%hour:~1,1%
if "%hour:~1,1%"=="" set hour=0%hour%
if "%minute:~1,1%"=="" set minute=0%minute%
set tasktime=%hour%:%minute%
pushd "C:\Program Files\"
echo [+] Downloading Winlogbeat...
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/cyberhuntersolns/threathunting/develop/winlogbeat.zip','C:\Program Files\winlogbeat.zip')"
@powershell Expand-Archive -Force 'C:\Program Files\winlogbeat.zip' 'C:\Program Files'"
pushd "C:\Program Files\winlogbeat2"
sysmon64.exe -accepteula -i sysmonconfig-export.xml
sc failure Sysmon64 actions= restart/10000/restart/10000// reset= 120
echo [+] Sysmon Successfully Installed!
timeout /t 10
exit
