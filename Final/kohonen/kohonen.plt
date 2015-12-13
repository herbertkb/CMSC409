pattern_file = "normalized_patterns.txt"
neuron_file =  "neurons.txt"
plot_file = "kohonen_7_neurons.png"


set term png size 600,600 
set output plot_file

set title "Winner Take All Kohonen Network"

plot pattern_file using 1:2 lt rgb "red", \
    neuron_file using 1:2 ps 4 pt 7 lt rgb "blue"


