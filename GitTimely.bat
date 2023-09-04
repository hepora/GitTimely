@echo off
REM 记录程序循环次数
set loop_count=0
REM 记录程序开始时间
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set start_time=%%a
set start_time=%start_time:~0,14%
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

REM 显示程序启动时间和循环计数
echo Program started at: %start_time%
echo Loop count: %loop_count%

REM 5分钟倒计时
echo Waiting for the next check in:
for /L %%i in (600,-1,1) do (
    set /p "=%%i " <nul
    timeout /t 1 /nobreak >nul
)
echo.
REM 循环计数器递增
set /a loop_count+=1

REM 返回到循环的开始，再次执行检查
goto loop
