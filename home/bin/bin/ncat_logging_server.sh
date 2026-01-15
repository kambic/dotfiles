#!/bin/bash

ncat -u -4 -l 5555
python3 -c "import socket
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(('0.0.0.0', 5141))
while True:
   print(s.recvfrom(4096)[0].decode('utf-8'))"
