# TwoWayConnection

This QML component helps making QML development a bit easier by establishing bi-directional state updates that *try* to prevent binding loops. Under normal conditions it will, but of course it ultimately depends that states will eventually be equal to stop the loop.
