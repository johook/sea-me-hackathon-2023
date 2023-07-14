#include "SpeedReceiver.h"

SpeedReceiver::SpeedReceiver(QObject *parent) : QObject(parent)
{
}

void SpeedReceiver::receiveSpeed(int speed)
{
    qt_speedValue = speed; //clusterstubimpl에서 보낸 _speed를 받아 speed로 그리고 그걸 qt저기에 넣어
    emit speedValueChanged();
}

