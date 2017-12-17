#!/usr/bin/python
import socket, datetime, pytz

met = pytz.timezone("Europe/Berlin")

now = datetime.datetime.now(pytz.utc).astimezone(met)
since_midnight = (now - now.replace(hour=0, minute=0, second=0)).seconds

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

sock.sendto('node/header/clock/midnight:%f' % since_midnight, ('127.0.0.1', 4444))
sock.sendto('node/schedule/clock/set:%d' % since_midnight, ('127.0.0.1', 4444))

