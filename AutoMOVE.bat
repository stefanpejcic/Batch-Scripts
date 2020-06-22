@echo off

set X=60
set "source="C:\Outbox"
set "destination="S:\"

robocopy "%source%" "%destination%" /mov /minage:%X%


exit /b
