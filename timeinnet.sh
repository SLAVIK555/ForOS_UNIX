#!/bin/bash
dbus-monitor --system "sender=org.freedesktop.NetworkManager, path=/org/freedesktop/NetworkManager, member=StateChanged" | sed -u -n -e 's/uint32 70/bash connected.sh/p; s/uint32 60/bash disconnected.sh/p; s/uint32 50/bash disconnected.sh/p; s/uint32 40/bash disconnected.sh/p; s/uint32 30/bash disconnected.sh/p; s/uint32 20/bash disconnected.sh/p; s/uint32 10/bash disconnected.sh/p; s/uint32 0/bash disconnected.sh/p' | sh

