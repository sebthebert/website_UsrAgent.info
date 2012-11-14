#!/usr/bin/perl

use strict;
use warnings;
use Readonly;

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib/";

use UsrAgent::Parser::OS;

Readonly my $FILE_USER_AGENTS => "$FindBin::Bin/../data/user_agents.txt";

if (open my $fh, '<', $FILE_USER_AGENTS)
{
	my @darwin_strings = ();
	while (<$fh>)
	{
		my $str = $_;
		chomp $str;
		push @darwin_strings, $str	if ($str =~ /darwin/i);
	}
	plan tests => scalar (@darwin_strings);

	foreach my $ds (@darwin_strings)
	{
		my $str = undef;
		$str = UsrAgent::Parser::OS::Darwin_to_OSX_Version($ds);
		like($str, qr/^\d+\.\d+/, "$ds -> Mac OS X $str");
	}
}
