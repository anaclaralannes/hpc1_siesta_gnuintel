#!/bin/bash
#SBATCH --nodes=1                      #Numero de Nós
#SBATCH --ntasks-per-node=1            #Numero de tarefas por Nó
#SBATCH --ntasks=1                     #Numero total de tarefas MPI
#SBATCH --cpus-per-task=CPT            #Numero de threads
#SBATCH -p sequana_cpu_dev                        #Fila (partition) a ser utilizada
#SBATCH -J JOB                         #Nome job

#Exibe os nós alocados para o Job
echo $SLURM_JOB_NODELIST
nodeset -e $SLURM_JOB_NODELIST

cd $SLURM_SUBMIT_DIR

#Configura os compiladores
#Intel
source /scratch/app/modulos/intel-psxe-2016.sh

#ou
#GNU
module load gcc/6.5

#Configura o executavel
EXEC=./script_s.sh

#exibe informaçoes sobre o executavel
#exec caminho do script 
/usr/bin/ldd $EXEC

#configura o numero de threads, de acordo com o parametro definido no Slurm
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

srun  -N 1 -c $SLURM_CPUS_PER_TASK $EXEC