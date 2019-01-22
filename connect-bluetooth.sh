#!/usr/bin/env bash


# Debug params
set -o errexit
set -o nounset

readonly BT_TARGET=""
readonly PACMD="/usr/bin/pacmd"
readonly BTCTL="/usr/bin/bluetoothctl"
readonly PA="/usr/bin/pulseaudio"
readonly CONN_TIMEOUT=30

#=================================================
# exit-idle-time is necessary
# to prevent pulse from terminating prematurely
#=================================================
function startPulse {
    shlog "Starting pulse..."
    $PA -D --exit-idle-time -1 --verbose 
}


function stopPulse {
    shlog "Stopping pulse..."
    $PA --verbose --kill
}


function isBTSinkSet  {
    if [[ -z $($PACMD list-sinks | grep bluez) ]];
    then
        return 1
    else
        return 0
    fi
}


function connectBT {
    shlog "Pairing with bluetooth radio $BT_TARGET"
    $BTCTL > /dev/null << EOF  
    disconnect
    connect $BT_TARGET
EOF
}

function waitForBTConnection {
    i=0
    btconnected=1

    # Wait a bit until the connection
    # completes, should take no more $CONN_TIMEOUT
    while [[ $i -lt $CONN_TIMEOUT ]];
    do
        ((i=i+1))
        shlog "Checking connection status..." "error"
        if isBTSinkSet; 
        then
            return 0
        else
            shlog "Still not yet connected...($i/$CONN_TIMEOUT)" "error"
        fi
        sleep 1.5
    done
    return 1
}

function shlog {
    if [[ ${2:-} == "error" ]];
    then
        color=6
    else
        color=2
    fi
    tput setf $color
    echo "[$(date +'%c')] ::: $1"
    tput sgr0

}


shlog "Checking for previous Pulse Audio PIDs" "error"
if [[ ! -z $(pgrep "pulse") ]];
then
    shlog "Pulse Audio already running...checking if bluetooth is configured as sink..." "error"
    if isBTSinkSet;
    then
        shlog "Bluetooth is configured as sink"
    else
        shlog "Bluetooth not yet configured as sink...configuring" "error"

        # Initiate bluetoothctl to connect
        # to the already paired device
        connectBT


        # check if went wrong and needs to be 
        # checked, dump some info and eject
        if ! waitForBTConnection; 
        then
            shlog "Unable to connect to the bluetooth device...manual actions needed! Dumping configs"  "error"
            $PACMD dump
            $BTCTL --version
            exit 1
        else
            shlog "Bluetooth is connected and sink is set!"
        fi

    fi # if isBTSinkSet

else
    shlog "Pualse audio is not running, starting pulse audio"
    startPulse

    shlog "Configuring Bluetooth..."
    connectBT
fi

shlog "Done!"

