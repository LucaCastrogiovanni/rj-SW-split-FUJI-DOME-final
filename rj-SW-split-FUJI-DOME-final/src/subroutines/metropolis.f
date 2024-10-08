c
c
c       subroutine METROPOLIS
c
c-------------------------------------------------------------------------------------------
c
c INPUT:
c         im --   model index
c         lppd -- log value of the norm factor of the Likelihood
c         lppd -- log value of the exponential component of the Likelihood
c
c OUTPUT:
c         accepted --   Flag for the Metropolis rule output (see below)
c
c-------------------------------------------------------------------------------------------
c
c METROPOLIS RULE OUTPUT will be:
c
c (ACCEPTED= -1) Candidate model is accepted w/ Metropolis rule (Likelihood is decreased)
c (ACCEPTED=  0) Candidate model is rejected
c (ACCEPTED=  1) Candidate model is accepted w/o Metropolis rule (Likelihood is increased)
c
c-------------------------------------------------------------------------------------------
c
c
        subroutine metropolis(im,lh_norm,lppd,accepted)


        include '../trans_dim.para'


        include '../common.recipe'
        include '../common.misfit'
        include '../common.randomtype'

c
c MAIN variables

        integer im, accepted
        real*4 lh_norm, lppd


c
c Scratch variables

        real*4 alpha

c
c RAN3 variables
        real*4 p, ran3


        if(im.eq.1)alpha=1.0
        if(im.ne.1)       alpha=  1.d0 *
     &       exp( lh_norm0 - lh_norm - 0.5d0*(lppd-lppd0) )

        if(info)write(*,'(a,4f16.4)') ' ++RjSPLIT:: METROPOLIS lppd/lppd0/lh_norm/lh_norm0 :',lppd,lppd0,lh_norm,lh_norm0
        if(info)write(*,'(a,1f24.4)') ' ++RjSPLIT:: METROPOLIS -- ALPHA: ', alpha
        if(.not.posterior)alpha=1.0

        if(alpha.ge.1.0)then

          accepted=1
          lh_norm0=lh_norm
          lppd0=lppd
          if(info)write(*,'(a,i6)') ' ++RjSPLIT:: METROPOLIS -- Cand ACCEPTED w/o RULE: ', accepted

        else if(alpha.lt.1.0)then

          p=ran3(iseed0)

          if(alpha.ge.p)then
     
            accepted=-1
            lh_norm0=lh_norm
            lppd0=lppd
            if(info)write(*,'(a,f10.4,i6)') ' ++RjSPLIT:: METROPOLIS -- Cand ACCEPTED w/ RULE: ', alpha, accepted


          else

            accepted=0
            if(info)write(*,'(a,f10.4,i6)') ' ++RjSPLIT:: METROPOLIS -- Cand REJECTED: ', alpha, accepted


          endif

        endif



        return
        end
