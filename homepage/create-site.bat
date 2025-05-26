@echo off
setlocal EnableDelayedExpansion

:: Eingabe
set /p siteNameRaw=Bitte gib den Namen der neuen Seite ein (z. B. about-me): 

:: Ordnername aus Eingabe (Bindestriche und Leerzeichen → _)
set "siteFolder=%siteNameRaw: =_%"
set "siteFolder=%siteFolder:-=_%"

:: Seitentitel generieren (z. B. "about-me" → "About Me")
set "siteTitle=%siteNameRaw%"
call :FormatTitle siteTitle

:: Pfade setzen
set "sitePath=sites\%siteFolder%"
set "filePath=%sitePath%\index.html"

:: Ordner erstellen
mkdir %sitePath%
echo Erstelle: %filePath%

:: HTML-Template schreiben
(
echo ^<!DOCTYPE html^>
echo ^<html lang="de"^>
echo ^<head^>
echo     ^<meta charset="UTF-8" /^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1" /^>
echo     ^<title>!siteTitle! – ltwiener^</title^>
echo     ^<link rel="stylesheet" href="../../css/style.css" /^>
echo ^</head^>
echo ^<body^>
echo     ^<header^>
echo         ^<nav^>
echo             ^<div class="logo"^>ltwiener^</div^>
echo             ^<ul class="nav-links"^>
echo                 ^<li^>^<a href="../../../index.html"^>Start^</a^>^</li^>
echo                 ^<li^>^<a href="../contact/index.html"^>Kontakt^</a^>^</li^>
echo             ^</ul^>
echo         ^</nav^>
echo         ^<div class="hero"^>
echo             ^<h1^>!siteTitle!^</h1^>
echo         ^</div^>
echo     ^</header^>
echo
echo     ^<main^>
echo         ^<section class="content"^>
echo             ^<h2^>Inhaltstitel^</h2^>
echo             ^<p^>Hier kommt der Inhalt von !siteTitle! hin.^</p^>
echo         ^</section^>
echo     ^</main^>
echo
echo     ^<footer^>
echo         ^<p^>&copy; 2025 ltwiener – Alle Rechte vorbehalten.^</p^>
echo     ^</footer^>
echo
echo     ^<script src="../../script/main.js"^>^</script^>
echo ^</body^>
echo ^</html^>
) > "%filePath%"

:: Navigationslink in index.html einfügen (direkt im Hauptordner)
set "mainIndex=index.html"
if exist "%mainIndex%" (
    call :AddNavLink "%mainIndex%" "%siteFolder%" "!siteTitle!"
) else (
    echo Hinweis: %mainIndex% wurde nicht gefunden – Navigation wurde nicht aktualisiert.
)

echo.
echo Neue Seite "!siteTitle!" erfolgreich erstellt in %sitePath%\index.html
pause
exit /b

:: --------------------------------------

:FormatTitle
setlocal EnableDelayedExpansion
set "input=%~1"
set "output="
for %%a in (!input:-= !) do (
    set "word=%%a"
    call :Capitalize word
    set "output=!output!!word! "
)
endlocal & set "%~1=%output:~0,-1%"
exit /b

:Capitalize
setlocal EnableDelayedExpansion
set "str=%~1"
set "first=!str:~0,1!"
set "rest=!str:~1!"
for %%b in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if /i "!first!"=="%%b" set "first=%%b"
)
set "capitalized=%first%%rest%"
endlocal & set "%~1=%capitalized%"
exit /b

:AddNavLink
:: %1 = index.html, %2 = Ordnername, %3 = Titel
setlocal EnableDelayedExpansion
set "newLink=        <li><a href=\"homepage/sites/%~2/index.html\">%~3</a></li>"
set "tempFile=__temp_index__.html"
break > "!tempFile!"

for /f "usebackq delims=" %%l in ("%~1") do (
    set "line=%%l"
    echo(!line!| findstr /C:"</ul>" >nul
    if !errorlevel! == 0 (
        echo(!newLink!>>"!tempFile!"
    )
    echo(!line!>>"!tempFile!"
)

move /Y "!tempFile!" "%~1" >nul
endlocal
exit /b
