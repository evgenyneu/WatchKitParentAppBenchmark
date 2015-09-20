# Sending message from Apple Watch to the main app in watchOS 2

This is a demo iOS app that shows how to send a message from WatchKit extension to the main app in watchOS 2. It uses `sendMessage` to send the message from the watch and receive results from the iOS device. The app also measures time it takes to send and receive such a message.

## How to setup watch connectivity




### Question

How much time does it take for a WatchKit extension to receive data back from the parent app?

### Answer

About 50 ms.

<br>

<img src='https://raw.githubusercontent.com/evgenyneu/WatchKitParentAppBenchmark/master/Graphics/watchkit_extension_to_parent_app_benchmark.png' alt='WatchKit extension to main app communication time' width='300'>

