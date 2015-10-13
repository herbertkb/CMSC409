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

# Perceptron
###############################################################################
# This is modeled after the Perl code in the session 10 slides.
# I tried writing it more "Lispy" as a function or set of functions to
# apply() to an arbitrary set but went in circles.
## Input: dataframe with three columns: x_1, x_2, label of {-1, 1} 
##        numeric learning constant alpha
## Optional: soft activation constant k. (default approximates hard activation)
##           maxiumum iteration count max_iter (deault 1,000 iterations)
##           minimum error (default 1e-5)
## Output: weights for the perceptron as c(w_1, w_2, w_3) 

perceptron <- function (dataset, alpha, k = 30, max_iter=1000, min_error=1e-5) {
    w   <- runif(3)
    out <- rep(0, nrow(dataset))
    d   <- dataset[,3]
    R   <- max(apply(dataset[, 1:2], 1, function(x) sqrt(sum(x**2))))
    
    
    
    #replicate(max_iter,  { 
    for(i in 1:max_iter) {
        for(r in nrow(dataset)) {
            net <- w[1]*dataset[r,1] + w[2]*dataset[r,2] + w[3]
            out[r] <- -1 * activation(net, k)
        
            error <- d[r] - out[r]
            learn <- alpha * error
            
            w[1] <- w[1] + learn * dataset[r,1]
            w[2] <- w[2] + learn * dataset[r,2]
            w[3] <- w[3] + learn * R**2
                   

        }
        
        
        
        
        print_stuff(error, w)
    }
    
    return(w)
}

# perceptron(train_set, 0.5, k=5, max_iter=5)

# Activation Function
# Input: arbitrary numerical x and activation constant k
#        note: ommiting k implies "hard activation"
# Output: real value [-1,1]
activation <- function(x, k) {
    y <- 1 / (1 + exp(-k*x))
    return(y)
}

# Print Stuff
print_stuff <- function( error, w) {
    cat("error: ", error, "\tweights: ", w,"\n" )
    cat("y = ", -w[1]/w[2], "x + ", w[3], "\n")
}

# Plot Stuff
###############################################################################
plot_stuff <- function (dataset, weights){

    plot(hws$height[hws$sex == 1], hws$weight[hws$sex == 1], 
        col='blue', pch=3,
        xlab='Height (cm)', ylab='Weight (kg)',
      #  xlim=range(hws$height),
      #  ylim=range(hws$weight)
          xlim = c(0,200),
          ylim = c(0,500)
    )
    points(hws$height[hws$sex == -1], hws$weight[hws$sex == -1], 
        col='red', pch=3)
    
    title('Male and Female Height vs Weight')
    
    abline(weights[3], -weights[1]/weights[2], col = 'forestgreen', lwd = 3)

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

hard_weights <- perceptron(train_set, ALPHA)

soft_weights <- perceptron(train_set, ALPHA, K)







