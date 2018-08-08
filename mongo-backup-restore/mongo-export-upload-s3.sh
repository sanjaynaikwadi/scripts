#!/bin/bash
#!/bin/bash
# You need to have full access on DB which your going to backup/restore, so make sure user which your going to use
# need to have full access
# Make sure you have an S3 access from this instance, Attach S3 full access IAM policy to instance
# Make sure zip/unzip/awscli is installed
# Make changes of backup/restore path as per your need.

date=`date +%m-%d-%y`
mkdir -p /data/mongodb-backup/$date
username='test'
password='test'
port='8653'
database='test'
bkpfolder=/data/mongodb-backup/$date
echo $bkpfolder


## Get the list of collection for backup
collections=`mongo --port 8653 -u $username -p $password --authenticationDatabase $database $database --quiet --eval "db.getCollectionNames()" | sed 's/"/ /g; s/,/ /g' > /tmp/collections`

## Remove 1 and last line, this was creating a problem for me 
sed '1d' /tmp/collections > /tmp/collections1
sed '$d' /tmp/collections1 > /tmp/collections2


## Once we get the list of collection lets backup them
for collections in `cat /tmp/collections2`
do
  mongoexport --quiet --port $port -u $username -p $password -d $database -c $collections -o  $bkpfolder/$collections.json
done

## Zip the backup folder
zip -r $bkpfolder/$date.zip $bkpfolder

## Upload zip folder to s3 bucket
aws s3 cp $bkpfolder/$date.zip s3://tl-prod-dbbackup-nv

