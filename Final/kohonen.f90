!! Kohonen.f90
!! Keith Herbert
!! Implements a Kohonen Winner-Take-All clustering algorithm
!! Based on slides from Session 11
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

program kohonen
    implicit none    
    interface
        integer function CountLinesInFile(filename) result (lineCount)
            character(len=*), intent(in) :: filename
        end function
    end interface

    character(len=64)   :: filename_in, &  !! input file from command line 
                           filename_out,&  !! output file from command line
                           str_alpha,   &  !! learning rate alpha from command line
                           str_n,       &  !! feature dimension from command line
                           str_m           !! neuron count from command line
    character(len=*),parameter :: filename_neurons = "neurons.txt"

    integer             ::  fu_in, &       !! input file unit
                            fu_out         !! output file unit

    real                :: alpha           !! learning rate from command line                   

    real, allocatable   :: X(:,:), &    !! original pattern matrix
                           Z(:,:), &    !! normalized pattern matrix    
                           V(:,:), &    !! neuron matrix
                           nets(:),&    !! the net values for each neuron
                           P(:)         !! single pattern from Z
                                        
    integer             :: i,j,k,&      !! index variables  
                           m,    &      !! how many neurons
                           n,    &      !! how many features for each pattern
                           length_X,&   !! how many patterns in dataset
                           clock_seed   !! system clock used to seed PRNG
 
    !! Set command line arguments
    call get_command_argument(1, filename_in)
    call get_command_argument(2, filename_out)
    call get_command_argument(3, str_m)
    call get_command_argument(4, str_n)
    call get_command_argument(5, str_alpha)
    read (str_m, *) m
    read (str_n, *) n 
    read (str_alpha, *) alpha

    !! Read in the data file and save it as a feature vector
    print *, "Reading patterns from ", filename_in
    
    length_X = CountLinesInFile(filename_in) - 1
    allocate(X(length_X, n))

    open(unit=fu_in, file=filename_in, status='old')
    read(fu_in, *) X
    close(fu_in)

    !! Normalize the values in the feature vector between [0,1]
    !! z_i = x_i / sqrt( sumofallsquares(x) )
    
    allocate(Z(n, length_X))    !! store patterns in column-major order, n rows and length_X rows
    
    do i=1,length_X
        Z(1:n, i) = abs( X(i, 1:n) / sqrt( sum( X(i, 1:n)**2 )) )
!       print *, Z(1:n, i)
    end do

    !! write the normalized patterns to file
    open(unit=11, file="normalized_patterns.txt")
        do i=1,length_X
            write(11,*) Z(1:n, i)
        enddo
    close(11)


    !! Set up the neurons
    allocate(V(n, m))       !! V = neuron matrix with rows=#features and cols=#neurons 
    
    !! Initialize the neurons with random weights between [0,1]
    call system_clock(clock_seed)
    call random_seed(clock_seed)
    call random_number(V)
    
    !! Normalize neuron weights
    !! v_i = w_i / sqrt( sum{i=1}{n}(w_i^2) )
    do i=1,m    !! for each neuron
        V(1:n, i) = abs( V(i, 1:n) / sqrt( sum( V(i, 1:n)**2 )) )
!       print *, V(1:n, i) 
    end do

    !! Apply a pattern to the network
    allocate(nets(m))
    allocate(P(n))

    do i=1,length_X
        !! prepare a 1 x n single pattern vector
        P = Z(i, 1:n)
        
        !! Calculate net values for each neuron
        !! net = Sum(z_i*v_i) = ZV^T
        nets = matmul(P, V)    
       
        print *, "pattern: ", P
        print *, "net values: ", nets

        !! Select winning neuron (largest net value)
        k = maxloc(nets, dim=1)
        print *, "winning neuron: ", k


        !! Modify weights for winner by learning constant alpha
        !! W_k = V_k + alpha*Z
        V(1:n, k) = V(1:n, k) + alpha*P
        
        print *, "new weights: ", V(k,1:n) 
        
        !! Normalize the weights for just the winning neuron
        V(1:n, k) = abs( V(k, 1:n) / sqrt( sum( V(1:n, k)**2 )) )
        print *, "normalized: ", V(k,1:n) 
        print *, "==============="
    end do 
   
    print *, "Final neuron weights"
    !! write final neuron weights to file
    open(unit=11, file=filename_neurons)
        do i=1,m
            print *, V(i,1:n) 
            write(11, *) V(i, 1:n)
        end do
    close(11)

end program

integer function CountLinesInFile(filename) result (lineCount)
    implicit none
    character(len=*), intent(in) :: filename
    integer :: iostatus
    character(len=1) :: a

    lineCount = 0
    open(unit=11, file=filename, status='old')
        do
            read(11, *, iostat=iostatus) a  
            if (iostatus .EQ. 0) then
                if (a .NE. "") then
                    lineCount = lineCount + 1
                endif
            else
                exit
            end if
       end do
    close(unit=11)
    
    return
    
end function CountLinesInFile
