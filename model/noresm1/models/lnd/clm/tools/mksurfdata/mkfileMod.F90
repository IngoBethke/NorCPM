module mkfileMod

contains

!-----------------------------------------------------------------------
  subroutine mkfile(lsmlon, lsmlat, fname, dynlanduse)

    use shr_kind_mod, only : r8 => shr_kind_r8
    use shr_sys_mod , only : shr_sys_getenv
    use fileutils   , only : get_filename
    use mkvarpar    , only : nlevsoi, nlevurb, numsolar, numrad
    use mkvarctl
    use mkpftMod    , only : mkpftAtt
    use mksoilMod   , only : mksoilAtt
    use mkglcmecMod , only : nglcec
    use mkharvestMod, only : mkharvest_fieldname, mkharvest_numtypes, mkharvest_longname
    use ncdio       , only : check_ret, ncd_defvar, ncd_convl2i

    implicit none
    include 'netcdf.inc'
    integer, intent(in) :: lsmlon, lsmlat
    character(len=*),intent(in) :: fname
    logical, intent(in) :: dynlanduse

    integer :: ncid
    integer :: j                    ! index
    integer :: dimid                ! temporary
    integer :: values(8)            ! temporary
    character(len=256) :: str       ! global attribute string
    character(len=256) :: name      ! name of attribute
    character(len=256) :: unit      ! units of attribute
    character(len= 18) :: datetime  ! temporary
    character(len=  8) :: date      ! temporary
    character(len= 10) :: time      ! temporary
    character(len=  5) :: zone      ! temporary
    integer            :: ier       ! error status
    integer            :: omode     ! netCDF output mode
    integer            :: xtype     ! external type

#ifdef _OPENMP
    integer            :: OMP_GET_MAX_THREADS
    external           :: OMP_GET_MAX_THREADS
#endif

    character(len=32) :: subname = 'mkfile'  ! subroutine name
!-----------------------------------------------------------------------

    if ( .not. outnc_large_files )then
       call check_ret(nf_create(trim(fname), nf_clobber, ncid), subname)
    else
       call check_ret(nf_create(trim(fname), ior(nf_clobber,nf_64bit_offset), &
                                ncid), subname)
    end if
    call check_ret(nf_set_fill (ncid, nf_nofill, omode), subname)

    ! Define dimensions.

    call check_ret(nf_def_dim (ncid, 'lsmlon' , lsmlon      , dimid), subname)
    call check_ret(nf_def_dim (ncid, 'lsmlat' , lsmlat      , dimid), subname)
    if (.not. dynlanduse) then
       if ( nglcec > 0 )then
          call check_ret(nf_def_dim (ncid, 'nglcec',   nglcec     , dimid), subname)
          call check_ret(nf_def_dim (ncid, 'nglcecp1', nglcec+1   , dimid), subname)
       end if
    end if
    call check_ret(nf_def_dim (ncid, 'nlevurb', nlevurb     , dimid), subname)
    call check_ret(nf_def_dim (ncid, 'numsolar', numsolar     , dimid), subname)
    call check_ret(nf_def_dim (ncid, 'numrad', numrad     , dimid), subname)
    call check_ret(nf_def_dim (ncid, 'nchar'  , 128         , dimid), subname)

    ! Create global attributes.

    str = 'NCAR-CSM'
    call check_ret(nf_put_att_text (ncid, NF_GLOBAL, &
         'Conventions', len_trim(str), trim(str)), subname)

    call date_and_time (date, time, zone, values)
    datetime(1:8) =        date(5:6) // '-' // date(7:8) // '-' // date(3:4)
    datetime(9:)  = ' ' // time(1:2) // ':' // time(3:4) // ':' // time(5:6) // ' '
    str = 'created on: ' // datetime
    call check_ret(nf_put_att_text (ncid, NF_GLOBAL, &
         'History_Log', len_trim(str), trim(str)), subname)

    call shr_sys_getenv ('LOGNAME', str, ier)
    call check_ret(nf_put_att_text (ncid, NF_GLOBAL, &
         'Logname', len_trim(str), trim(str)), subname)

    call shr_sys_getenv ('HOST', str, ier)
    call check_ret(nf_put_att_text (ncid, NF_GLOBAL, &
         'Host', len_trim(str), trim(str)), subname)

    str = 'Community Land Model: CLM3'
    call check_ret(nf_put_att_text (ncid, NF_GLOBAL, &
         'Source', len_trim(str), trim(str)), subname)

