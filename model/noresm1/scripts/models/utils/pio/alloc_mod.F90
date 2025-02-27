!===================================================
! DO NOT EDIT THIS FILE, it was generated using /global/homes/j/jedwards/pio_trunk/pio/genf90.pl 
! Any changes you make to this file may be lost
!===================================================
#define __PIO_FILE__ "alloc_mod.F90.in"
module alloc_mod

  use pio_kinds
  use pio_types
  use pio_support, only : piodie, CheckMPIreturn, debug
  implicit none
  private

!>
!! @private
!! PIO internal memory allocation check routines.  
!<
  public:: alloc_check
!>
!! @private
!! PIO internal memory allocation check routines.  
!<
  public:: dealloc_check 

# 21 "alloc_mod.F90.in"
  interface alloc_check
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure alloc_check_1d_long 
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure alloc_check_2d_long 
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure alloc_check_1d_int 
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure alloc_check_2d_int 
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure alloc_check_1d_real 
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure alloc_check_2d_real 
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure alloc_check_1d_double 
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure alloc_check_2d_double 
     ! TYPE double,long,int,real
     module procedure alloc_check_0d_double
     ! TYPE double,long,int,real
     module procedure alloc_check_0d_long
     ! TYPE double,long,int,real
     module procedure alloc_check_0d_int
     ! TYPE double,long,int,real
     module procedure alloc_check_0d_real
 end interface


# 29 "alloc_mod.F90.in"
  interface dealloc_check
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure dealloc_check_1d_long
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure dealloc_check_2d_long
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure dealloc_check_1d_int
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure dealloc_check_2d_int
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure dealloc_check_1d_real
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure dealloc_check_2d_real
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure dealloc_check_1d_double
     ! TYPE long,int,real,double ! DIMS 1,2
     module procedure dealloc_check_2d_double
     ! TYPE double,long,int,real
     module procedure dealloc_check_0d_double
     ! TYPE double,long,int,real
     module procedure dealloc_check_0d_long
     ! TYPE double,long,int,real
     module procedure dealloc_check_0d_int
     ! TYPE double,long,int,real
     module procedure dealloc_check_0d_real
  end interface


!>
!! @private
!! PIO internal memory allocation check routines.  
!<
  public :: alloc_print_usage

!>
!! @private
!! PIO internal memory allocation check routines.  
!<
  public :: alloc_trace_on

!>
!! @private
!! PIO internal memory allocation check routines.  
!<
  public :: alloc_trace_off

  character(len=*), parameter :: modName='pio::alloc_mod'

# 57 "alloc_mod.F90.in"
contains

  !
  ! Instantiate all the variations of alloc_check_ and dealloc_check_
  !

  ! TYPE long,int,real,double 
# 64 "alloc_mod.F90.in"
  subroutine alloc_check_1d_long (data,varlen,msg)

    integer(i8), pointer :: data(:)
    integer, intent(in) :: varlen
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::alloc_check_1d_long'

    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,varlen
       else
          print *,__PIO_FILE__,__LINE__,varlen
       end if
    end if


    if(varlen==0) then
      allocate(data(1),stat=ierr)
    else
      allocate(data(varlen),stat=ierr)
    endif
    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('alloc_check_1d_long',__LINE__,'allocate failed on task:',&
            msg2=msg)
       else
          call piodie('alloc_check_1d_long',__LINE__,'allocate failed on task:')
       endif
    endif

  end subroutine alloc_check_1d_long

  !
  ! Instantiate all the variations of alloc_check_ and dealloc_check_
  !

  ! TYPE long,int,real,double 
# 64 "alloc_mod.F90.in"
  subroutine alloc_check_1d_int (data,varlen,msg)

    integer(i4), pointer :: data(:)
    integer, intent(in) :: varlen
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::alloc_check_1d_int'

    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,varlen
       else
          print *,__PIO_FILE__,__LINE__,varlen
       end if
    end if


    if(varlen==0) then
      allocate(data(1),stat=ierr)
    else
      allocate(data(varlen),stat=ierr)
    endif
    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('alloc_check_1d_int',__LINE__,'allocate failed on task:',&
            msg2=msg)
       else
          call piodie('alloc_check_1d_int',__LINE__,'allocate failed on task:')
       endif
    endif

  end subroutine alloc_check_1d_int

  !
  ! Instantiate all the variations of alloc_check_ and dealloc_check_
  !

  ! TYPE long,int,real,double 
