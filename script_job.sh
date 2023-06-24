#!/bin/bash

# array com o número de threads que você deseja testar
threads=(1 2 4 8 16 32)

# itera sobre cada valor de threads
for THREAD in "${threads[@]}"; do

    # cria um arquivo temporário
    echo "#!/bin/bash" > temp_$THREAD.sbatch

    # insira aqui as diretivas do Slurm
    echo "#SBATCH --nodes=1" >> temp_$THREAD.sbatch
    echo "#SBATCH --ntasks-per-node=1" >> temp_$THREAD.sbatch
    echo "#SBATCH --ntasks=1" >> temp_$THREAD.sbatch
    echo "#SBATCH --cpus-per-task=$THREAD" >> temp_$THREAD.sbatch
    echo "#SBATCH -p cpu_small" >> temp_$THREAD.sbatch
    echo "#SBATCH -J JOB_$THREAD" >> temp_$THREAD.sbatch
    echo "#SBATCH --exclusive" >> temp_$THREAD.sbatch

    # adiciona o resto do script
    cat <<EOF >>temp_$THREAD.sbatch
    echo \$SLURM_JOB_NODELIST
    nodeset -e \$SLURM_JOB_NODELIST
    cd \$SLURM_SUBMIT_DIR
    cp benzene.fdf work/
    cd work
    ln -s ../../../../siesta-gnu.x siesta-gnu.x
    rm -fr benzene.DM benzene.CG benzene.XV benzene.ZM
    source /scratch/app/modulos/intel-psxe-2016.sh
    module load gcc/6.5
    export OMP_NUM_THREADS=$THREAD
    start=\`date +%s\`
    time ./siesta-gnu.x < benzene.fdf > /prj/uff21hpc/ana.silva/saidadados/saida-gnu_$THREAD.out
    end=\`date +%s\`
    runtime=\$((end-start))
    echo $THREAD " " \${runtime} >> /prj/uff21hpc/ana.silva/saidadados/tempo-gnu.txt
    cd ../../../../
EOF

    # submete o job
    sbatch temp_$THREAD.sbatch

    # remove o arquivo temporário
    rm temp_$THREAD.sbatch
done
