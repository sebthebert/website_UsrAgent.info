package UsrAgent::Parser::OS;

use strict;
use warnings;

=head1 FUNCTIONS

=head2 Darwin_to_OSX_Version($ua_string)

Converts Darwin to Mac OSX version

src: http://en.wikipedia.org/wiki/Darwin_(operating_system)

=cut

sub Darwin_to_OSX_Version
{
	my $ua_string = shift;

	my %version = (
		'5' => '10.1',
		'6' => '10.2',
		'7' => '10.3',
		'8' => '10.4',
		'9' => '10.5',
		'10' => '10.6',
		'11' => '10.7',
		'12' => '10.8',
		);
	
	if ($ua_string =~ /Darwin\/(\d+)\.(\d+)\.\d+/)
	{
		return ($version{$1} . ".$2");
	}

	return ($ua_string);
}

=head2 Windows_Version

src: http://en.wikipedia.org/wiki/Windows_NT

=cut

sub Windows_Version
{
	my $ua_string = shift;

	my %version = (
		'5.0' => '2000',
		'5.1' => 'XP',
		'6.0' => 'Vista',
		'6.1' => '7',
		'6.2' => '8',
		);
	#printf "UA STRING: $ua_string\n";
	if ($ua_string =~ /Windows(?: NT|XP)? (\d+\.\d+)/)
    {
        return ($version{$1});
    }

    return ($ua_string);
}

1;
