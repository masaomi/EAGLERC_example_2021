# EAGLERC_example_2021

Docker image (for macOS)
* https://hub.docker.com/r/masaomi/eaglerc

EAGLE-RC
* https://github.com/tony-kuo/eagle

Reference (Citation)
* Tony Kuo and Martin C Frith and Jun Sese and Paul Horton. EAGLE: Explicit Alternative Genome Likelihood Evaluator. BMC Medical Genomics. 11(Suppl 2):28. https://doi.org/10.1186/s12920-018-0342-1
* Tony C Y Kuo, Masaomi Hatakeyama, Toshiaki Tameshige, Kentaro K Shimizu, Jun Sese Briefings in Bioinformatics, Volume 21, Issue 2, March 2020, Pages 395–407, https://doi.org/10.1093/bib/bby121

Note
* You need to install Docker engine in your environment in advance of the following commands execution.

## macOS

How to set up the Docker image and container:
```
$ docker pull masaomi/eaglerc
$ docker run -it --workdir=/root --name eaglerc masaomi/eaglerc
```

How to run the test code of EAGLE-RC (in the Docker container)
```
# sh scripts/test_eaglerc.sh
```

After a while, some programs run, which will take a few minutes, and you will get the result:
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
```


Note
* Once you exit from the Docker container, the container will stop
* Please start it again by

```
$ docker container start eaglerc
```

and login to the container
```
$ docker exec -it --user root eaglerc bash
```

For more details about Docker commands, please ask Google


