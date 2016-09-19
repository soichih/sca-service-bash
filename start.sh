#!/bin/bash

if [ -z $SCA_SERVICE_DIR ]; then SCA_SERVICE_DIR=/tmp; fi

#make sure jq is installed on $SCA_SERVICE_DIR
if [ ! -f $SCA_SERVICE_DIR/jq ];
then
        echo "installing jq"
        wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O $SCA_SERVICE_DIR/jq
        chmod +x $SCA_SERVICE_DIR/jq
fi

cwd=`$SCA_SERVICE_DIR/jq -e -r '.cwd' config.json`
if [ $? -eq 0 ];
then
    echo "cd-ing to $cwd"
    cd $cwd
fi

echo "writing out script stored in config.json"
$SCA_SERVICE_DIR/jq -r '.bash' config.json > script.sh
chmod +x script.sh

echo "creating symlink for each input directories"
for key in `jq -r '.inputs | keys[]' config.json`; do
    src=$(jq -r ".inputs[\"$key\"]" config.json)
    ln -s $src $key
done

rm -f finished
echo "running script.sh"
(
nohup time ./script.sh > stdout.log 2> stderr.log 
echo $? > finished 
echo "[]" > products.json
) &

