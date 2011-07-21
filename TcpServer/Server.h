#ifndef SERVER_H
#define SERVER_H

#include<QtNetwork/QTcpServer>

class Server : public QObject
{
    Q_OBJECT

public:
    Server(int port = 27015);

private slots:
    void sendReply();

private:
    QTcpServer *tcpServer;

};

#endif // SERVER_H
