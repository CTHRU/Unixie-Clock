#!/bin/sh
#MY_HOME=/home/_your_user_home_dir_name_
MY_HOME=/home/christoph
UNC_HOME=$MY_HOME/.conky/unixie_clock

cd $UNC_HOME
conky -d -c $UNC_HOME/unixie_clock.conky