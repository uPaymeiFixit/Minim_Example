# Minim_Example
Three Processing projects using the Minim audio library.

Setup
-
You can run all three of these scripts in the Processing IDE. Just set the input you want to analyze as the default in your operating system and run the script. If you are using Mac, you can use a program called Soundflower to reroute your audio into an audio input to directly analyze your music. You can move the mouse up and down to change variables. (and left and right in Beat_Detect)

Description
-
This is a collection of three examples using the Minim library for Processing. I created these in an attempt to learn Processing and Minim. The end goal was to create a script which could analyze the music you are listening to and create a visualization based on it. All of these scripts should be easy to read and modify.


#####Wave_Detect
I started with the raw signal. This script detects and represents the wave of a signal. So if you feed it a 50HZ signal, it will show a 50HZ wave. However, if you play music, it looks like mostly random data. This is where Frequency_Detect comes in.

#####Frequency_Detect
This script uses the Fast Fourier Transform class in Minim to separate the signals in the raw audio into frequency ranges. This way we can view the average amplitude of a small range of frequencies. The frequencies go from low on the left to high on the right.

#####Beat_Detect
This script analyzes the data produced by the above script using the BeatDetect class in Minim. BeatDetect attempts to determine defferent types of beats using patterns in amplitude and frequency. It tries to determien Hi Hat, Kick Drum, Snare Drum, and custom beats. Custom beats are the "Onset" circles you see. These represent a small frequency band that BeatDetect is monitoring for beats. "Range" monitors all of the "Onset" frequency bands, and if a certain amount (which you set by moving the mouse left and right) all return a beat, then so does Range. 

![Screenshot](https://lh3.googleusercontent.com/-Tync2AaDz7E/VcHKA5at-7I/AAAAAAAAiLg/ke8cxMKM0nw/w1161-h486-no/2015-08-05.png)
