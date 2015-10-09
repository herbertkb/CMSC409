# Project 1
# Keith Herbert


# Generate data for heights and weights of 2000 males and 2000 females
###############################################################################
# Mean and standard deviation for male and female heights are from:
#   http://biology.stackexchange.com/questions/9730/what-is-the-standard-deviation-of-adult-human-heights-within-sexes 
male.height <- rnorm( 2000, mean=176.3, sd=7)
female.height <- rnorm( 2000, mean=163.7, sd=6)

# Weights calculated by reversing from height and normally distributed BMI
# Weight = (Height / 100)^2 * BMI
# Mean and standard deviation for male and female BMI are from:
#   http://www.ncbi.nlm.nih.gov/pubmed/23675464
male.weight <- (male.height/100)^2 * rnorm( 2000, mean=26.6, sd=3.31)
female.weight <- (female.height/100)^2 * rnorm( 2000, mean=24.0, sd=4.18)


# Build a dataframe to make statistical tests later easier
sex     <- c(rep('m', 2000), rep('f', 2000))
height  <- c(male.height, female.height)
weight  <- c(male.weight, female.weight)
population <- data.frame(sex, height, weight)

# Write the heights and weights to a CSV file

###############################################################################
# A. Heights only

# Plot the male and female heights
pdf(file='heights.pdf')
plot( male.height,
    ylim = range(male.height, female.height),
    col = 'blue',
    ylab = 'Height (cm)' )
title('Male and Female Height')
points( female.height, col = 'red' )
# Draw the legend
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


# Plot the linear separator/decision function
# Equation for decision function: height = 168
# Weights: height = 1, bias = -168
h.bias <- -168 
abline( h = -1*h.bias, col = 'forestgreen', lwd = 3)        
        
        
# save plot to file
# dev.print(png, 'heights.png')
dev.off()

###### Statistics for Heights Only (h)
# True positive
h.tpos <- population[with(population, sex == 'm' & height + h.bias >= 0), ]
h.tpos.r <- nrow(h.tpos) / nrow(population)

# True Negative
h.tneg <- population[with(population, sex == 'f' & height + h.bias < 0), ]
h.tneg.r <- nrow(h.tneg) / nrow(population)

# False positive
h.fpos <- population[with(population, sex == 'f' & height + h.bias >= 0), ] 
h.fpos.r <- nrow(h.fpos) / nrow(population)

# False negative
h.fneg <- population[with(population, sex == 'm' & height + h.bias < 0), ]
h.fneg.r <- nrow(h.fneg) / nrow(population) 

# Accuracy = (True Positive + True Negative) / Population Size
h.acc <- (nrow(h.tpos) + nrow(h.tneg)) / nrow(population) 

# Error
h.err <- 1 - h.acc


    
###############################################################################    
# B. Heights and Weights

# Plot the male and female heights and weights
pdf(file='heightsweights.pdf')
plot(male.height, male.weight, 
    col='blue', 
    xlab='Height (cm)', ylab='Weight (kg)',
    xlim=range(male.height, female.height),
    ylim=range(male.weight, female.weight)
)
points(female.height, female.weight, col='red')
title('Male and Female Height vs Weight')

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




# Plot the linear separator/decision function
abline(330, -1.55, col = 'forestgreen', lwd = 3)

# Save plot to file
# dev.print(png, 'heightsweights.png')
dev.off()

# Equation for decision function:   y = -1.55x + 330
#                                   weight = -1.55*height + 330
# Weights:  ax + by + c = 0
#          -1.55x - y + 330 = 0
#           1.55x + y - 330 = 0
#           1.55(height) + weight - 330 = 0

###### Statistics for Heights and Weights (hw)
# Descision function
hw.df <- function (height, weight) {
            return (1.55*height + weight - 330)
            }

# True Positive & Ratio
hw.tpos <- population[with(population, sex == 'm' & hw.df(height, weight) >= 0),]
hw.tpos.r <- nrow(hw.tpos) / nrow(population)


# True Negative & Ratio
hw.tneg <- population[with(population, sex == 'f' & hw.df(height, weight) < 0),]
hw.tneg.r <- nrow(hw.tneg) / nrow(population)

# False Positive & Ratio
hw.fpos <- population[with(population, sex == 'f' & hw.df(height, weight) >= 0),]
hw.fpos.r <- nrow(hw.fpos) / nrow(population)


# False Negative & Ratio
hw.fneg <- population[with(population, sex == 'm' & hw.df(height, weight) < 0),] 
hw.fneg.r <- nrow(hw.fneg) / nrow(population)

# Accuracy = True positive ratio + True negative ratio
hw.acc <- hw.tpos.r + hw.tneg.r 

# Error = False negative ratio + False positive ratio = 1 - Accuracy
hw.err <- 1 - hw.acc

###############################################################################

# Print results as a table

stats <- matrix(
            c(  h.err,      hw.err,
                h.acc,      hw.acc, 
                h.tpos.r,   hw.tpos.r,
                h.tneg.r,   hw.tneg.r,
                h.fpos.r,   hw.fpos.r,
                h.fneg.r,   hw.fneg.r   ), 
            ncol=2, byrow=TRUE)

colnames(stats) <- c('Height', 'Height & Weight')
rownames(stats) <- c('Error', 'Accuracy', 
                     'True Positive', 'True Negative',
                     'False Positive', 'False Negative')
                     
stats <- as.table(stats)
stats
