#!/bin/bash

echo "writing out script stored in config.json"

#make sure jq is installed on $SCA_SERVICE_DIR
if [ ! -f $SCA_SERVICE_DIR/jq ];
then
        echo "installing jq"
        wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O $SCA_SERVICE_DIR/jq
        chmod +x $SCA_SERVICE_DIR/jq
fi


$SCA_SERVICE_DIR/jq -r '.bash' config.json > script.sh
chmod +x script.sh

rm -f finished
echo "running script.sh"
(
nohup time ./script.sh > stdout.log 2> stderr.log 
echo $? > finished 
) &

