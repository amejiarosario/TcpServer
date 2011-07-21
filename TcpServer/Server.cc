#include<iostream>
#include<QtNetwork/QNetworkInterface>

#include "Server.h"

Server::Server()
{
    tcpServer = new QTcpServer(this);

    QString ipAddress;
    QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
    // use the first non-localhost IPv4 address
    for (int i = 0; i < ipAddressesList.size(); ++i) {
        if (ipAddressesList.at(i) != QHostAddress::LocalHost && ipAddressesList.at(i).toIPv4Address()) {
            ipAddress = ipAddressesList.at(i).toString();
            break;
        }
    }
    // if we did not find one, use IPv4 localhost
    if (ipAddress.isEmpty())
        ipAddress = QHostAddress(QHostAddress::LocalHost).toString();


    //QTcpServer::listen() to set up a QTcpServer to listen on all addresses, on an arbitrary port.
    if (!tcpServer->listen(QHostAddress(ipAddress), 27015)) {
        std::cout << "Unable to start the server: "
                  << tcpServer->errorString().toStdString();
        //close();
        //return;
    }
    else
    {
        std::cout << "The server is running on\n\nIP:"
                  << ipAddress.toStdString()
                  << "\nport: "
                  << tcpServer->serverPort()
                  << "\n";

    }

    connect(tcpServer, SIGNAL(newConnection()),this,SLOT(sendReply()));
}

void Server::sendReply()
{
    std::cout << "Server::sendReply()\n";
    // @see http://doc.qt.nokia.com/latest/network-fortuneserver.html
    return;
}

