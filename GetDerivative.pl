#!/usr/bin/perl -w
use strict;

sub to_fasta {
        my ($seqName, $seq, $len) = @_;

	# default to 80 characters of sequence per line
        $len = 80 unless $len;

        my $formatted_seq = ">$seqName\n";
        while (my $chunk = substr($seq, 0, $len, "")) {
                $formatted_seq .= "$chunk\n";
        }

        return $formatted_seq;
}

my $chr20;
my $chr22;
my $chr20der;
my $chr22der;

open(F, "<chr20_22.fa") or die "Can't open $ARGV[0]\n";
open (FW, ">chr20_22.txt") or die "Unable to open file for writing\n";

while($_ = <F>)
{
	if($_ =~ m/>(\S+)/)
	{
		print FW "\n$1\t";
	}
	
	if($_=~ m/^([A-Z]+)/i){print FW "$1";}
	
}
close(F);
open(F, "<chr20_22.txt") or die "Can't open $ARGV[0]\n";
open (FW, ">chr20_derivative.fa") or die "Unable to open file for writing\n";
open (FR, ">chr22_derivative.fa") or die "Unable to open file for writing\n";
while (<F>)
{
	chomp($_);
	my @temp_data = split (/\t/,$_);
	foreach my $temp_data (@temp_data)
	{
	if($temp_data[0] =~ m/20/)
	 {
	 $chr20  = substr $temp_data[1], 1, 59969993; 
	 $chr20der = substr $temp_data[1], 59970004, 63025520;
	 }
	if($temp_data[0] =~ m/22/)
	 {
	 $chr22  = substr $temp_data[1], 1, 21433934; 
	 $chr22der = substr $temp_data[1], 21433936, 51304566;
	 }
	 }
}

my $chr20derivative_1 = $chr20.$chr22der;
my $chr22derivative_1 = $chr22.$chr20der;

	 print FW to_fasta(">chr20der", $chr20derivative_1, 100);
	 print FR to_fasta(">chr22der", $chr22derivative_1, 100);
	 close FW;
	 close FR;
close F;

