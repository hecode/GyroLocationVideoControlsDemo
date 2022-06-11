# GyroLocationVideoControlsDemo

Notes:
I would use separate xib files in real applications, but I used a storyboard here as a demo.

I would also use swiftlint.

I added a deadzone for x and z for gyro to prevent constant change, but the data might/could be cleaned in a better way.

For the 10m location change that causes the video to restart, I set it so that when it does that, the new location becomes the starting location.
