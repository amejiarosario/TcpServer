#include <QtCore/QCoreApplication>
#include<iostream>

#include "Server.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    std::cout << "TCP Server v.3.2";
    Server server;

    return a.exec();
}