#ifdef _OPENMP
    str = 'OMP_NUM_THREADS'
    call check_ret(nf_put_att_int (ncid, NF_GLOBAL, str, NF_INT, 1, &
                   OMP_GET_MAX_THREADS() ), subname)
    str = 'TRUE'
#else
    str = 'FALSE'
#endif
    call check_ret(nf_put_att_text (ncid, NF_GLOBAL, "OpenMP", len_trim(str), &
                   trim(str) ), subname)

#ifdef OPT
    str = 'TRUE'
#else
    str = 'FALSE'
#endif

    call check_ret(nf_put_att_text (ncid, NF_GLOBAL, &
         'Compiler_Optimized', len_trim(str), trim(str)), subname)

    str = &
'$HeadURL: https://svn-ccsm-models.cgd.ucar.edu/clm2/branch_tags/cesm1_0_4_rel_tags/cesm1_0_4_n04_clm4_0_32/models/lnd/clm/tools/mksurfdata/mkfileMod.F90 $'
    call check_ret(nf_put_att_text (ncid, NF_GLOBAL, &
         'Version', len_trim(str), trim(str)), subname)

    str = '$Id: mkfileMod.F90 28400 2011-05-16 05:46:46Z erik $'
    call check_ret(nf_put_att_text (ncid, NF_GLOBAL, &
         'Revision_Id', len_trim(str), trim(str)), subname)

    if ( all_urban )then
       str = 'TRUE'
       call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
            'all_urban', len_trim(str), trim(str)), subname)
    end if

    str = trim(mksrf_fgrid)
    call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
         'Input_grid_dataset', len_trim(str), trim(str)), subname)

    str = trim(mksrf_gridtype)
    call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
         'Input_gridtype', len_trim(str), trim(str)), subname)

    if (.not. dynlanduse) then

       str = get_filename(mksrf_fvocef)
       call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
            'VOC_EF_raw_data_file_name', len_trim(str), trim(str)), subname)
    end if

    str = get_filename(mksrf_flanwat)
    call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
         'Inland_water_raw_data_file_name', len_trim(str), trim(str)), subname)

    str = get_filename(mksrf_fglacier)
    call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
         'Glacier_raw_data_file_name', len_trim(str), trim(str)), subname)

    str = get_filename(mksrf_ftopo)
    call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
         'Topography_raw_data_file_name', len_trim(str), trim(str)), subname)

    str = get_filename(mksrf_ffrac)
    call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
         'Fracdata_raw_data_file_name', len_trim(str), trim(str)), subname)

    str = get_filename(mksrf_furban)
    call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
         'Urban_raw_data_file_name', len_trim(str), trim(str)), subname)

    str = get_filename(mksrf_firrig)
    call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
         'Irrig_raw_data_file_name', len_trim(str), trim(str)), subname)

    if (.not. dynlanduse) then
       str = get_filename(mksrf_flai)
       call check_ret(nf_put_att_text(ncid, NF_GLOBAL, &
            'Lai_raw_data_file_name', len_trim(str), trim(str)), subname)
    end if

    ! ----------------------------------------------------------------------
    ! Define variables
    ! ----------------------------------------------------------------------
 
    if ( .not. outnc_double )then
       xtype = nf_float
    else
       xtype = nf_double
    end if

    call mksoilAtt( ncid, dynlanduse, xtype )
    call mkpftAtt(  ncid, dynlanduse, xtype )

    call ncd_defvar(ncid=ncid, varname='EDGEN', xtype=nf_double, &
         long_name='northern edge of surface grid', units='degrees north')
    
    call ncd_defvar(ncid=ncid, varname='EDGEE', xtype=nf_double, &
         long_name='eastern edge of surface grid', units='degrees east')
    
    call ncd_defvar(ncid=ncid, varname='EDGES', xtype=nf_double, &
         long_name='southern edge of surface grid', units='degrees north')
    
    call ncd_defvar(ncid=ncid, varname='EDGEW', xtype=nf_double, &
         long_name='western edge of surface grid', units='degrees east')

    call ncd_defvar(ncid=ncid, varname='LATN' , xtype=nf_double, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='latitude of north edge', units='degrees north')

    call ncd_defvar(ncid=ncid, varname='LONE' , xtype=nf_double, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='longitude of east edge', units='degrees east')

    call ncd_defvar(ncid=ncid, varname='LATS' , xtype=nf_double, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='latitude of south edge', units='degrees north')

    call ncd_defvar(ncid=ncid, varname='LONW' , xtype=nf_double, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='longitude of west edge', units='degrees east')

    call ncd_defvar(ncid=ncid, varname='AREA' , xtype=nf_double, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='area', units='km^2')

    call ncd_defvar(ncid=ncid, varname='NUMLON', xtype=nf_int, &
         dim1name='lsmlat', long_name='number of longitudes for each latitude', units='unitless')

    call ncd_defvar(ncid=ncid, varname='LONGXY', xtype=nf_double, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='longitude', units='degrees east')

    call ncd_defvar(ncid=ncid, varname='LATIXY', xtype=nf_double, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='latitude', units='degrees north')

