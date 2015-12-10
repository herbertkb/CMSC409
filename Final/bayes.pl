#!/usr/bin/perl env
#
# bayes.pl
# Keith Herbert
#
# Trains and tests a Bayes classifier for a labeled one dimensional data set.
#
################################################################################
use warnings;
use strict;
use Data::Dumper;

my $training_file = shift;
my $testing_file = shift;

open my $TRAIN, '<', $training_file or die "Could not open training file";

# Parse the training file to build a map of each class to its patterns
my (%class_x, $N);
while(<$TRAIN>){
    # skip any line that doesn't start with a number or minus sign
    next unless (/^[\d\-]/);        
    
    my($x, $class) = split ',';
    push @{$class_x{$class}}, $x;
    
    $N += 1; 
}


my %class_freq;
for my $class (keys %class_x) {
    $class_freq{$class} = scalar @{$class_x{$class}};;
}



my %class_prob;
for my $class (keys %class_freq) {
    $class_prob{ $class } = $class_freq{$class} / $N;
}

my %class_sum;
for my $class (keys %class_x) {
    my @patterns = @{$class_x{$class}};   
    my $sum = 0;
    $sum += $_ for @patterns;
    $class_sum{$class} = $sum; 
}

print Dumper(\%class_sum);

my %class_mu;
my %class_variance;
