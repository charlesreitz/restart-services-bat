@echo off
set pathfolderlog="D:\TOTVS12\Microsiga\"

set nTimwWa=15
setlocal enabledelayedexpansion 
set servicosTOTVS=TOTVSAppserver12_00,TOTVSAppserver12_SCHEDULE,TOTVSAppserver12_WS,TOTVSAppserver12WSREST,TOTVSTSSAppserver12,TOTVSDBACCESS,DBACCESSTSS,licenseVirtual,tomcat8
echo -------------------------------------------------------------------------------- >> %pathfolderlog%totvsRestartAllServices.log 
date /T >> %pathfolderlog%totvsRestartAllServices.log 
time /T >> %pathfolderlog%totvsRestartAllServices.log 
echo -------------------------------------------------------------------------------- >> %pathfolderlog%totvsRestartAllServices.log 


for %%a in (%servicosTOTVS%) do ( 
	net stop %%a  >> %pathfolderlog%totvsRestartAllServices.log 
)


for %%a in (%servicosTOTVS%) do ( 
	
	for /F "tokens=3 delims=: " %%H in ('sc query %%a ^| findstr STATE' ) do (
	 	if  /I "%%H" EQU "RUNNING"  (
	 		taskkill /F /FI "SERVICES eq %%a"  >> %pathfolderlog%totvsRestartAllServices.log 
	 	)
		if /I "%%H" EQU "STOP_PENDING" (
	 		taskkill /F /FI "SERVICES eq %%a"  >> %pathfolderlog%totvsRestartAllServices.log 
	 	)
	)

)

for /F "tokens=3 delims=: " %%H in ('sc query licenseVirtual ^| findstr STATE' ) do (
	if  /I "%%H" NEQ "RUNNING"  (
		net start licenseVirtual >> %pathfolderlog%totvsRestartAllServices.log 
		timeout /t 30 /nobreak >> %pathfolderlog%totvsRestartAllServices.log 
	)
)


for %%a in (%servicosTOTVS%) do ( 
	
	for /F "tokens=3 delims=: " %%H in ('sc query %%a ^| findstr STATE' ) do (
	 	if  /I "%%H" NEQ "RUNNING"  (
	 		net start %%a >> %pathfolderlog%totvsRestartAllServices.log 
	 	)
	)
)

