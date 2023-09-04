@echo off
REM ��¼����ѭ������
set loop_count=0
REM ��¼����ʼʱ��
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set start_time=%%a
set start_time=%start_time:~0,14%
:loop
cls  REM �����Ļ����

REM ��ȡ��ǰ���ں�ʱ��
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set datetime=%%a
set current_date=%datetime:~0,8%
set current_time=%datetime:~8,6%

REM ����commit_logΪ��ǰ���ں�ʱ��
set commit_log=AutoCommit_on_%current_date%_%current_time%

REM ����Ƿ��д��ύ�ı䶯
git status | findstr /C:"nothing to commit, working tree clean"
if %errorlevel%==0 (
    echo No changes detected. Skipping commit.
) else (
    git add -A
    git commit -m "%commit_log%"
    echo Detailed commit information:
    git show --name-status
)

REM ��ʾ��������ʱ���ѭ������
echo Program started at: %start_time%
echo Loop count: %loop_count%

REM 5���ӵ���ʱ
echo Waiting for the next check in:
for /L %%i in (600,-1,1) do (
    set /p "=%%i " <nul
    timeout /t 1 /nobreak >nul
)
echo.
REM ѭ������������
set /a loop_count+=1

REM ���ص�ѭ���Ŀ�ʼ���ٴ�ִ�м��
goto loop
