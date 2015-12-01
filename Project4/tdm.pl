#!/usr/bin/perl
# tdm.pl
# Generates a Term Document Matrix from feature vectors, one doc per line.
# Keith Herbert, 30 Nov 2015

use strict;
use warnings; 
use feature qw(say);
use Data::Dumper;

# Read feature vectors #######################################################
# This is likely a sparse matrix, so I'm using a hash of hashes. The outer key
# is the term, the inner key is the index for the document and the final value
# is the frequency for that term in that document.
my %tdm;
my $doc_index;
while(<>) {
    $doc_index++;
    
    my @terms = split;
    
    my %term_freq;
    $term_freq{$_} += 1 for @terms;
  
    while(my($term, $freq) = each %term_freq) {
        $tdm{$term}{$doc_index} = $freq
    }
}

#print Dumper(\%tdm);


# Print the Term Document Matrix #############################################

# Print header
print ' 'x20;
for my $i (1..$doc_index){
    print sprintf "%6d", $i;
}
print "\n";

# Print each row
for my $term (sort keys %tdm){

# Start with printing the term for that row
    print sprintf "%20s", $term;
    

# Then iterate through each document column
    for my $i (1..$doc_index){
    
# Print the frequency if the term occurs in that document
        if (exists $tdm{$term}{$i}) {
            my $freq = $tdm{$term}{$i};
            print sprintf "%6d", $freq; 
        }
# Otherwise, print blank spaces
        else {
            print ' 'x6;
        }
    }

# Next row.
    print "\n";
}
