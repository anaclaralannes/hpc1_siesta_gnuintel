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

    source /scratch/app/modulos/intel-psxe-2016.sh
    #ou
    module load gcc/6.5

    EXEC=/scratch/CAMINHO/PARA/O/EXECUTAVEL
    /usr/bin/ldd $EXEC

    export OMP_NUM_THREADS=$THREAD

    # Use o comando time antes do srun e redirecione a saída para um arquivo na pasta /prj/uff21hpc/ana.silva
    (time srun  -N 1 -c $THREAD $EXEC) &> /prj/uff21hpc/ana.silva/time_$THREAD.txt

done
