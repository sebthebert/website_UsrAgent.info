=head1 NAME

UsrAgent::Parser

=cut

package UsrAgent::Parser;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib/";

my $FILE_REGEXPS = "$FindBin::Bin/../data/regexps.conf";

my @regexps = ();

=head1 FUNCTION

=head2 Init()

=cut

sub Init
{
	if (open my $file, '<', $FILE_REGEXPS)
	{
    	while (my $line = <$file>)
    	{
        	chomp $line;
        	push @regexps, qr/$line/    if (($line !~ /^#/) && ($line !~ /^$/));
    	}
    	close $file;
	}

	return (scalar(@regexps));
}

=head2 Info($ua)

=cut

sub Info
{
	my $ua = shift;
	my %info = ();

	Init()	if (! scalar @regexps);
	foreach my $re (@regexps)
    {
        if ($ua =~ $re)
        {
			%info = %+;
			$info{useragent} = $ua;
            return (%info);
        }
    }
	
	return (undef);
}

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