# 64 "alloc_mod.F90.in"
  subroutine alloc_check_1d_real (data,varlen,msg)

    real(r4), pointer :: data(:)
    integer, intent(in) :: varlen
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::alloc_check_1d_real'

    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,varlen
       else
          print *,__PIO_FILE__,__LINE__,varlen
       end if
    end if


    if(varlen==0) then
      allocate(data(1),stat=ierr)
    else
      allocate(data(varlen),stat=ierr)
    endif
    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('alloc_check_1d_real',__LINE__,'allocate failed on task:',&
            msg2=msg)
       else
          call piodie('alloc_check_1d_real',__LINE__,'allocate failed on task:')
       endif
    endif

  end subroutine alloc_check_1d_real

  !
  ! Instantiate all the variations of alloc_check_ and dealloc_check_
  !

  ! TYPE long,int,real,double 
# 64 "alloc_mod.F90.in"
  subroutine alloc_check_1d_double (data,varlen,msg)

    real(r8), pointer :: data(:)
    integer, intent(in) :: varlen
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::alloc_check_1d_double'

    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,varlen
       else
          print *,__PIO_FILE__,__LINE__,varlen
       end if
    end if


    if(varlen==0) then
      allocate(data(1),stat=ierr)
    else
      allocate(data(varlen),stat=ierr)
    endif
    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('alloc_check_1d_double',__LINE__,'allocate failed on task:',&
            msg2=msg)
       else
          call piodie('alloc_check_1d_double',__LINE__,'allocate failed on task:')
       endif
    endif

  end subroutine alloc_check_1d_double

  ! TYPE long,int,real,double 
