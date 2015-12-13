# herbertkb_ex2.1.r
# Keith Herbert
# Final Exam, Ex 2.1
# Kohonen Winner-Take-All Self Organizing Map

###############################################################################
# Set up parameters
###############################################################################
args <- commandArgs(trailingOnly=TRUE)

input_file <- if (length(args) >= 1) args[1] else "Ex2_Data/Ex1_data.txt"
print(paste("Pattern file:", input_file))

.η0 <- if (length(args) > 1) args[2] else 0.1
print(paste("initial learning constant:", .η0 ))

.σ0 <- if (length(args) > 2) args[3] else 1.0
print(paste("initial neighborhood range:", .σ0 ))

count.neurons <- if (length(args) > 3) args[4] else 2
print(paste("How many neurons:", count.neurons))

max.iteration <- if (length(args) > 4) args[5] else 1000
print(paste("How many iterations:", max.iteration))


###############################################################################
# Custom Functions
###############################################################################
feature.scale <- function(x) {
    min <- min(x)
    max <- max(x)
   
    return( (x - min)/(max-min) )
}

train.neurons <- function(pattern, neurons, iteration, max.iteration) {
    # first find the best matching unit(neuron)
    bmu <- which.min( dist( rbind(pattern, neurons) ) )
    
    
    
    # update weights of all neurons
    neurons <- apply(neurons, 1, function(neuron) 
                    neuron + learn.rate(iteration, .η0) + 
                    neighborhood(neuron, bmu, .σ0, curr.iteration, 
max.iteration) * 
                    (pattern - neuron) )
                   
}

learn.rate <- function (initial, curr.iteration, max.iteration) {
    return(initial * exp(-curr.iteration / max.iteration))
}

neighborhood <- function (neuron, bmu, initial, curr.iteration, max.iteration) {
    
    return( exp(-dist(rbind(neuron, neurons[bmu,])) / 
                (2*neighbor.rate(.σ0, curr.iteration, max.iteration)^2)    )  )
    
    
}
neighbor.rate <- function(initial, curr.iteration, max.iteration) {
    return(initial * exp(-curr.iteration / max.iteration))
}



###############################################################################
# Main Program
###############################################################################
patterns <- read.csv(input_file)

print("Feature scaling the patterns")
patterns <- cbind( feature.scale(patterns$x1), feature.scale(patterns$x2)  )
colnames(patterns) <- c("x1", "x2")

print(paste("Initialing", count.neurons, "neurons"))
neurons <- matrix( runif(2 * count.neuron), ncol=count.neuron )


for(i in max.iteration ) {
    neurons <- apply(patterns, 1, function(pattern) 
                    train.neurons(pattern, neurons, i))
}












print("Writing Rplots.pdf")
plot(patterns)