!    call ncd_defvar(ncid=ncid, varname='LANDMASK', xtype=nf_int, &
!         dim1name='lsmlon', dim2name='lsmlat', &
!         long_name='land/ocean mask', units='0=ocean and 1=land')

!    call ncd_defvar(ncid=ncid, varname='LANDFRAC', xtype=xtype, &
!         dim1name='lsmlon', dim2name='lsmlat', &
!         long_name='land fraction', units='unitless')


    if (.not. dynlanduse) then
       
       call ncd_defvar(ncid=ncid, varname='EF1_BTR', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='EF btr (isoprene)', units='unitless')

       call ncd_defvar(ncid=ncid, varname='EF1_FET', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='EF fet (isoprene)', units='unitless')

       call ncd_defvar(ncid=ncid, varname='EF1_FDT', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='EF fdt (isoprene)', units='unitless')

       call ncd_defvar(ncid=ncid, varname='EF1_SHR', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='EF shr (isoprene)', units='unitless')

       call ncd_defvar(ncid=ncid, varname='EF1_GRS', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='EF grs (isoprene)', units='unitless')

       call ncd_defvar(ncid=ncid, varname='EF1_CRP', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='EF crp (isoprene)', units='unitless')

       call ncd_defvar(ncid=ncid, varname='CANYON_HWR', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='canyon height to width ratio', units='unitless')

       call ncd_defvar(ncid=ncid, varname='EM_IMPROAD', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='emissivity of impervious road', units='unitless')

       call ncd_defvar(ncid=ncid, varname='EM_PERROAD', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='emissivity of pervious road', units='unitless')

       call ncd_defvar(ncid=ncid, varname='EM_ROOF', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='emissivity of roof', units='unitless')

       call ncd_defvar(ncid=ncid, varname='EM_WALL', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='emissivity of wall', units='unitless')

       call ncd_defvar(ncid=ncid, varname='HT_ROOF', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='height of roof', units='meters')

       call ncd_defvar(ncid=ncid, varname='THICK_ROOF', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='thickness of roof', units='meters')

       call ncd_defvar(ncid=ncid, varname='THICK_WALL', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='thickness of wall', units='meters')

       call ncd_defvar(ncid=ncid, varname='T_BUILDING_MAX', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='maximum interior building temperature', units='K')

       call ncd_defvar(ncid=ncid, varname='T_BUILDING_MIN', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='minimum interior building temperature', units='K')

       call ncd_defvar(ncid=ncid, varname='WIND_HGT_CANYON', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='height of wind in canyon', units='meters')

       call ncd_defvar(ncid=ncid, varname='WTLUNIT_ROOF', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='fraction of roof', units='unitless')

       call ncd_defvar(ncid=ncid, varname='WTROAD_PERV', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='fraction of pervious road', units='unitless')

       call ncd_defvar(ncid=ncid, varname='ALB_IMPROAD', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='numrad', &
            dim4name='numsolar', &
            long_name='albedo of impervious road', &
            units='unitless')

       call ncd_defvar(ncid=ncid, varname='ALB_PERROAD', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='numrad', &
            dim4name='numsolar', &
            long_name='albedo of pervious road', &
            units='unitless')

       call ncd_defvar(ncid=ncid, varname='ALB_ROOF', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='numrad', &
            dim4name='numsolar', &
            long_name='albedo of roof', &
            units='unitless')

       call ncd_defvar(ncid=ncid, varname='ALB_WALL', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='numrad', &
            dim4name='numsolar', &
            long_name='albedo of wall', &
            units='unitless')

       call ncd_defvar(ncid=ncid, varname='TK_ROOF', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='nlevurb', &
            long_name='thermal conductivity of roof', &
            units='W/m*K')

       call ncd_defvar(ncid=ncid, varname='TK_WALL', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='nlevurb', &
            long_name='thermal conductivity of wall', &
            units='W/m*K')

       call ncd_defvar(ncid=ncid, varname='TK_IMPROAD', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='nlevurb', &
            long_name='thermal conductivity of impervious road', &
            units='W/m*K')

       call ncd_defvar(ncid=ncid, varname='CV_ROOF', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='nlevurb', &
            long_name='volumetric heat capacity of roof', &
            units='J/m^3*K')

       call ncd_defvar(ncid=ncid, varname='CV_WALL', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='nlevurb', &
            long_name='volumetric heat capacity of wall', &
            units='J/m^3*K')

       call ncd_defvar(ncid=ncid, varname='CV_IMPROAD', xtype=xtype, &
            dim1name='lsmlon', dim2name='lsmlat', dim3name='nlevurb', &
            long_name='volumetric heat capacity of impervious road', &
            units='J/m^3*K')

       call ncd_defvar(ncid=ncid, varname='NLEV_IMPROAD', xtype=nf_int, &
            dim1name='lsmlon', dim2name='lsmlat', &
            long_name='number of impervious road layers', units='unitless')

    endif

    call ncd_defvar(ncid=ncid, varname='PCT_WETLAND', xtype=xtype, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='percent wetland', units='unitless')

    call ncd_defvar(ncid=ncid, varname='PCT_LAKE', xtype=xtype, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='percent lake', units='unitless')

    call ncd_defvar(ncid=ncid, varname='PCT_GLACIER', xtype=xtype, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='percent glacier', units='unitless')

    if (.not. dynlanduse) then

       if ( nglcec > 0 )then

          call ncd_defvar(ncid=ncid, varname='GLC_MEC', xtype=xtype, &
               dim1name='nglcecp1', long_name='Glacier elevation class', units='m')
   
          call ncd_defvar(ncid=ncid, varname='PCT_GLC_MEC', xtype=xtype, &
               dim1name='lsmlon', dim2name='lsmlat', dim3name='nglcec', &
               long_name='percent for each glacier elevation class', units='unitless')
   
          call ncd_defvar(ncid=ncid, varname='TOPO_GLC_MEC', xtype=xtype, &
               dim1name='lsmlon', dim2name='lsmlat', dim3name='nglcec', &
               long_name='mean elevation on glacier elevation classes', units='m')

          call ncd_defvar(ncid=ncid, varname='THCK_GLC_MEC', xtype=xtype, &
               dim1name='lsmlon', dim2name='lsmlat', dim3name='nglcec', &
               long_name='mean ice sheet thickness on glacier elevation classes', units='m')

       end if

    end if

    call ncd_defvar(ncid=ncid, varname='PCT_URBAN', xtype=xtype, &
         dim1name='lsmlon', dim2name='lsmlat', &
         long_name='percent urban', units='unitless')

    if ( dynlanduse) then
       do j = 1, mkharvest_numtypes()
          call ncd_defvar(ncid=ncid, varname=mkharvest_fieldname(j), xtype=xtype, &
               dim1name='lsmlon', dim2name='lsmlat', dim3name='time', &
               long_name=mkharvest_longname(j), units='unitless')
       end do
    end if

    ! End of define mode

    call check_ret(nf_enddef(ncid), subname)
    call check_ret(nf_close(ncid), subname)

  end subroutine mkfile

end module mkfileMod
