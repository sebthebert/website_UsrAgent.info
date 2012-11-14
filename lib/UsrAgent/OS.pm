=head1 NAME

UsrAgent::OS

=cut

package UsrAgent::OS;

use strict;
use warnings;

my $DIR_LOGO_OS = "/img/logos/os/";

my %data = (
	Android => { color => 'green' },
	Debian => {color => 'pink' },
	Fedora => { color => '' },
	Linux => { color => 'darkgray' },
	'Mac OS X' => { color => 'gray' },
	'Open Suse' => { color => 'green' },
	'Red Hat' => { color => 'red' },
	Ubuntu => { color => 'orange' },
	Windows => { color => 'blue' },
	);

=head1 FUNCTIONS

=head2 Data($os)

=cut

sub Data
{
	my $os = shift;

	return ($data{$os});
}

=head2 Logo($os, $size)

=cut

sub Logo
{
	my ($os, $size) = @_;

	my $logo = $DIR_LOGO_OS . ($os eq 'Mac OS X' ? 'mac_os_x' : lc $os);
	$logo .= "-${size}.png";

	return ($logo);
}

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
