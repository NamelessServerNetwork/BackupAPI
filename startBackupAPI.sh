#!/bin/sh
version="v0.4"
echo --===== Starting BackupAPI $version =====--

#./data/bin/love ./data $@
cd deamon
love ./data $@