# 100 "alloc_mod.F90.in"
  subroutine alloc_check_2d_long (data,size1, size2,msg)

    integer(i8), pointer :: data(:,:)
    integer, intent(in) :: size1, size2
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::alloc_check_2d_long'
    integer ierr, ierror, rank

    allocate(data(size1,size2),stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('alloc_check_2d_long',__LINE__,'allocate failed on task:',&
            msg2=msg)
       else
          call piodie('alloc_check_2d_long',__LINE__,'allocate failed on task:')
       endif
    endif

  end subroutine alloc_check_2d_long

  ! TYPE long,int,real,double 
# 100 "alloc_mod.F90.in"
  subroutine alloc_check_2d_int (data,size1, size2,msg)

    integer(i4), pointer :: data(:,:)
    integer, intent(in) :: size1, size2
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::alloc_check_2d_int'
    integer ierr, ierror, rank

    allocate(data(size1,size2),stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('alloc_check_2d_int',__LINE__,'allocate failed on task:',&
            msg2=msg)
       else
          call piodie('alloc_check_2d_int',__LINE__,'allocate failed on task:')
       endif
    endif

  end subroutine alloc_check_2d_int

  ! TYPE long,int,real,double 
# 100 "alloc_mod.F90.in"
  subroutine alloc_check_2d_real (data,size1, size2,msg)

    real(r4), pointer :: data(:,:)
    integer, intent(in) :: size1, size2
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::alloc_check_2d_real'
    integer ierr, ierror, rank

    allocate(data(size1,size2),stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('alloc_check_2d_real',__LINE__,'allocate failed on task:',&
            msg2=msg)
       else
          call piodie('alloc_check_2d_real',__LINE__,'allocate failed on task:')
       endif
    endif

  end subroutine alloc_check_2d_real

  ! TYPE long,int,real,double 
# 100 "alloc_mod.F90.in"
  subroutine alloc_check_2d_double (data,size1, size2,msg)

    real(r8), pointer :: data(:,:)
    integer, intent(in) :: size1, size2
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::alloc_check_2d_double'
    integer ierr, ierror, rank

    allocate(data(size1,size2),stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('alloc_check_2d_double',__LINE__,'allocate failed on task:',&
            msg2=msg)
       else
          call piodie('alloc_check_2d_double',__LINE__,'allocate failed on task:')
       endif
    endif

  end subroutine alloc_check_2d_double

  !
  !
  !
  ! TYPE long,int,real,double ! DIMS 1,2
# 126 "alloc_mod.F90.in"
  subroutine dealloc_check_1d_long (data,msg)

    integer(i8), pointer :: data(:)
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::dealloc_check_1d_long'
    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,size(data)
       else
          print *,__PIO_FILE__,__LINE__,size(data)
       end if
    end if


    deallocate(data,stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_1d_long',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_1d_long',__LINE__, &
               ': deallocate failed on task:')
       endif

    endif

  end subroutine dealloc_check_1d_long

  !
  !
  !
  ! TYPE long,int,real,double ! DIMS 1,2
# 126 "alloc_mod.F90.in"
  subroutine dealloc_check_2d_long (data,msg)

    integer(i8), pointer :: data(:,:)
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::dealloc_check_2d_long'
    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,size(data)
       else
          print *,__PIO_FILE__,__LINE__,size(data)
       end if
    end if


    deallocate(data,stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_2d_long',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_2d_long',__LINE__, &
               ': deallocate failed on task:')
       endif

    endif

  end subroutine dealloc_check_2d_long

  !
  !
  !
  ! TYPE long,int,real,double ! DIMS 1,2
# 126 "alloc_mod.F90.in"
  subroutine dealloc_check_1d_int (data,msg)

    integer(i4), pointer :: data(:)
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::dealloc_check_1d_int'
    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,size(data)
       else
          print *,__PIO_FILE__,__LINE__,size(data)
       end if
    end if


    deallocate(data,stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_1d_int',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_1d_int',__LINE__, &
               ': deallocate failed on task:')
       endif

    endif

  end subroutine dealloc_check_1d_int

  !
  !
  !
  ! TYPE long,int,real,double ! DIMS 1,2
# 126 "alloc_mod.F90.in"
  subroutine dealloc_check_2d_int (data,msg)

    integer(i4), pointer :: data(:,:)
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::dealloc_check_2d_int'
    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,size(data)
       else
          print *,__PIO_FILE__,__LINE__,size(data)
       end if
    end if


    deallocate(data,stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_2d_int',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_2d_int',__LINE__, &
               ': deallocate failed on task:')
       endif

    endif

  end subroutine dealloc_check_2d_int

  !
  !
  !
  ! TYPE long,int,real,double ! DIMS 1,2
# 126 "alloc_mod.F90.in"
  subroutine dealloc_check_1d_real (data,msg)

    real(r4), pointer :: data(:)
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::dealloc_check_1d_real'
    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,size(data)
       else
          print *,__PIO_FILE__,__LINE__,size(data)
       end if
    end if


    deallocate(data,stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_1d_real',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_1d_real',__LINE__, &
               ': deallocate failed on task:')
       endif

    endif

  end subroutine dealloc_check_1d_real

  !
  !
  !
  ! TYPE long,int,real,double ! DIMS 1,2
# 126 "alloc_mod.F90.in"
  subroutine dealloc_check_2d_real (data,msg)

    real(r4), pointer :: data(:,:)
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::dealloc_check_2d_real'
    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,size(data)
       else
          print *,__PIO_FILE__,__LINE__,size(data)
       end if
    end if


    deallocate(data,stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_2d_real',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_2d_real',__LINE__, &
               ': deallocate failed on task:')
       endif

    endif

  end subroutine dealloc_check_2d_real

  !
  !
  !
  ! TYPE long,int,real,double ! DIMS 1,2
# 126 "alloc_mod.F90.in"
  subroutine dealloc_check_1d_double (data,msg)

    real(r8), pointer :: data(:)
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::dealloc_check_1d_double'
    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,size(data)
       else
          print *,__PIO_FILE__,__LINE__,size(data)
       end if
    end if


    deallocate(data,stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_1d_double',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_1d_double',__LINE__, &
               ': deallocate failed on task:')
       endif

    endif

  end subroutine dealloc_check_1d_double

  !
  !
  !
  ! TYPE long,int,real,double ! DIMS 1,2
# 126 "alloc_mod.F90.in"
  subroutine dealloc_check_2d_double (data,msg)

    real(r8), pointer :: data(:,:)
    character(len=*), intent(in), optional:: msg

    character(len=*), parameter :: subName=modName//'::dealloc_check_2d_double'
    integer ierr, ierror, rank

    if(debug) then
       if(present(msg)) then
          print *,__PIO_FILE__,__LINE__,msg,size(data)
       else
          print *,__PIO_FILE__,__LINE__,size(data)
       end if
    end if


    deallocate(data,stat=ierr)

    if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_2d_double',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_2d_double',__LINE__, &
               ': deallocate failed on task:')
       endif

    endif

  end subroutine dealloc_check_2d_double

! TYPE long,int,real,double
# 159 "alloc_mod.F90.in"
  subroutine alloc_check_0d_long(data,msg)

  integer(i8), pointer :: data
  character(len=*), intent(in), optional:: msg

  character(len=*), parameter :: subName=modName//'::alloc_check_0d_long'
  integer ierr, ierror, rank

  allocate(data,stat=ierr)

  if (ierr /= 0) then
     if (present(msg)) then
        call piodie('alloc_check_0d_long',__LINE__,'allocate failed on task:',&
             msg2=msg)
     else
        call piodie('alloc_check_0d_long',__LINE__,'allocate failed on task:')
     endif

  endif

end subroutine alloc_check_0d_long

! TYPE long,int,real,double
# 159 "alloc_mod.F90.in"
  subroutine alloc_check_0d_int(data,msg)

  integer(i4), pointer :: data
  character(len=*), intent(in), optional:: msg

  character(len=*), parameter :: subName=modName//'::alloc_check_0d_int'
  integer ierr, ierror, rank

  allocate(data,stat=ierr)

  if (ierr /= 0) then
     if (present(msg)) then
        call piodie('alloc_check_0d_int',__LINE__,'allocate failed on task:',&
             msg2=msg)
     else
        call piodie('alloc_check_0d_int',__LINE__,'allocate failed on task:')
     endif

  endif

end subroutine alloc_check_0d_int

! TYPE long,int,real,double
# 159 "alloc_mod.F90.in"
  subroutine alloc_check_0d_real(data,msg)

  real(r4), pointer :: data
  character(len=*), intent(in), optional:: msg

  character(len=*), parameter :: subName=modName//'::alloc_check_0d_real'
  integer ierr, ierror, rank

  allocate(data,stat=ierr)

  if (ierr /= 0) then
     if (present(msg)) then
        call piodie('alloc_check_0d_real',__LINE__,'allocate failed on task:',&
             msg2=msg)
     else
        call piodie('alloc_check_0d_real',__LINE__,'allocate failed on task:')
     endif

  endif

end subroutine alloc_check_0d_real

! TYPE long,int,real,double
# 159 "alloc_mod.F90.in"
  subroutine alloc_check_0d_double(data,msg)

  real(r8), pointer :: data
  character(len=*), intent(in), optional:: msg

  character(len=*), parameter :: subName=modName//'::alloc_check_0d_double'
  integer ierr, ierror, rank

  allocate(data,stat=ierr)

  if (ierr /= 0) then
     if (present(msg)) then
        call piodie('alloc_check_0d_double',__LINE__,'allocate failed on task:',&
             msg2=msg)
     else
        call piodie('alloc_check_0d_double',__LINE__,'allocate failed on task:')
     endif

  endif

end subroutine alloc_check_0d_double




! TYPE long,int,real,double
# 185 "alloc_mod.F90.in"
subroutine dealloc_check_0d_long (data,msg)

  integer(i8), pointer :: data
  character(len=*), intent(in), optional:: msg

  character(len=*), parameter :: subName=modName//'::dealloc_check_0d_long'
  integer ierr, ierror, rank

  deallocate(data,stat=ierr)

  if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_0d_long',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_0d_long',__LINE__, &
               ': deallocate failed on task:')
       endif

  endif

end subroutine dealloc_check_0d_long




! TYPE long,int,real,double
# 185 "alloc_mod.F90.in"
subroutine dealloc_check_0d_int (data,msg)

  integer(i4), pointer :: data
  character(len=*), intent(in), optional:: msg

  character(len=*), parameter :: subName=modName//'::dealloc_check_0d_int'
  integer ierr, ierror, rank

  deallocate(data,stat=ierr)

  if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_0d_int',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_0d_int',__LINE__, &
               ': deallocate failed on task:')
       endif

  endif

end subroutine dealloc_check_0d_int




! TYPE long,int,real,double
# 185 "alloc_mod.F90.in"
subroutine dealloc_check_0d_real (data,msg)

  real(r4), pointer :: data
  character(len=*), intent(in), optional:: msg

  character(len=*), parameter :: subName=modName//'::dealloc_check_0d_real'
  integer ierr, ierror, rank

  deallocate(data,stat=ierr)

  if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_0d_real',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_0d_real',__LINE__, &
               ': deallocate failed on task:')
       endif

  endif

