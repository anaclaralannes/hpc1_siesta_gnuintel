#!/bin/bash

# array com o número de threads que você deseja testar
threads=(1 2 4 8 16 32)

# itera sobre cada valor de threads
for THREAD in "${threads[@]}"; do

    # insira aqui as diretivas do Slurm, mas substitua a linha --cpus-per-task com a variável THREAD
    #SBATCH --nodes=1                      
    #SBATCH --ntasks-per-node=1            
    #SBATCH --ntasks=1                     
    #SBATCH --cpus-per-task=$THREAD        
    #SBATCH -p FILA                        
    #SBATCH -J JOB_$THREAD
    #SBATCH --exclusive

    echo $SLURM_JOB_NODELIST
    nodeset -e $SLURM_JOB_NODELIST

    cd $SLURM_SUBMIT_DIR

    cd Obj/
    cd Tests/benzene/

    cp benzene.fdf work/
    cd work

    ln -s ../../../siesta-gnu.x siesta-gnu.x
    rm -fr benzene.DM benzene.CG benzene.XV benzene.ZM

    source /scratch/app/modulos/intel-psxe-2016.sh
    #ou
    module load gcc/6.5

    export OMP_NUM_THREADS=$THREAD

    # executa o Siesta e mede o tempo de execução
    start=`date +%s`
    time ./siesta-gnu.x < benzene.fdf > /prj/uff21hpc/ana.silva/saidadados/saida-gnu_$THREAD.out
    end=`date +%s`

    runtime=$((end-start))
    echo $THREAD " " ${runtime} >> /prj/uff21hpc/ana.silva/saidadados/tempo-siesta.txt

    cd ../../../

done
