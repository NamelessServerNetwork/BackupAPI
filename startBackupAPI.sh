#!/bin/sh
version="v0.3"
echo --===== Starting BackupAPI $version =====--

#./data/bin/love ./data $@
cd deamon
love ./data $@
