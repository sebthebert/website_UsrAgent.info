=head1 NAME

UsrAgent::Parser

=cut

package UsrAgent::Parser;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib/";

use UsrAgent::Device;

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
			$info{browser} ||= 'N/A';
			$info{browser} =~ s/MSIE/Internet Explorer/;
			$info{browser_version} ||= 'N/A';
			$info{browser_version} =~ s/_/./g;
            $info{os} ||= 'N/A';
			$info{os_version} ||= 'N/A';
			$info{os_version} =~ s/_/./g;
			
			$info{os} = ($info{os} =~ /^(hpw|web)OS$/ 
                ? 'WebOS' : $info{os});
			$info{os} = ($info{os} =~ /^Symb(OS|ian|ianOS)$/ 
				? 'Symbian' : $info{os});
			$info{useragent} = $ua;

			$info{os_version} = UsrAgent::OS::Version_name($info{os}, $info{os_version});
			UsrAgent::Device::Company(\%info);
			UsrAgent::Device::Type(\%info);

            return (%info);
        }
    }
	
	return ();
}

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
