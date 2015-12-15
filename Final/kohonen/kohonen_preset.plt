pattern_file = "../data/Ex1_data.txt"
neuron_file =  "neuron_preset.csv"
plot_file = "neurons_7_preset_raw.png"

print "Plotting to ", plot_file
set datafile separator ","
set term png size 600,600 
set output plot_file

set title "Winner Take All Kohonen Network"

plot pattern_file using 1:2 lt rgb "red", \
    neuron_file using 1:2 ps 4 pt 7 lt rgb "blue"


