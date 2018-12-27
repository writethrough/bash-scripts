# Bash Scripts for Docker

## Introduction

Docker related Bash scripts, meant to be used either within Docker containers  
or within Docker server hosts for administration purposes.

## Execute Test

Execute the below script without arguments so as to get the help message.

Currently, the script expects only one argument. The expected argument is the timezone of the test container that will be launched to execute some test commands.

```sh
$ bash test-docker-extra-bashrc.sh
Mandatory argument is missing!
Examples of valid usage.
--------------------------------------------------------------------------------
$ bash test-docker-extra-bashrc.sh  Europe/Zurich
--------------------------------------------------------------------------------
```
