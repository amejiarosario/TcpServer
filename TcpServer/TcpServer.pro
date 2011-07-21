#-------------------------------------------------
#
# Project created by QtCreator 2011-07-20T10:50:14
#
#-------------------------------------------------

QT       += core
QT      += network

QT       -= gui

TARGET = TcpServer
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

HEADERS += Server.h
SOURCES += main.cc \
           Server.cc

