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

count.neurons <- 2
print(paste("How many neurons:", count.neurons))

###############################################################################
# Custom Functions
###############################################################################
feature.scale <- function(x) {
    min <- min(x)
    max <- max(x)
   
    return( (x - min)/(max-min) )
}

train.neurons <- function(pattern, neurons, iteration) {
    # first find the best matching unit(neuron)
    bmu <- which.min( dist( rbind(pattern, neurons) ) )
    
    
    
    # update weight of all neurons
    neurons <- apply(neurons, 1, function(x) 
                    x + learn.rate(iteration) + 
                    neighborhood(x, bmu, iteration) * (pattern - x))
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


for(i in 1 ) {
    
    apply(patterns, 1, function(x) train.neurons(x, neurons))
    
    
}












print("Writing Rplots.pdf")
plot(patterns)






