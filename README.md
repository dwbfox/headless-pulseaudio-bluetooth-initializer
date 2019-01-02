# headless-pulseaudio-bluetooth-initializer
A small script to automate connecting to a bluetooth audio receiver (in my case to my home theatre system), starts up pulse audio if not running already, connects to the bluetooth peer, and tries to verify that it's present as an audio sink. Very rough but it gets the job done.

### Operation example
Assuming pulse audio, alsa, bluetoothd device drivers are all installed and configured, set the following values in the script to reflect your environment:
```bash
BT_TARGET="00:00:00:00:00" # BD_ADDR 
PACMD="/usr/bin/pacmd"
BTCTL="/usr/bin/bluetoothctl"
PA="/usr/bin/pulseaudio"
CONN_TIMEOUT=30 # Wait timeout for bluetooth connection
```

And then execute the script
```bash
$ ./connect-blue.sh
[Tue 01 Jan 2019 11:44:14 PM CST] ::: Checking for previous Pulse Audio PIDs
[Tue 01 Jan 2019 11:44:14 PM CST] ::: Pulse Audio already running...checking if bluetooth is configured as sink...
[Tue 01 Jan 2019 11:44:14 PM CST] ::: Bluetooth not yet configured as sink...configuring
[Tue 01 Jan 2019 11:44:14 PM CST] ::: Pairing with bluetooth radio C4:30:18:11:BF:76
[Tue 01 Jan 2019 11:44:14 PM CST] ::: Checking connection status...
[Tue 01 Jan 2019 11:44:14 PM CST] ::: Still not yet connected...(1/30)
[Tue 01 Jan 2019 11:44:16 PM CST] ::: Checking connection status...
[Tue 01 Jan 2019 11:44:16 PM CST] ::: Still not yet connected...(2/30)
[Tue 01 Jan 2019 11:44:17 PM CST] ::: Checking connection status...
[Tue 01 Jan 2019 11:44:17 PM CST] ::: Still not yet connected...(3/30)
[Tue 01 Jan 2019 11:44:19 PM CST] ::: Checking connection status...
[Tue 01 Jan 2019 11:44:19 PM CST] ::: Still not yet connected...(4/30)
[Tue 01 Jan 2019 11:44:21 PM CST] ::: Checking connection status...
[Tue 01 Jan 2019 11:44:21 PM CST] ::: Still not yet connected...(5/30)
[Tue 01 Jan 2019 11:44:22 PM CST] ::: Checking connection status...
[Tue 01 Jan 2019 11:44:22 PM CST] ::: Bluetooth is connected and sink is set!
[Tue 01 Jan 2019 11:44:22 PM CST] ::: Done!
```

Or tie to startup or initial login
```bash
$ echo ". ~/connect-blue.sh" >> ~/.bash_profile
```