end subroutine dealloc_check_0d_real




! TYPE long,int,real,double
# 185 "alloc_mod.F90.in"
subroutine dealloc_check_0d_double (data,msg)

  real(r8), pointer :: data
  character(len=*), intent(in), optional:: msg

  character(len=*), parameter :: subName=modName//'::dealloc_check_0d_double'
  integer ierr, ierror, rank

  deallocate(data,stat=ierr)

  if (ierr /= 0) then
       if (present(msg)) then
          call piodie('dealloc_check_0d_double',__LINE__, &
               ': deallocate failed on task:',msg2=msg)
       else
          call piodie('dealloc_check_0d_double',__LINE__, &
               ': deallocate failed on task:')
       endif

  endif

end subroutine dealloc_check_0d_double

!>
!! @private
!! @fn alloc_print_usage
!! PIO internal memory allocation check routines.  
!<
# 213 "alloc_mod.F90.in"
  subroutine alloc_print_usage(rank,msg)
  include 'mpif.h'        ! _EXTERNAL

    integer, intent(in) :: rank
    character(len=*), intent(in), optional :: msg

    character(len=*), parameter :: subName=modName//'::alloc_print_usage'
    integer ierr, myrank

#ifdef _TESTMEM
    call MPI_COMM_RANK(MPI_COMM_WORLD,myrank,ierr)
    call CheckMPIReturn(subName,ierr)
