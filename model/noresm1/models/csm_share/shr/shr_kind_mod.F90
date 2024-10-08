!===============================================================================
! SVN $Id: shr_kind_mod.F90 11926 2008-09-25 21:10:40Z mvertens $
! SVN $URL: https://svn-ccsm-models.cgd.ucar.edu/csm_share/branch_tags/cesm1_0_4_rel_tags/cesm1_0_4_n02_share3_110527/shr/shr_kind_mod.F90 $
!===============================================================================

MODULE shr_kind_mod

   !----------------------------------------------------------------------------
   ! precision/kind constants add data public
   !----------------------------------------------------------------------------
   public
   integer,parameter :: SHR_KIND_R8 = selected_real_kind(12) ! 8 byte real
   integer,parameter :: SHR_KIND_R4 = selected_real_kind( 6) ! 4 byte real
   integer,parameter :: SHR_KIND_RN = kind(1.0)              ! native real
   integer,parameter :: SHR_KIND_I8 = selected_int_kind (13) ! 8 byte integer
   integer,parameter :: SHR_KIND_I4 = selected_int_kind ( 6) ! 4 byte integer
   integer,parameter :: SHR_KIND_IN = kind(1)                ! native integer
   integer,parameter :: SHR_KIND_CS = 80                     ! short char
   integer,parameter :: SHR_KIND_CL = 256                    ! long char
   integer,parameter :: SHR_KIND_CX = 512                    ! extra-long char

END MODULE shr_kind_mod
