@echo off

:loop
cls  REM 清除屏幕内容

REM 获取当前日期和时间
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set datetime=%%a
set current_date=%datetime:~0,8%
set current_time=%datetime:~8,6%

REM 设置commit_log为当前日期和时间
set commit_log=AutoCommit_on_%current_date%_%current_time%

REM 检查是否有待提交的变动
git status | findstr /C:"nothing to commit, working tree clean"
if %errorlevel%==0 (
    echo No changes detected. Skipping commit.
) else (
    git add -A
    git commit -m "%commit_log%"
    echo Detailed commit information:
    git show --name-status
)

REM 5分钟倒计时
echo Waiting for the next check in:
for /L %%i in (300,-1,1) do (
    set /p "=%%i " <nul
    timeout /t 1 /nobreak >nul
)
echo.

REM 返回到循环的开始，再次执行检查
goto loop
