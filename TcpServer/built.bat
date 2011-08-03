@echo off

echo ### set environment
PATH=C:\WINDOWS;C:\WINDOWS\system32;C:\WINDOWS\System32\Wbem
PATH=%PATH%;C:\QNX650\host\win32\x86\usr\bin;C:\Qt\2010.05\mingw\bin
PATH=%PATH%;%OASISROOT%\wintools
set QMAKESPEC=unsupported/qws/qnx-i386-g++
qmake -set QNX_TARGET_DIR C:/QNX650/target/qnx6/x86
set QNX_HOST=C:/QNX650/host/win32/x86
set QNX_TARGET=C:/QNX650/target/qnx6
set MAKEFLAGS=-IC:/QNX650/target/qnx6/usr/include
set LOGONSERVER=

echo OASISROOT is %OASISROOT%

echo ### run qmake
qmake  TcpServer.pro
echo ### run make
make

rem **************************************************************
rem 
rem REVISION HISTORY
rem $LastChangedDate: 
rem $Revision: 1118 $
rem $LastChangedBy: cthoma54 $
rem $Id: build-testfixtures.bat 1118 2011-07-01 13:04:15Z cthoma54 $
rem 
rem **************************************************************
