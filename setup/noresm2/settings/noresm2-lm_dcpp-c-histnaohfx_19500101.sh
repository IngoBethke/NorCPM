# EXPERIMENT DEFAULT SETTINGS 
# USE VARNAME=VALUE ARGUMENT WHEN CALLING SCRIPT TO OVERRIDE DEFAULTS 

# experiment settings
: ${EXPERIMENT:=noresm2-lm_dcpp-c-histnaohfx} # case prefix, not including _YYYYMMDD_memXX suffix 
: ${MEMBER1:=1} # first member  
: ${ENSSIZE:=10} # number of members 
: ${COMPSET:=NHISTfrc2}
: ${USER_MODS_DIR:=$SETUPROOT/user_mods/noresm2-lm_dcpp-c-histnaohfx_640pes}   
: ${RES:=f19_tn14}
: ${START_DATE:=1950-01-01} # YYYY-MM-DD 

# initialisation settings
: ${RUN_TYPE:=hybrid}  
: ${REF_CASE_LIST:='NHISTfrc2_f19_tn14_LESFMIPhist-all_021 NHISTfrc2_f19_tn14_LESFMIPhist-all_022 NHISTfrc2_f19_tn14_LESFMIPhist-all_023 NHISTfrc2_f19_tn14_LESFMIPhist-all_024 NHISTfrc2_f19_tn14_LESFMIPhist-all_025 NHISTfrc2_f19_tn14_LESFMIPhist-all_026 NHISTfrc2_f19_tn14_LESFMIPhist-all_027 NHISTfrc2_f19_tn14_LESFMIPhist-all_028 NHISTfrc2_f19_tn14_LESFMIPhist-all_029 NHISTfrc2_f19_tn14_LESFMIPhist-all_030 NHISTfrc2_f19_tn14_LESFMIPhist-all_031 NHISTfrc2_f19_tn14_LESFMIPhist-all_032 NHISTfrc2_f19_tn14_LESFMIPhist-all_033 NHISTfrc2_f19_tn14_LESFMIPhist-all_034 NHISTfrc2_f19_tn14_LESFMIPhist-all_035 NHISTfrc2_f19_tn14_LESFMIPhist-all_036 NHISTfrc2_f19_tn14_LESFMIPhist-all_037 NHISTfrc2_f19_tn14_LESFMIPhist-all_038 NHISTfrc2_f19_tn14_LESFMIPhist-all_039 NHISTfrc2_f19_tn14_LESFMIPhist-all_040'}# loop over these cases
: ${REF_PATH_LOCAL:=/nird/datalake/NS9039K/projects/LESFMIP/raw/NHISTfrc2_f19_tn14_LESFMIPhist-all}
: ${LINK_RESTART_FILES:=0}
: ${REF_DATE:=$START_DATE} 
: ${ADD_PERTURBATION:=1} # only for RUN_TYPE=hybrid

# job settings
: ${STOP_OPTION:=nyears} # units for run length specification STOP_N 
: ${STOP_N:=5} # run continuesly for this length 
: ${RESTART:=14} # restart this many times  
: ${WALLTIME:='96:00:00'}
: ${ACCOUNT:=nn11071k}
: ${MAX_PARALLEL_STARCHIVE:=10}

# general settings 
: ${CASESROOT:=$SETUPROOT/../../cases}
: ${NORESMROOT:=$SETUPROOT/../../model/noresm2}
: ${ASK_BEFORE_REMOVE:=0} # 1=will ask before removing existing cases 
: ${VERBOSE:=1} # set -vx option in all scripts
: ${SKIP_CASE1:=0} # skip creating first/template case, assume it exists already 
: ${SDATE_PREFIX:=} # recommended are either empty or "s" 
: ${MEMBER_PREFIX:=mem} # recommended are either empty or "mem" 
