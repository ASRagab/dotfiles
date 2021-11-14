#!/bin/sh

echo "Cloning repositories..."

mkdir -p $HOME/Dev

DEV=$HOME/Dev

# Personal
git clone git@github.com:ASRagab/beautiful-folds.git $DEV/beautiful-folds
git clone git@github.com:ASRagab/zio.git $DEV/zio
git clone git@github.com:ASRagab/interop-twitter.git $DEV/interop-twitter

