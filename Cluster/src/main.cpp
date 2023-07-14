#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "SpeedReceiver.h"
#include "ButtonsReceiver.h"
#include "RPMReceiver.h"
#include <qqml.h>
#include <QMetaType>
#include <string>
#include <iostream>
#include <thread>
#include <CommonAPI/CommonAPI.hpp>
#include "ClusterStubImpl.hpp"
#include "WeatherAPI.h"
#include <QtPositioning/QGeoCoordinate>
#include <QTimer>
#include <QGeoCoordinate>
#include <iostream>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <cstring>

using namespace std;

Q_DECLARE_METATYPE(std::string)
qreal latitudeValue = 37.612168;
qreal longitudeValue = 126.993778;

qreal latitudeValue2 = 37.602463;
qreal longitudeValue2 = 127.024857;

qreal latitudeValue9 = 0;
qreal longitudeValue9 = 0;

char received_data[1024] = {0}; // Initialize received_data

void receiveDataThread()
{
    const char* listen_ip = "0.0.0.0";
    const int listen_port = 12348;

    int server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        std::cerr << "Failed to create socket" << std::endl;
        return;
    }

    sockaddr_in server_address{};
    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = inet_addr(listen_ip);
    server_address.sin_port = htons(listen_port);
    if (bind(server_socket, reinterpret_cast<struct sockaddr*>(&server_address), sizeof(server_address)) < 0) {
        std::cerr << "Failed to bind" << std::endl;
        return;
    }

    if (listen(server_socket, 1) < 0) {
        std::cerr << "Failed to listen" << std::endl;
        return;
    }

    std::cout << "수신 대기 중..." << std::endl;

    while (true) {
        sockaddr_in client_address{};
        socklen_t client_address_length = sizeof(client_address);
        int client_socket = accept(server_socket, reinterpret_cast<struct sockaddr*>(&client_address),
                                    &client_address_length);
        if (client_socket < 0) {
            std::cerr << "Failed to accept" << std::endl;
            return;
        }

        while (true) {
            ssize_t received_bytes = recv(client_socket, received_data, sizeof(received_data), 0);
            if (received_bytes == 0) {
                break;
            } else if (received_bytes < 0) {
                std::cerr << "Failed to receive data" << std::endl;
                break;
            }

            received_data[received_bytes] = '\0';
            std::cout << "수신: " << received_data << std::endl;
            char received_data[1024];
            // 데이터 처리
            while(1){
                ssize_t received_bytes = recv(client_socket, received_data, sizeof(received_data), 0);

                if (strcmp(received_data, "AngryDetected") == 0) {
                    latitudeValue9 = 1;
                } else {
                    latitudeValue9 = 0;
                }
            }
            // 데이터 전송
            ssize_t sent_bytes = send(client_socket, received_data, received_bytes, 0);
            if (sent_bytes != received_bytes) {
                std::cerr << "Failed to send data" << std::endl;
                break;
            }
        }

        close(client_socket);
    }

    close(server_socket);
}

int main(int argc, char *argv[])
{
    qRegisterMetaType<std::string>();

    std::shared_ptr<CommonAPI::Runtime> runtime = CommonAPI::Runtime::get();
    std::shared_ptr<ClusterStubImpl> myService =
        std::make_shared<ClusterStubImpl>();
    runtime->registerService("local", "cluster_service", myService);
    std::cout << "Successfully Registered Service!" << std::endl;

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    SpeedReceiver speedStorage;
    ButtonsReceiver buttonStorage;
    RPMReceiver rpmStorage;
    WeatherAPI weatherAPIStorage;


    QGeoCoordinate coordinate1(latitudeValue, longitudeValue);
    QGeoCoordinate coordinate2(latitudeValue2, longitudeValue2);
    QGeoCoordinate coordinate9(latitudeValue9, longitudeValue9);
    QTimer timer;

    engine.rootContext()->setContextProperty("speedReceiver", &speedStorage);
    engine.rootContext()->setContextProperty("buttonsReceiver", &buttonStorage);
    engine.rootContext()->setContextProperty("rpmReceiver", &rpmStorage);
    engine.rootContext()->setContextProperty("weatherAPI", &weatherAPIStorage);
    engine.rootContext()->setContextProperty("myCoordinate1", QVariant::fromValue(coordinate1));
    engine.rootContext()->setContextProperty("myCoordinate2", QVariant::fromValue(coordinate2));
    engine.rootContext()->setContextProperty("myCoordinate9", QVariant::fromValue(coordinate9));

    QObject::connect(&(*myService), &ClusterStubImpl::signalSpeed, &speedStorage, &SpeedReceiver::receiveSpeed);
    QObject::connect(&(*myService), &ClusterStubImpl::signalButtons, &buttonStorage, &ButtonsReceiver::receiveButtons);
    QObject::connect(&(*myService), &ClusterStubImpl::signalRPM, &rpmStorage, &RPMReceiver::receiveRPM);



     std::thread receive_thread(receiveDataThread);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;
    QObject::connect(&timer, &QTimer::timeout, [&]() {
              QGeoCoordinate coordinate9(latitudeValue9, longitudeValue9);

              // 좌표 값을 변경하고 출력
              //latitudeValue += 1.5;
              //longitudeValue += 0.5;
              coordinate9.setLatitude(latitudeValue9);
              coordinate9.setLongitude(longitudeValue9);
              cout << "Latitude: " << latitudeValue9 << ", Longitude: " << longitudeValue9 << endl;

              // 좌표 값을 업데이트하여 QML로 전달
              engine.rootContext()->setContextProperty("myCoordinate9", QVariant::fromValue(coordinate9));
              latitudeValue9=0;
              // 타이머의 인터벌을 1.5초로 설정하여 주기적으로 실행
              timer.start(1500);
          });

          timer.setInterval(1500);
          timer.start();



    return app.exec();
}
