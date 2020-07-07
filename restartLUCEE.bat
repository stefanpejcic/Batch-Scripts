@ECHO.
@ECHO Stopping services, please wait for 10 seconds…

@ECHO OFF
REM Stop Service

NET STOP Lucee

TIMEOUT /t 10 /NOBREAK
ECHO.

NET START Lucee

PAUSE

EXIT
