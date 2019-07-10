#!/bin/bash
#
#SBATCH --job-name=branson_tau
#SBATCH --output=test_tau.txt
#
#SBATCH --ntasks=40
#SBATCH --time=8:00:00
#SBTACH -p skylake-gold

source /usr/projects/artab/soft/taucmdr-x86_64.env
module load mpich/3.3-intel_18.0.3

export OMPI_MCA_pml=ob1
export OMPI_MCA_btl=^openlib

# parameters for TAU
EXP=mpi40_overview

measure_list=(dp_all dp_simd tot_cyc tot_ins lst_ins front_stl back_stl stl_cyc mem_wcy tcm1 tcm2 tca2 tcm3 tca3 scalar_ins vec_ins_512 vec_ins_256 vec_ins_128 stl_icy stl_ccy)
#measure_list=(mem_uops_st mem_uops_ld rem_dram loc_dram tcm3 lst_ins off_req tot_cyc)
#measure_list=(cas_cnt0 cas_cnt22 cas_cnt44 cas_cnt66)


function run_trials {

        for i in ${measure_list[@]}; do
                tau experiment edit ${EXP} --measurement $i
                tau trial create ${CMD}
        done

}


tau select $EXP
CMD="mpirun -n 40 build/BRANSON inputs/proxy_small.xml"
run_trials





