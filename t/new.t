#!/usr/bin/perl

use strict;
use warnings;

my $FILE_REGEXPS = 'data/regexps.conf';

my @regexps = ();

open my $file, '<', $FILE_REGEXPS;
while (my $line = <$file>)
{
	chomp $line;
	push @regexps, qr/$line/	if (($line !~ /^#/) && ($line !~ /^$/));
}
close $file;
printf "%d regexps loaded !\n", scalar(@regexps);

my $count_match = 0;
open my $file_data, '<', 'data/user_agents.txt';
while (my $ua = <$file_data>)
{
	chomp $ua;
	my $matched = 0;
	foreach my $re (@regexps)
	{
		if ($ua =~ $re)
		{
#			printf "Match:\n\tOS: %s %s\n\tBrowser: %s %s\n", 
#				$+{os}, $+{os_version},
#				$+{browser}, $+{browser_version};
			$count_match++;
			$matched = 1;
			next;
		}
	}
	printf "$ua\n"	if (!$matched);
}
close $file_data;

printf "Matched: %d\n", $count_match;