#ifdef _MEMMON
    if ( rank<0 .or. rank==myrank ) then
       print *,''
       if (present(msg)) then
          print *,myrank,': alloc_print_usage: ',msg
       else
          print *,myrank,': alloc_print_usage: '
       endif

       call memmon_print_usage

       print *,''

    endif
#endif

#ifdef _STACKMON
    if ( myrank == 0 ) then
       print *,''
       print *,myrank,': alloc_print_usage: ',msg
       print *,myrank,': writing stackmonitor.txt'
    endif

    call print_stack_size
#endif


#endif  /* _TESTMEM */

  end subroutine alloc_print_usage



# 258 "alloc_mod.F90.in"
  subroutine alloc_trace_on(rank,msg)

    integer, intent(in) :: rank
    character(len=*), intent(in), optional :: msg

    character(len=*), parameter :: subName=modName//'::alloc_trace_on'
    integer ierr, myrank

#ifdef _TESTMEM
#ifdef _MEMMON
    call MPI_COMM_RANK(MPI_COMM_WORLD,myrank,ierr)
    call CheckMPIReturn(subName,ierr)
    if ( rank<0 .or. rank==myrank ) then
       if (present(msg)) then
          print *,myrank,': alloc_trace_on: ',msg
       else
          print *,myrank,': alloc_trace_on: '
       endif
       call memmon_trace_on(myrank)
       print *,''

    endif

#endif
#endif

  end subroutine alloc_trace_on



# 288 "alloc_mod.F90.in"
  subroutine alloc_trace_off(rank,msg)

    integer, intent(in) :: rank
    character(len=*), intent(in), optional :: msg

    character(len=*), parameter :: subName=modName//'::alloc_trace_off'
    integer ierr, myrank

#ifdef _TESTMEM
#ifdef _MEMMON

    call MPI_COMM_RANK(MPI_COMM_WORLD,myrank,ierr)
    call CheckMPIReturn(subName,ierr)
    if ( rank<0 .or. rank==myrank ) then
       if (present(msg)) then
          print *,myrank,': alloc_trace_off: ',msg
       else
          print *,myrank,': alloc_trace_off: '
       endif
       call memmon_trace_off(myrank)
       print *,''

    endif

#endif
#endif

  end subroutine alloc_trace_off


end module alloc_mod
