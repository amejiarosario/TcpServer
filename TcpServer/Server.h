#ifndef SERVER_H
#define SERVER_H

#include<QtNetwork/QTcpServer>

class Server : public QObject
{
    Q_OBJECT

public:
    Server();

private slots:
    void sendReply();

private:
    QTcpServer *tcpServer;

};

#endif // SERVER_H
