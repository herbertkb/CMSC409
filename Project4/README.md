# README: Project 4

## Process

Processing the document corpus begins with `featurevec.pl`. It is assumed that 
each document consists of ASCII text and is separated by newlines.In our test 
corpus, each document is an English sentence. The goal of this program is to 
extract just those words which give the most information about each document.
 
`featurevec.pl` begins by tokenizing the input documents as features separated 
by one or more blank spaces. This simplifies the language model by letting us 
focus on just characteristic words for each document but loses any information 
about how words relate to each other such as ngrams. It then removes punctuation 
and special characters. In context, these characters but give useful 
information about their surrounding words (such as part of speech or word 
sense disambiguation) but are useless as individual tokens. Likewise with 
numbers and the original cases of letters. `featurevec.pl` converts everything 
to lowercase. Stop words such as articles, contractions, prepositions, 
pronouns, and others are removed because they are uninteresting from an 
information standpoint due to their ubiquity and lack of context. Finally, the 
`featurevec.pl` program uses Porter stemming on the remaining words to remove 
conjugations and reduce various forms of a word to its stem.

The Porter stemming algorithm is implemented in a module taken from: 
http://ldc.usb.ve/~vdaniel/porter.pm

The feature vector is the set of words which most characterizes a document and 
is printed to STDOUT one vector per line. These lines can be piped into 
`tdm.pl` to generate a term document matrix for the corpus. 

## Feature Vector

    % perl featurevec.pl stop_words.txt sentences.txt
    autonom sedan travel type road speed up mile per hour 
    get car mile per hour kilomet per hour  seconds 
    road test  achiev rang kilomet  around miles  charge 
    car go kilomet miles  charge  up percent before 
    autonom sedan lap around kilomet per hour mile per hour

## Term Document Matrix

    % perl featurevec.pl stop_words.txt sentences.txt sentences_tdm.txt \
    | perl tdm.pl
                         1     2     3     4     5     6     7     8     9    10
            accident                                         1                  
              achiev                 1                                          
              around                 1           1                             1
             autonom     1                       1     1     1     1            
              averag                                                     1     1
              before                       1                                    
                 car           1           1           1           1           1
              charge                 1     1                                    
             complet                                         1                  
                deal                                               1            
               drive                                         1                  
              driven                                   1                        
             driving                                                     1      
                free                                         1                  
              gallon                                                     1      
                 get           1                                                
                  go                       1                                    
                hour     1     2                 2                             1
             kilomet           1     1     1     1     1                        
          kilometers                                         1                  
                 lap                             1                             1
               limit                                   1                        
                mile     1     1                 1           1           2     2
               miles                 1     1                                    
               minut                                                           1
              number                                               1            
                over                                         1           1      
                 per     1     2                 2                       1     1
             percent                       1                                    
               pound                                                     1      
              public                                   1                        
                rang                 1                                          
                road     1           1                 1           1           1
               round                                                           1
             seconds           1                                               1
               sedan     1                       1                       1      
              situat                                               1            
               speed     1                                                      
                test                 1                 1                        
              travel     1                                                      
                type     1                                                      
                  up     1                 1                                    
                  us                                   1                        
                went                                                           1
