#Author: Babul Pradhan
#Date: 09/18/2025
#Purpose: Merges per sample Arriba generated fusion calls (from arriba_normal.sh and arriba_tumor.sh) into tumor and normal level tables with Sample IDs

#!/usr/bin/perl

@sampletypes=("normal", "tumor");
for($n=0;$n<@sampletypes;$n++){
$type=@sampletypes[$n];
#### Input file containing sample IDs
$samples_file = "/home/user/DATA_02/Babul_August_3TB/scripts/Arriba/samples_$type.txt";

#### Output file for merged fusion predictions
$merged_file = "/home/user/DATA_02/Babul_August_3TB/Arriba/arriba.merged_fusions.$type.tsv";

print "Sample Type: $type\nSample File: $samples_file\nMerged File: $merged_file\n";
#### Read sample list
open (SAMPLES, $samples_file) or die "Cannot open sample list '$samples_file': $!\n";
@samples = <SAMPLES>;
close SAMPLES;

#### Clear the output file before starting
unless (open (OUTFILE, ">$merged_file")) {
    print "Cannot open '$merged_file' to initialize !!!\n\n";
    exit;
}
close OUTFILE;

#### Header flag
$header_written = 0;

#### Fusion counter
$total_fusions = 0;

#### Loop through each sample
for ($i = 0; $i < @samples; $i++) {
    $sample = $samples[$i];
    chomp($sample);
    next if $sample =~ /^\s*$/;  # Skip empty lines
    print "Processing File: $sample\n";

    #### Construct input file path
    $input_file = "/home/user/DATA_02/Babul_August_3TB/Arriba/$type/$sample/fusions.tsv";

    #### Open input file
    unless (open (INFILE, $input_file)) {
        print "Could not open '$input_file': $!\n";
        next;
    }

    #### Read lines
    @filein = <INFILE>;
    close INFILE;

    #### Extract header
    $header = $filein[0];
    chomp($header);
    #next if @filein < 2;  # Skip if no data lines

    #### Write header once
    if ($header_written == 0) {
        unless (open (OUTFILE, ">$merged_file")) {
            print "Cannot open '$merged_file' to write to !!!\n\n";
            exit;
        }
        print OUTFILE "SampleID\t$header\n";
        close OUTFILE;
        $header_written = 1;
    }

    #### Append data lines with sample ID
    unless (open (OUTFILE, ">>$merged_file")) {
        print "Cannot open '$merged_file' to append to !!!\n\n";
        exit;
    }

    for ($j = 1; $j < @filein; $j++) {
        $line = $filein[$j];
        chomp($line);
        print OUTFILE "$sample\t$line\n";
        $total_fusions++;
    }

    close OUTFILE;
}

print "The merged fusion predictions for $type samples are saved in '$merged_file'\n";
print "Total fusions merged for '$type': $total_fusions\n\n";
}

