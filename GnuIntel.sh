#!/bin/bash

####################################################################################################
#Nome do Script	: Compilador GNU e Intel Siesta                                                    #
#Descrição		: Este programa compila o siesta         #
#Autor			: Ana clara                                                              #
#Data			: 24/07/2023                                                                       #
####################################################################################################

#tar -xvzf siesta-4.0.2.tar.gz

source /opt/intel/oneapi/setvars.sh
#ulimit -s unlimited

cd siesta-master/Obj/

sh ../Src/obj_setup.sh

cd ..
cp -r Obj/ Obj_gnu/
cp -r Obj/ Obj_intel/

####################################################################################################
#                                         Compilando no GNU                                        # 
####################################################################################################
cd Obj_gnu/
cp ../Src/Sys/gfortran.make arch.make

#  FLAG: -O3 + Extras (native)
sed -i '/FFLAGS = -O2 -fexpensive-optimizations -m64 -foptimize-register-move -funroll-loops -ffast-math -mtune=native -march=native/c\FFLAGS = -O3 -fexpensive-optimizations -m64 -foptimize-register-move -funroll-loops -ffast-math -mtune=native -march=native' arch.make
make clean
make
cp siesta siesta-gnu.x

cd Tests/benzene/
make clean
make

cp benzene.fdf work/
cd work
ln -s ../../../siesta-gnu.x siesta-gnu.x
rm -fr benzene.DM benzene.CG benzene.XV benzene.ZM

cd ../../../


# ------- Finalizando compilação GNU -------

cd ..

####################################################################################################
#                                        Compilando no INTEL MKL                                   # 
####################################################################################################
cd Obj_intel/
cp ../Src/Sys/intel-mkl.make arch.make 

#  FLAG: -03 + Extras (variação 1)
sed -i '/FFLAGS = -mp1 -zero -xAVX -ipo -O2/c\FFLAGS = -mp1 -zero -xAVX -ipo -O3' arch.make
make clean
make
cp siesta siesta-intel.x

cd Tests/benzene/
make

cp benzene.fdf work/
cd work
ln -s ../../../siesta-intel.x siesta-intel.x
rm -fr benzene.DM benzene.CG benzene.XV benzene.ZM

cd ../../../

