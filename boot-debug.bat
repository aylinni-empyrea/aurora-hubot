@echo off

call vars.bat
set HUBOT_LOG_LEVEL=debug

bin\hubot.cmd %*
