#!/bin/bash

# You need to have full access on DB which your going to backup/restore, so make sure user which your going to use
# need to have full access
# Make sure you have an S3 access from this instance, Attach S3 full access IAM policy to instance
# Make sure zip/unzip/awscli is installed
# Make changes of backup/restore path as your need.

#date=`date +%m-%d-%y`
date=08-09-18.zip ### ===> Manual first add the entry of which zip you need to download for restore
date1=08-09-18 ### ===> Set the same date of which zip your going to download
mkdir -p /data/mongodb-backup/restore
username='test'
password='test'
port='8653'
database='test'
bkpfolder=/data/mongodb-backup/restore
bkpfolder1=/data/mongodb-backup/restore/data/mongodb-backup/$date1
echo $bkpfolder


## Upload zip folder to s3 bucket
aws s3 cp $bkpfolder/$date.zip s3://tl-prod-dbbackup-nv

## Download zip backup file from S3
aws s3 cp s3://tl-prod-dbbackup-nv/$date $bkpfolder

## Unzip the downloaded folder
unzip $bkpfolder/$date -d $bkpfolder

## Get collection name
ls -l $bkpfolder1 |awk '{print $9}' > /tmp/restore
sed -i 's/.json//' /tmp/restore
sed '1d' /tmp/restore > /tmp/restore1

## Restore the collections
for collections in `cat /tmp/restore1`
do
#       echo $collections
        mongoimport --port $port -u $username -p $password -d $database -c $collections --upsert $bkpfolder1/$collections.json
done

