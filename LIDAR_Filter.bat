@echo off
setlocal enabledelayedexpansion

REM Set variables
set FirstGRID=1
set SecGRID=0.25
set Spher_res=0.5
set kNN_res=0.5
set kNN_res2=0.25
set FIRSTC2Cdist=1.5
set Spher_res2=0.7
set SecondGRID=0.1
set FIRSTC2Cdist2=0.2
set Plana=0.15
set Plana2=0.2

REM Set path to CloudCompare.exe
set "CC_PATH=C:\Program Files\CloudCompare\CloudCompare.exe"

set core_used=22

REM Folder
set "CURRENT_DIR=%cd%"
set "LOGFILE=%CURRENT_DIR%\Log.txt"
echo ==== Log file - %date% %time% ==== > "%LOGFILE%"

goto START %REM%

for %%f in (*.las) do (
    echo Processing: %%f
    echo [%time%] Zpracovavam: %%f >> "%LOGFILE%"
    "%CC_PATH%" -SILENT -AUTO_SAVE OFF -NO_TIMESTAMP -C_EXPORT_FMT LAS ^
    REM 1. Load Clouds
    -O -GLOBAL_SHIFT AUTO "%%f" ^
    -O -GLOBAL_SHIFT AUTO "%%f" ^
    -SELECT_ENTITIES -FIRST 1 -CLOUD ^
    -SET_ACTIVE_SF "Scan Angle Rank"  ^
    -FILTER_SF -20 20 ^
    -RENAME_ENTITIES "Original.las" ^
    REM 2. Planarity = select small buildings ^
    -SELECT_ENTITIES -NOT -REGEX "Original" -CLOUD ^
    -RENAME_ENTITIES "Planarity" ^
    -RASTERIZE -GRID_STEP %FirstGRID% -PROJ MIN ^
    REM 4. 1st C2C computation
    -SELECT_ENTITIES -ALL ^
    -C2C_DIST -MAX_DIST %FIRSTC2Cdist% -MAX_TCOUNT %core_used% ^
    REM 5. Load base cloud in order to fallow internal CLI structure of C2C computaion
    -SELECT_ENTITIES -REGEX "Original" -CLOUD ^
    -SET_ACTIVE_SF "C2C absolute distances[<%FIRSTC2Cdist%]" ^
    -FILTER_SF SAT_MIN 1.49 ^
    REM 7. 2nd Grid MIN Z function
    -RASTERIZE -GRID_STEP %SecGRID% -PROJ MIN ^
    -FEATURE ANISOTROPY 0.3  ^
    -SET_ACTIVE_SF "Anisotropy (0.3)" ^
    -FILTER_SF SAT_MIN SAT_MAX ^
    -SAVE_CLOUDS FILE "%%~nf_Ground_Finall.las" ^>> "%LOGFILE%" 2>&1
    

    echo [%time%] Done: %%f >> "%LOGFILE%"
)

: START %REM%
echo Processing %REM% 
findstr /v "REM" "%~f0" > "%TEMP%\cleaned.bat" && call "%TEMP%\cleaned.bat"
echo All completed! log: %LOGFILE% %REM%
pause