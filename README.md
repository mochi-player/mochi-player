# mochi-player

[![Join the chat at https://gitter.im/mochi-player/mochi-player](https://badges.gitter.im/mochi-player/mochi-player.svg)](https://gitter.im/mochi-player/mochi-player?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build Status](https://travis-ci.org/mochi-player/mochi-player.svg?branch=qml)](https://travis-ci.org/mochi-player/mochi-player)

The tasty mpv based media player

## Compiling

```
mkdir build
cd build
qmake-qt5 ..
make -j $(grep -c '^processor' /proc/cpuinfo)
```

