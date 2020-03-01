# Reloadable

Run demo and modify either `pymain.py` / `qmlmain.qml` source code to see instant qml hot reloading.

## Discussion

Ever since I started using React and noticed how similar it is to QML I wondered if there was a way to bring React's lovely hot-reloading mechanisms to QML; and it looks like the answer is yes. A [blog post](https://qml.guide/live-reloading-hot-reloading-qml/) offered the gist of how to do it, I just made it more convenient in the following ways:

- We're using *python*: Reloadables should be able to reload **python modules also**--with this they can
- Loader's allow us to load in qml objects

## Caveats

I wish this worked perfectly, but basically Python *really* likes to garbage collect, when Qt doesn't notice. So you need to be careful with your pointers, otherwise a reload can result in a segfault, mainly when dealing with python code reloading. But it works pretty solid for general QML component reloading.
