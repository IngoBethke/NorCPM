# EXPERIMENT DEFAULT SETTINGS 
# USE VARNAME=VALUE ARGUMENT WHEN CALLING SCRIPT TO OVERRIDE DEFAULTS 

# experiment settings
: ${EXPERIMENT:=noresm2-lm_free_4mem} # case prefix, not including _YYYYMMDD_memXX suffix 
: ${MEMBER1:=1} # first member  
: ${ENSSIZE:=4} # number of members 
: ${COMPSET:=NHISTfrc2}
: ${USER_MODS_DIR:=$SETUPROOT/user_mods/noresm2-lm_128pes}   
: ${RES:=f19_tn14}
: ${START_DATE:=1996-01-01} # YYYY-MM-DD 

# initialisation settings
: ${RUN_TYPE:=branch}   
: ${REF_CASE_PREFIX:=noresm_ctl_19700101_19700101} 
: ${REF_CASE_SUFFIX_MEMBER1:=_mem01}  
: ${REF_PATH_LOCAL:=$INPUTDATA/ccsm4_init/$REF_CASE_PREFIX}
: ${REF_DATE:=$START_DATE}

# job settings
: ${STOP_OPTION:=nmonths} # units for run length specification STOP_N 
: ${STOP_N:=1} # run continuesly for this length 
: ${RESTART:=0} # restart this many times  
: ${WALLTIME:='00:59:00'}
: ${ACCOUNT:=nn9039k}
: ${MAX_PARALLEL_STARCHIVE:=10}

# general settings 
: ${CASESROOT:=$SETUPROOT/../../cases}
: ${NORESMROOT:=$SETUPROOT/../../model/noresm2}
: ${ASK_BEFORE_REMOVE:=0} # 1=will ask before removing existing cases 
: ${VERBOSE:=1} # set -vx option in all scripts
: ${SKIP_CASE1:=0} # skip creating first/template case, assume it exists already 
: ${SDATE_PREFIX:=} # recommended are either empty or "s" 
: ${MEMBER_PREFIX:=mem} # recommended are either empty or "mem" 
