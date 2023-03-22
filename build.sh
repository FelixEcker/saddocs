#!/usr/bin/bash

mkdir -p out
rm out/*.ppu
rm out/*.o
rm out/saddocs*

if [[ $1 == debug ]]; then
  fpc src/saddocs.pp -Fu"inc/" -FE"out/" -g -dDEBUG
else
  fpc src/saddocs.pp -Fu"inc/" -FE"out/" -O4 -Xs -XX
fi
