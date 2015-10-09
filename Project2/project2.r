# project2.r
# Keith Herbert
# 
# Last edit: 07 Oct 2015

# Constants
data_filename <- 'project1data.csv' # path to project1 data
MAX_ITER <- 1000    # limit on how many times to repeat perceptron   
ALPHA <- 0.5        # learning constant         

# Height Weight Sex data from project1
hws <- read.csv( data_filename )


# divide into 75% training, 25% testing
## random sample indices without replacement 
train_ind <- sample( (1:nrow(hws)), nrow(hws)*0.75 )

## create training set dataframe from the sample indices  
train_set <- hws[train_ind,]

## create testing set dataframe from the complement of sample indices
test_set <- hws[-train_ind,]

# define the perceptron
w <- c(0,0,0)
perceptron <- function(x, y, d, w){
    
    d <- sign(d)
    
    w_1 <- w[1]
    w_2 <- w[2]
    w_3 <- w[3]
    
    net <- w_1*x + w_2*y + w_3
    
    out <- net
    
    #adjust_w(w_1, w_2, w_3)
    
    return(out)
}

adjust_w <- function(w_1, w_2, w_3){
    ALPHA*x*(d - sign(net))
}

# run the set through the perceptron 
apply(  train_set[,],   
        1, 
        function(x) perceptron('height', 'weight', 'sex'))

mapply(perceptron, train_set$height, train_set$weight, train_set$sex, w)

hard_activation <- function(x) {
    y = 0.5
    if (x > 0 || x < 0) { 
        y <- sign(x) 
    }
    return( y )
}

perceptron <- function( dataset, alpha){
    w <- c(1,1,1)
    out <- rep( 0, nrow(dataset) )
    dout <- dataset[,3]
    for(i in 1:MAX_ITER){
        for (r in 1:nrow(dataset)) {
            net <- w[1]*dataset[r,1] + w[2]*dataset[r,2] + w[3]
            out[r] <- hard_activation(net)
            error <- dout[r]-out[r]
            learn <- alpha * error
            
            w[1] <- w[1] + learn * dataset[r,1]
            w[2] <- w[2] + learn * dataset[r,1]
        }
    }
    
    return(out)
}

perceptron(train_set, 0.3)

