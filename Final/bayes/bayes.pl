#!/usr/bin/perl
#
# bayes.pl
# Keith Herbert
#
# Trains and tests a Bayes classifier for a labeled one dimensional data set.
#
################################################################################
use warnings;
use strict;

use constant PI => 4 * atan2(1, 1);

use Data::Dumper;

my $training_file = shift;
my $testing_file = shift;

# Parse the training file to build a map of each class to its patterns
print "Reading $training_file to train Bayesian Classifier.\n";
open my $TRAIN, '<', $training_file or die "Could not open training file";
my (%class_x, $N);
while(<$TRAIN>){
    chomp; 
    # skip any line that doesn't start with a number or minus sign
    next unless (/^[\d\-]/);        
    
    my($x, $class) = split ',';
    push @{$class_x{$class}}, $x;
    
    $N += 1; 
}
close $TRAIN;

my %class_freq;
for my $class (keys %class_x) {
    $class_freq{$class} = scalar @{$class_x{$class}};;
}
#print Dumper(\%class_freq);

my %class_prob;
for my $class (keys %class_freq) {
    $class_prob{ $class } = $class_freq{$class} / $N;
}
#print Dumper(\%class_prob);

my %class_mu;
for my $class (keys %class_x) {
    my @patterns = @{$class_x{$class}};   
    my $sum = 0;
    $sum += $_ for @patterns;
    $class_mu{$class} = $sum / scalar @patterns; 
}
#print Dumper(\%class_mu);

my %class_variance;
for my $class (keys %class_x){
    my @patterns = @{$class_x{$class}};   
    
    my @differences;
    push @differences, ($_ - $class_mu{$class}) for (@patterns);
    
    my @squares;
    push @squares, $_ ** 2 for @differences;

    my $sum = 0;
    $sum += $_ for (@squares);

    $class_variance{$class} = $sum / $class_freq{$class};
}

#print Dumper(\%class_variance);

my %class_stddev;
for my $class (keys %class_variance) {
    $class_stddev{$class} = sqrt $class_variance{$class};
}
#print Dumper(\%class_stddev);


# Normalize X values by standard score: (x - mean) / stddev
my %class_xnorm;
for my $c (keys %class_x) {
    
    my @x_normed;
    for my $x (@{ $class_x{$c} }) {
        push @x_normed, ( $x - $class_mu{$c} ) / $class_stddev{$c};
    }

    $class_xnorm{$c} = \@x_normed;
}
#print Dumper(\%class_xnorm);


my $classifier = sub {
    my $x = shift;
    
    my $likelihood = 0;
    my $max_likelihood = 0;
    my $most_likely = "";
    for my $c (keys %class_prob) {
        
        $likelihood = P_of_X_given_C($x, $c) * $class_prob{$c};
       
        print "$x\t$c\t$likelihood\n";

        if ($likelihood > $max_likelihood) {
            $most_likely = $c;
            $max_likelihood = $likelihood;
        }
    }
   
    print "$x => $most_likely\n";

    return $most_likely;
};

my %class_Px;
for my $c (keys %class_x) {
    my @Px = map { P_of_X_given_C($_, $c) } @{ $class_x{$c} };
    $class_Px{$c} = \@Px;
}
#print Dumper(\%class_Px);

my %class_Px_scaled;
for my $c (keys %class_Px) {
    
    my @set = @{ $class_Px{$c} };
   
    my ($max, $min) = (-999, 999);
    for (@set) {
        if ($_ > $max) { $max = $_; next; }
        if ($_ < $min) { $min = $_;       }
    }

    for my $x (@set) {
        $x = ($x-$min) / ($max - $min);
    }

    $class_Px_scaled{$c} = \@set;
}
#print Dumper(\%class_Px_scaled);


for my $class (sort keys %class_x) {
    my $pdd_file = "pdd_$class.txt";

    print "\tFreq of $class: $class_freq{$class}\n";
    print "\tMean of $class: $class_mu{$class}\n";
    print "\tVariance of $class: $class_variance{$class}\n";
    print "\tStandard deviation of $class: $class_stddev{$class}\n";
    print "Writing Gausian probability density distribution of "
            ."class $class to $pdd_file\n";
    open my $PDD, '>', $pdd_file or die "Could not write to $pdd_file";
    
#    my @x_values = @{ $class_x{$class} };
#    my @x_probs_scaled = @{ $class_Px_scaled{$class} };
#
#    for my $i (0 .. $#x_values) {
#        print $PDD "$x_values[$i]\t$x_probs_scaled[$i]\n";
#    }


    for my $x (sort @{ $class_x{$class} }){
        my $P_x = P_of_X_given_C($x, $class);
        print $PDD "$x\t$P_x\n";
    }

    #close $PPD;  #weird error. won't let me close the filehandle.
}

# Generate a GNUPlot script for the Probability Density Distributions
my $gnuplot_file = "bayesian_pdd.plt";
print "Generating gnuplot script $gnuplot_file\n";
open my $PLT, '>', $gnuplot_file or die "Could not create .plt gnuplot script";

print $PLT "set terminal unknown\n"
            ."PI = atan(1)\n"
            ."\n"
            ."set title \"Bayesian Probability Density Distributions\"\n"
#            ."unset key\n"
            ."set xlabel \"X_1\"\n"
            ."set ylabel \"P(X | C) Density\"\n";
my @classes = sort keys %class_x;
for my $c (@classes) {
    print $PLT  
        "mean_$c = $class_mu{$c}\n".
        "var_$c = $class_variance{$c}\n".
        "stdev_$c = $class_stddev{$c}\n".
        "f_$c(x) = (1/(stdev_$c * sqrt(2*PI))) *".
                    " exp(-(x-mean_$c)**2 / (2*var_$c))\n".
        "\n";
}
my $first_c = shift @classes;
print $PLT "plot \"pdd_$first_c.txt\", f_$first_c(x)\n";
for my $c (@classes) {
    print $PLT "replot \"pdd_$c.txt\", f_$c(x)\n";       
}
print $PLT  "\n".
            "set terminal png\n".
            "set output \"bayesian_pdd.png\"\n".
#           "set size 600 800\n".
            "replot";
close $PLT;


print "Reading $testing_file to evaluate classifier.\n"; 
open my $TEST, '<', $testing_file or die "Could not open testing file";
my %confusion;
while(<$TEST>){
    chomp;
    # skip any line that doesn't start with a number or minus sign
    next unless (/^[\d\-]/);        
    
    my($x, $class_obs) = split ',';
    
    my $class_pred = $classifier->($x);
    $confusion{$class_obs}{$class_pred} += 1;    
}
close $TEST;

# print Dumper(\%confusion);

print "Confusion matrix for Bayesian Classifier\n";
print " "x10;
printf "%10s", $_ for (sort keys %confusion);
print "\n";

for my $observed (sort keys %confusion) {
    printf "%10s", $observed;
    for my $predicted (keys %{ $confusion{$observed} } ) {
        printf "%10s", $confusion{$observed}{$predicted};   
    }

    print "\n";
}


sub P_of_X_given_C {
    my $x = shift;
    my $class = shift;

     my $first_part = 1/($class_stddev{$class} * sqrt( 2 * PI ));

     my $sec_part = exp( -($x - $class_mu{$class})**2 
                         / 2*$class_variance{$class} );
     
     my $prob = $first_part * $sec_part;
     
     return $prob;
}
