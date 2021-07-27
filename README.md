# EAGLERC_example_2021

Docker image (for macOS)
* https://hub.docker.com/r/masaomi/eaglerc

Note
* You need to install Docker engine in your environment in advance of the following commands.

## macOS

How to set up the Docker image and container:
```
$ docker pull masaomi/eaglerc
$ docker run -it --workdir=/root --name eaglerc masaomi/eaglerc
# sh scripts/test_eaglerc.sh
```


After a while, some programs run, which will take a few minutes, and you will get the result
```
Executing EAGLE-RC...

Done

Without EAGLE-RC (direct alignment)
#Ahal reads mapped to Ahal reference: 67059
#Alyr reads mapped to Alyr reference: 99077
#Akam reads mapped to Akam reference: 166136
#Mis-mapped reads of Akam reads to Akam reference: 1680

By EAGLE-RC (read classification)
#Akam reads mapped to Ahal reference after EAGLE-RC: 65153
#Akam reads mapped to Alyr reference after EAGLE-RC: 97120
#Mis-mapped reads of Akam reads to Ahal reference after EAGLE-RC: 248
#Mis-mapped reads of Akam reads to Alyr reference after EAGLE-RC: 219
```

## other OS (Linux, Windows)

Note
* Please build the Docker image from the Dockerfile
```
$ git clone https://github.com/masaomi/EAGLERC_example_2021.git
$ cd EAGLERC_example_2021/
$ docker build . --tag masaomi/eaglerc
(it will take some minutes)
$ docker run -it --workdir=/root --name eaglerc masaomi/eaglerc
$ sh scripts/test_eaglerc.sh
```



