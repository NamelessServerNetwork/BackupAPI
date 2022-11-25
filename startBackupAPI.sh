#!/bin/sh
version="v1.0"
echo --===== Starting BackupAPI $version =====--

#./data/bin/love ./data $@
cd deamon
love ./data $@
