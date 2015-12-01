#!/usr/bin/perl
# featurevec.pl
# Generates a feature vector from a line of input.
# Keith Herbert, 30 Nov 2015

use strict;
use warnings; 
use feature qw(say);

# Module for Porter Stemmer
use porter;         # porter.pm must be in same directory!

my $USAGE = "Usage: perl featurevec.pl <stop words file> <input file(s)>";
die $USAGE unless ($#ARGV >= 1);

# Load the stopwords from file ################################################
my $stop_filename = shift;
local $/ = "\r\n";          # fix for only readling last line of file
open my $stop_filehandle, '<', $stop_filename or 
        die "Could not open stoplist file $stop_filename";
chomp(my @stop_words = <$stop_filehandle> );
close $stop_filehandle;       

##############################################################################
while(<>){
    chomp;
    
    # A. Tokenize sentence
    my @tokens = split;
    
    # B & C. Remove punctuation and special characters and remove numbers
    map { s/[^A-Za-z]/ /g; } @tokens;
    
    # D. Convert uppercase to lowercase
    map { $_ = lc; } @tokens;
    
    # E. Remove stop words
    for my $token (@tokens) {
        for my $stop (@stop_words) {
            $token =~ s/\b$stop\b//g;
        }
    }
    
    # F. Apply stemming
    @tokens = map { porter $_; } @tokens;
    
    # Remove empty tokens. 
    @tokens = grep { $_ =~ /\S/; } @tokens;
    
    # Print feature vector to STDOUT.
    say "@tokens";
}