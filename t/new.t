#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib/";

use UsrAgent::Parser;

my %stats = ();

open my $file_data, '<', 'data/user_agents.txt';
while (my $ua = <$file_data>)
{
	chomp $ua;
	my %info = UsrAgent::Parser::Info($ua);
			
	$stats{os}{$info{os}} = $stats{os}{$info{os}} + 1;
	$stats{browser}{$info{browser}} = $stats{browser}{$info{browser}} + 1;
	
	printf "$ua\n"	if (! %info);
}
close $file_data;


foreach my $os (sort keys $stats{os})
{
	printf "%s: %d\n", $os, $stats{os}{$os};
}
foreach my $b (sort keys $stats{browser})
{
    printf "%s: %d\n", $b, $stats{browser}{$b};
}
