@echo off
setlocal enabledelayedexpansion

ORIGIN_CNT=0
RIQ_CNT=0

set /p ORIGIN_PATH=Please input original photo folder(ex. D:\photo\220101) : 
set /p RIQ_PATH=Please input liquefied photo folder(ex. D:\photo\220101): 

echo original photo path : %ORIGIN_PATH%
echo liquefied photo path : %RIQ_PATH%

cd /d %ORIGIN_PATH%
for %%i in (*) do (
	set /a ORIGIN_CNT+=1
	set ORIGIN_FILE[!ORIGIN_CNT!]=%%i
)

cd /d %RIQ_PATH%
for %%i in (*) do (
	set /a RIQ_CNT+=1
	set RIQ_FILE[!RIQ_CNT!]=%%i
)

IF %RIQ_CNT% GTR %ORIGIN_CNT% (
   echo "ERROR! original is less than liquefied!"
) ELSE (
   goto check
)
 
:check
cd /d %ORIGIN_PATH%
mkdir tmp
for /L %%i in (1,1,%ORIGIN_CNT%) do (
	echo original photo [!ORIGIN_FILE[%%i]!] compared to...
	for /L %%j in (1,1,%RIQ_CNT%) do (
		echo | set /p="------- liquefied photo [!RIQ_FILE[%%j]!] "
		IF "!ORIGIN_FILE[%%i]!" EQU "!RIQ_FILE[%%j]!" (
			echo matched.
			move !ORIGIN_FILE[%%i]! tmp/!ORIGIN_FILE[%%i]!
		) ELSE (
			echo unmatched. 
		)
	)
)
del /Q *
forfiles /p tmp /m * /s /c "cmd /c move @path %ORIGIN_PATH%"
rmdir /Q /S tmp
echo Deleted original file.