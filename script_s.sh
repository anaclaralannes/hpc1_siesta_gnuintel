#!/bin/bash

cd Obj/
cd Tests/benzene/

cp benzene.fdf work/
cd work

ln -s ../../../siesta-gnu.x siesta-gnu.x
rm -fr benzene.DM benzene.CG benzene.XV benzene.ZM

start=`date +%s`
time ./siesta-gnu.x < benzene.fdf > /prj/uff21hpc/ana.silva/saidadados/saida-gnu_1.out
end=`date +%s`

runtime=$((end-start))
echo 1 " " ${runtime} >> /prj/uff21hpc/ana.silva/saidadados/tempo-siesta.txt

cd ../../../
