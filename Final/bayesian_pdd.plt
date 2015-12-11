set terminal unknown
PI = atan(1)

set title "Bayesian Probability Density Distributions"
set xlabel "X_1"
set ylabel "P(X | C) Density"
mean_1 = -1.87261142857143
var_1 = 0.0340754587265306
stdev_1 = 0.18459539194284
f_1(x) = (1/(stdev_1 * sqrt(2*PI))) * exp(-(x-mean_1)**2 / (2*var_1))

mean_2 = 0.472750888888889
var_2 = 0.0684837490631543
stdev_2 = 0.261693998905505
f_2(x) = (1/(stdev_2 * sqrt(2*PI))) * exp(-(x-mean_2)**2 / (2*var_2))

mean_3 = 1.46419170731707
var_3 = 0.0740618959214753
stdev_3 = 0.272143153361379
f_3(x) = (1/(stdev_3 * sqrt(2*PI))) * exp(-(x-mean_3)**2 / (2*var_3))

plot "pdd_1.txt", f_1(x)
replot "pdd_2.txt", f_2(x)
replot "pdd_3.txt", f_3(x)

set terminal png
set output "bayesian_pdd.png"
replot