# project2.r
# Keith Herbert
# 
# Last edit: 07 Oct 2015

# Constants ###################################################################
data_filename <- 'project1data.csv' # path to project1 data
MAX_ITER    <- 1000    # limit on how many times to repeat perceptron   
ALPHA       <- 0.5     # learning constant
EPSILON     <- 1e-5    # Minimum error  
K           <- 5       # soft activation constant

###############################################################################
# Functions
###############################################################################

# Hard Activation Perceptron
###############################################################################
# This is modeled after the Perl code in the session 10 slides.
# I tried writing it more "Lispy" as a function or set of functions to
# apply() to an arbitrary set but went in circles.
## Input: a dataframe with three columns: x_1, x_2, label of {-1, 1} 
## Output: weights for the perceptron as c(w_1, w_2, w_3) 
hard_perceptron <- function( dataset, alpha) { 
    w <- runif(3) * 100             # set weights to random values
    out <- rep( 0, nrow(dataset) )  # zero-fill output vector
    dout <- dataset[,3]             # grab desired output vector
    error <- 1                      # give error a value. quit when < EPSILON
    for(i in 1:MAX_ITER){
        for (r in 1:nrow(dataset)) {
            net <- w[1]*dataset[r,1] + w[2]*dataset[r,2] + w[3]
            out[r] <- hard_activation(net)
            error <- dout[r]-out[r]
            learn <- alpha * error
            
            w[1] <- w[1] + learn * dataset[r,1]
            w[2] <- w[2] + learn * dataset[r,1]
        }
        if (abs(error) < EPSILON) {
            break
         }
    }
    
    return(w)   # return weights
}

# Hard Activation function to assign pattern's net score to label {-1, 1}
# Input: arbitrary numerical x
# Output: the sign of x, or 0.5 if x == 0
hard_activation <- function(x) {
    y = 0.5
    if (x > 0 || x < 0) { 
        y <- sign(x) 
    }
    return(y)
}

# Soft Activation Perceptron
###############################################################################
soft_perceptron <- function( dataset, alpha, k) { 
    w <- runif(3)                   # set weights to random values
    out <- rep( 0, nrow(dataset) )  # zero-fill output vector
    dout <- dataset[,3]             # grab desired output vector
    error <- 1                      # give error a value. quit when < 1.0e-5
    for(i in 1:MAX_ITER){
        for (r in 1:nrow(dataset)) {
            net <- w[1]*dataset[r,1] + w[2]*dataset[r,2] + w[3]
            if (missing(k)) {
                out[r] <- hard_activation(net)            
            } 
            else {
                out[r] <- soft_activation(net, k)
            }
        }
        error <- (dout[r]-out[r]) / length(dout)
        learn <- alpha * error
            
        w[1] <- w[1] + learn * dataset[r,1]
        w[2] <- w[2] + learn * dataset[r,1]
        
        
        cat("error: ", error, "weights: ", w,  "\n")
        cat("y = ", w[1]/w[2], "x + ", w[3]/w[2], "\n")
        
        if (abs(error) < EPSILON) { 
            break
         }
    }
    
    return(w)   # return weights
}

# Soft Activation
soft_activation <- function(x, k) {
    y <- 1 / (1 + exp(-k*x))
    return(y)
}

###############################################################################
# Begin Program
############################################################################### 

# Import Height Weight Sex (hws) data from project1
hws <- read.csv( data_filename )

# Convert 'sex' label from {0, 1} to {-1, 1}
hws$sex[hws$sex == 0] <- -1

# divide into 75% training, 25% testing
## random sample indices without replacement 
train_ind <- sample( (1:nrow(hws)), nrow(hws)*0.75 )

## create training set dataframe from the sample indices  
train_set <- hws[train_ind,]

## create testing set dataframe from the complement of sample indices
test_set <- hws[-train_ind,]

hard_weights <- hard_perceptron(train_set, ALPHA)

soft_weights <- soft_perceptron(train_set, ALPHA, K)

plot(hws$height[hws$sex == 1], hws$weight[hws$sex == 1], 
    col='blue', pch=3,
    xlab='Height (cm)', ylab='Weight (kg)',
    xlim=range(hws$height),
    ylim=range(hws$weight)
)
points(hws$height[hws$sex == -1], hws$weight[hws$sex == -1], col='red', pch=3)
title('Male and Female Height vs Weight')

w <- hard_weights
abline(w[3]/w[2], w[1]/w[2], col = 'forestgreen', lwd = 3)

# Draw the legend (annoyingly difficult)
legend( x='topleft', 
        legend=c('Male', 'Female', 'Decision Function'),
        lty=1, lwd=3, 
        bg='white',
        col=c('white', 'white','forestgreen'))
legend( x='topleft', 
        legend=c('', '', ''), 
        text.col=NA,
        pch=1,
        lty=c(0,0,1),
        col=c('blue','red', NA))




