#!/usr/bin/python
import socket, datetime
from calendar import timegm

now = datetime.datetime.now()
since_midnight = (now - now.replace(hour=0, minute=0, second=0)).seconds
timestamp = timegm(now.timetuple()) + now.microsecond / 1000000.

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

print(timestamp)

sock.sendto('node/header/clock/midnight:%f' % since_midnight, ('127.0.0.1', 4444))
sock.sendto('node/schedule/clock/set:%d' % since_midnight, ('127.0.0.1', 4444))
sock.sendto('node/schedule/clock/unixtime:%d' % timestamp, ('127.0.0.1', 4444))

