module mrg_x2a_mct

  use shr_kind_mod, only: r8 => shr_kind_r8
  use mct_mod
  use seq_flds_mod
  use seq_flds_indices
  use seq_comm_mct
  use seq_cdata_mod

  implicit none
  save
  private ! except

!--------------------------------------------------------------------------
! Public interfaces
!--------------------------------------------------------------------------

  public :: mrg_x2a_init_mct
  public :: mrg_x2a_run_mct
  public :: mrg_x2a_final_mct 

!--------------------------------------------------------------------------
! Private interfaces
!--------------------------------------------------------------------------
!
!--------------------------------------------------------------------------
! Private data
!--------------------------------------------------------------------------
!
!===========================================================================================
contains
!===========================================================================================
!
  subroutine mrg_x2a_init_mct( cdata_a, l2x_a, o2x_a, i2x_a, xao_a )

    !----------------------------------------------------------------------- 
    !
    ! Arguments
    !
    type(seq_cdata), intent(in)    :: cdata_a
    type(mct_aVect), intent(inout) :: l2x_a
    type(mct_aVect), intent(inout) :: o2x_a
    type(mct_aVect), intent(inout) :: i2x_a
    type(mct_aVect), intent(inout) :: xao_a
    !
    ! Locals
    !
    type(mct_gsmap), pointer :: gsMap_a
    integer                  :: lsize
    integer                  :: mpicom
    !----------------------------------------------------------------------- 

    ! Get atmosphere gsMap

    call seq_cdata_setptrs(cdata_a, gsMap=gsMap_a, mpicom=mpicom)
    lsize = mct_GSMap_lsize(GSMap_a, mpicom)

    ! Initialize av for land export state on atmosphere grid/ decomp

    call mct_aVect_init(l2x_a, rList=seq_flds_l2x_fields, lsize=lsize)
    call mct_aVect_zero(l2x_a)

    ! Initialize av for ocn export state on atmosphere grid/decomp

    call mct_aVect_init(o2x_a, rList=seq_flds_o2x_fields, lsize=lsize)
    call mct_aVect_zero(o2x_a)

    ! Initialize av for ice export state on atmosphere grid/decomp

    call mct_aVect_init(i2x_a, rList=seq_flds_i2x_fields, lsize=lsize)
    call mct_aVect_zero(i2x_a)

    ! Initialize av for atm/ocn flux calculation on atmosphere grid/decomp

    call mct_aVect_init(xao_a, rList=seq_flds_xao_fields, lsize=lsize)
    call mct_aVect_zero(xao_a)

  end subroutine mrg_x2a_init_mct

!===========================================================================================

  subroutine mrg_x2a_run_mct( cdata_a, l2x_a, o2x_a, xao_a, i2x_a, fractions_a, x2a_a )

    !----------------------------------------------------------------------- 
    !
    ! Arguments
    !
    type(seq_cdata), intent(in)     :: cdata_a
    type(mct_aVect), intent(in)     :: l2x_a
    type(mct_aVect), intent(in)     :: o2x_a
    type(mct_aVect), intent(in)     :: xao_a
    type(mct_aVect), intent(in)     :: i2x_a
    type(mct_aVect), intent(in)     :: fractions_a
    type(mct_aVect), intent(inout)  :: x2a_a
    !----------------------------------------------------------------------- 
    !
    ! Local workspace
    !
    logical  :: usevector    ! use vector-friendly mct_copy
    integer  :: n, ki, kl, ko  ! indices
    real(r8) :: frac         ! temporary
    integer  :: lsize        ! temporary
    !-----------------------------------------------------------------------
    !
    ! Zero attribute vector
    !
    call mct_avect_zero(x2a_a)
    !
    ! Update surface fractions
    !
!    lSize = mct_avect_lSize(x2a_a)
    ki=mct_aVect_indexRA(fractions_a,"ifrac")
    kl=mct_aVect_indexRA(fractions_a,"lfrac")
    ko=mct_aVect_indexRA(fractions_a,"ofrac")
!    do n = 1,lSize
! tcx moved below (after the avect_copy) to reduce risk and improve cache use
!       x2a_a%rAttr(index_x2a_Sx_lfrac,n) = fractions_a%Rattr(kl,n)
!       x2a_a%rAttr(index_x2a_Sx_ifrac,n) = fractions_a%Rattr(ki,n)
!       x2a_a%rAttr(index_x2a_Sx_ofrac,n) = fractions_a%Rattr(ko,n)
!    end do
    !
    ! Copy attributes that do not need to be merged
    ! These are assumed to have the same name in 
    ! (o2x_a and x2a_a) and in (l2x_a and x2a_a), etc.
    !
#ifdef CPP_VECTOR
    usevector = .true.
#else
    usevector = .false.
#endif
    call mct_aVect_copy(aVin=l2x_a, aVout=x2a_a, vector=usevector)
    call mct_aVect_copy(aVin=o2x_a, aVout=x2a_a, vector=usevector)
    call mct_aVect_copy(aVin=i2x_a, aVout=x2a_a, vector=usevector) 
    call mct_aVect_copy(aVin=xao_a, aVout=x2a_a, vector=usevector)
    ! 
    ! Merge based on fractional cell coverage
    !	
    lsize = mct_avect_lsize(x2a_a)
    do n = 1,lsize

       x2a_a%rAttr(index_x2a_Sx_lfrac,n) = fractions_a%Rattr(kl,n)
       x2a_a%rAttr(index_x2a_Sx_ifrac,n) = fractions_a%Rattr(ki,n)
       x2a_a%rAttr(index_x2a_Sx_ofrac,n) = fractions_a%Rattr(ko,n)

       frac = x2a_a%rAttr(index_x2a_Sx_lfrac,n)
       if (frac > 0._r8) then
          x2a_a%rAttr(index_x2a_Sx_avsdr,n)  = x2a_a%rAttr(index_x2a_Sx_avsdr,n)  + &
                                               l2x_a%rAttr(index_l2x_Sl_avsdr,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_avsdf,n)  = x2a_a%rAttr(index_x2a_Sx_avsdf,n)  + &
                                               l2x_a%rAttr(index_l2x_Sl_avsdf,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_anidr,n)  = x2a_a%rAttr(index_x2a_Sx_anidr,n)  + &
                                               l2x_a%rAttr(index_l2x_Sl_anidr,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_anidf,n)  = x2a_a%rAttr(index_x2a_Sx_anidf,n)  + &
                                               l2x_a%rAttr(index_l2x_Sl_anidf,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_tref,n)   = x2a_a%rAttr(index_x2a_Sx_tref,n)   + &
                                               l2x_a%rAttr(index_l2x_Sl_tref,n)   * frac
          x2a_a%rAttr(index_x2a_Sx_qref,n)   = x2a_a%rAttr(index_x2a_Sx_qref,n)   + &
                                               l2x_a%rAttr(index_l2x_Sl_qref,n)   * frac
          x2a_a%rAttr(index_x2a_Sx_u10,n)    = x2a_a%rAttr(index_x2a_Sx_u10,n)    + &
                                               l2x_a%rAttr(index_l2x_Sl_u10,n)    * frac
          x2a_a%rAttr(index_x2a_Sx_uas,n)    = x2a_a%rAttr(index_x2a_Sx_uas,n)    + &
                                               l2x_a%rAttr(index_l2x_Sl_uas,n)    * frac
          x2a_a%rAttr(index_x2a_Sx_vas,n)    = x2a_a%rAttr(index_x2a_Sx_vas,n)    + &
                                               l2x_a%rAttr(index_l2x_Sl_vas,n)    * frac
          x2a_a%rAttr(index_x2a_Faxx_evap,n) = x2a_a%rAttr(index_x2a_Faxx_evap,n) + &
                                               l2x_a%rAttr(index_l2x_Fall_evap,n) * frac
          x2a_a%rAttr(index_x2a_Faxx_lwup,n) = x2a_a%rAttr(index_x2a_Faxx_lwup,n) + &
                                               l2x_a%rAttr(index_l2x_Fall_lwup,n) * frac
          x2a_a%rAttr(index_x2a_Faxx_sen,n)  = x2a_a%rAttr(index_x2a_Faxx_sen,n)  + &
                                               l2x_a%rAttr(index_l2x_Fall_sen,n)  * frac
          x2a_a%rAttr(index_x2a_Faxx_lat,n)  = x2a_a%rAttr(index_x2a_Faxx_lat,n)  + &
                                               l2x_a%rAttr(index_l2x_Fall_lat,n)  * frac
          x2a_a%rAttr(index_x2a_Faxx_taux,n) = x2a_a%rAttr(index_x2a_Faxx_taux,n) + &
                                               l2x_a%rAttr(index_l2x_Fall_taux,n) * frac
          x2a_a%rAttr(index_x2a_Faxx_tauy,n) = x2a_a%rAttr(index_x2a_Faxx_tauy,n) + &
                                               l2x_a%rAttr(index_l2x_Fall_tauy,n) * frac
          x2a_a%rAttr(index_x2a_Sx_t,n)      = x2a_a%rAttr(index_x2a_Sx_t,n)      + &
                                               l2x_a%rAttr(index_l2x_Sl_t,n)      * frac
          !--- CO2 flux from lnd ---
          if ( (index_x2a_Faxx_fco2_lnd /=0) .and. (index_l2x_Fall_fco2_lnd /=0)) then
             x2a_a%rAttr(index_x2a_Faxx_fco2_lnd,n) = l2x_a%rAttr(index_l2x_Fall_fco2_lnd,n) * frac
          end if
          
          if ( index_x2a_Faxx_flxvoc1 /= 0 ) &
               x2a_a%rAttr(index_x2a_Faxx_flxvoc1,n) = l2x_a%rAttr(index_l2x_Fall_flxvoc1,n)* frac
          if ( index_x2a_Faxx_flxvoc2 /= 0 ) &
               x2a_a%rAttr(index_x2a_Faxx_flxvoc2,n) = l2x_a%rAttr(index_l2x_Fall_flxvoc2,n)* frac
          if ( index_x2a_Faxx_flxvoc3 /= 0 ) &
               x2a_a%rAttr(index_x2a_Faxx_flxvoc3,n) = l2x_a%rAttr(index_l2x_Fall_flxvoc3,n)* frac
          if ( index_x2a_Faxx_flxvoc4 /= 0 ) &
               x2a_a%rAttr(index_x2a_Faxx_flxvoc4,n) = l2x_a%rAttr(index_l2x_Fall_flxvoc4,n)* frac
          if ( index_x2a_Faxx_flxvoc5 /= 0 ) &
               x2a_a%rAttr(index_x2a_Faxx_flxvoc5,n) = l2x_a%rAttr(index_l2x_Fall_flxvoc5,n)* frac
       end if


       frac = x2a_a%rAttr(index_x2a_Sx_ifrac,n)
       if (frac > 0._r8) then
          x2a_a%rAttr(index_x2a_Sx_avsdr,n)  = x2a_a%rAttr(index_x2a_Sx_avsdr,n)  + &
                                               i2x_a%rAttr(index_i2x_Si_avsdr,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_avsdf,n)  = x2a_a%rAttr(index_x2a_Sx_avsdf,n)  + &
                                               i2x_a%rAttr(index_i2x_Si_avsdf,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_anidr,n)  = x2a_a%rAttr(index_x2a_Sx_anidr,n)  + &
                                               i2x_a%rAttr(index_i2x_Si_anidr,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_anidf,n)  = x2a_a%rAttr(index_x2a_Sx_anidf,n)  + &
                                               i2x_a%rAttr(index_i2x_Si_anidf,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_tref,n)   = x2a_a%rAttr(index_x2a_Sx_tref,n)   + &
                                               i2x_a%rAttr(index_i2x_Si_tref,n)   * frac
          x2a_a%rAttr(index_x2a_Sx_qref,n)   = x2a_a%rAttr(index_x2a_Sx_qref,n)   + &
                                               i2x_a%rAttr(index_i2x_Si_qref,n)   * frac
          x2a_a%rAttr(index_x2a_Sx_u10,n)    = x2a_a%rAttr(index_x2a_Sx_u10,n)    + &
                                               i2x_a%rAttr(index_i2x_Si_u10,n)    * frac
          x2a_a%rAttr(index_x2a_Sx_uas,n)    = x2a_a%rAttr(index_x2a_Sx_uas,n)    + &
                                               i2x_a%rAttr(index_i2x_Si_uas,n)    * frac
          x2a_a%rAttr(index_x2a_Sx_vas,n)    = x2a_a%rAttr(index_x2a_Sx_vas,n)    + &
                                               i2x_a%rAttr(index_i2x_Si_vas,n)    * frac
          x2a_a%rAttr(index_x2a_Faxx_evap,n) = x2a_a%rAttr(index_x2a_Faxx_evap,n) + &
                                               i2x_a%rAttr(index_i2x_Faii_evap,n) * frac
          x2a_a%rAttr(index_x2a_Faxx_lwup,n) = x2a_a%rAttr(index_x2a_Faxx_lwup,n) + &
                                               i2x_a%rAttr(index_i2x_Faii_lwup,n) * frac
          x2a_a%rAttr(index_x2a_Faxx_sen,n)  = x2a_a%rAttr(index_x2a_Faxx_sen,n)  + &
                                               i2x_a%rAttr(index_i2x_Faii_sen,n)  * frac
          x2a_a%rAttr(index_x2a_Faxx_lat,n)  = x2a_a%rAttr(index_x2a_Faxx_lat,n)  + &
                                               i2x_a%rAttr(index_i2x_Faii_lat,n)  * frac
          x2a_a%rAttr(index_x2a_Faxx_taux,n) = x2a_a%rAttr(index_x2a_Faxx_taux,n) + &
                                               i2x_a%rAttr(index_i2x_Faii_taux,n) * frac
          x2a_a%rAttr(index_x2a_Faxx_tauy,n) = x2a_a%rAttr(index_x2a_Faxx_tauy,n) + &
                                               i2x_a%rAttr(index_i2x_Faii_tauy,n) * frac
          x2a_a%rAttr(index_x2a_Sx_t,n)      = x2a_a%rAttr(index_x2a_Sx_t,n) + &
                                               i2x_a%rAttr(index_i2x_Si_t,n) * frac
       end if

       frac = x2a_a%rAttr(index_x2a_Sx_ofrac,n)                                         
       if (frac > 0._r8) then                                                           
          x2a_a%rAttr(index_x2a_Sx_avsdr,n)  = x2a_a%rAttr(index_x2a_Sx_avsdr,n)  + &   
                                               xao_a%rAttr(index_xao_So_avsdr,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_avsdf,n)  = x2a_a%rAttr(index_x2a_Sx_avsdf,n)  + &   
                                               xao_a%rAttr(index_xao_So_avsdf,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_anidr,n)  = x2a_a%rAttr(index_x2a_Sx_anidr,n)  + &   
                                               xao_a%rAttr(index_xao_So_anidr,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_anidf,n)  = x2a_a%rAttr(index_x2a_Sx_anidf,n)  + &   
                                               xao_a%rAttr(index_xao_So_anidf,n)  * frac
          x2a_a%rAttr(index_x2a_Sx_tref,n)   = x2a_a%rAttr(index_x2a_Sx_tref,n)   + &   
                                               xao_a%rAttr(index_xao_So_tref,n)   * frac
          x2a_a%rAttr(index_x2a_Sx_qref,n)   = x2a_a%rAttr(index_x2a_Sx_qref,n)   + &   
                                               xao_a%rAttr(index_xao_So_qref,n)   * frac
          x2a_a%rAttr(index_x2a_Sx_u10,n)    = x2a_a%rAttr(index_x2a_Sx_u10,n)    + &   
                                               xao_a%rAttr(index_xao_So_u10,n)    * frac
          x2a_a%rAttr(index_x2a_Sx_uas,n)    = x2a_a%rAttr(index_x2a_Sx_uas,n)    + &
                                               xao_a%rAttr(index_xao_So_uas,n)    * frac
          x2a_a%rAttr(index_x2a_Sx_vas,n)    = x2a_a%rAttr(index_x2a_Sx_vas,n)    + &
                                               xao_a%rAttr(index_xao_So_vas,n)    * frac
          x2a_a%rAttr(index_x2a_Faxx_evap,n) = x2a_a%rAttr(index_x2a_Faxx_evap,n) + &   
                                               xao_a%rAttr(index_xao_Faox_evap,n) * frac
          x2a_a%rAttr(index_x2a_Faxx_lwup,n) = x2a_a%rAttr(index_x2a_Faxx_lwup,n) + &   
                                               xao_a%rAttr(index_xao_Faox_lwup,n) * frac
          x2a_a%rAttr(index_x2a_Faxx_sen,n)  = x2a_a%rAttr(index_x2a_Faxx_sen,n)  + &   
                                               xao_a%rAttr(index_xao_Faox_sen,n)  * frac
          x2a_a%rAttr(index_x2a_Faxx_lat,n)  = x2a_a%rAttr(index_x2a_Faxx_lat,n)  + &   
                                               xao_a%rAttr(index_xao_Faox_lat,n)  * frac
          x2a_a%rAttr(index_x2a_Faxx_taux,n) = x2a_a%rAttr(index_x2a_Faxx_taux,n) + &   
                                               xao_a%rAttr(index_xao_Faox_taux,n) * frac
          x2a_a%rAttr(index_x2a_Faxx_tauy,n) = x2a_a%rAttr(index_x2a_Faxx_tauy,n) + &   
                                               xao_a%rAttr(index_xao_Faox_tauy,n) * frac
          x2a_a%rAttr(index_x2a_Sx_t,n)      = x2a_a%rAttr(index_x2a_Sx_t,n)      + &   
                                               o2x_a%rAttr(index_o2x_So_t,n)      * frac
       end if
       !--- CO2 flux from ocn ---
       if ( (index_x2a_Faxx_fco2_ocn /=0) .and. (index_o2x_Faoo_fco2 /=0)) then
          x2a_a%rAttr(index_x2a_Faxx_fco2_ocn,n) = o2x_a%rAttr(index_o2x_Faoo_fco2,n)
       end if
       
       !--- DMS flux from ocn --- 
       if ( (index_x2a_Faxx_fdms /=0) .and. (index_o2x_Faoo_fdms /=0)) then
          x2a_a%rAttr(index_x2a_Faxx_fdms,n) = o2x_a%rAttr(index_o2x_Faoo_fdms,n)
       end if
       
    end do

  end subroutine mrg_x2a_run_mct
!
!===========================================================================================
!
  subroutine mrg_x2a_final_mct
    ! ******************
    ! Do nothing for now
    ! ******************
  end subroutine mrg_x2a_final_mct

end module mrg_x2a_mct

