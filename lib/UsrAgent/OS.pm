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

my %os_version = (
	Windows => { 
		'NT 5.0' => '2000',
		'NT 5.1' => 'XP',
		'NT 5.2' => 'Server 2003',
		'NT 6.0' => 'Vista',
		'NT 6.1' => '7',
		'NT 6.2' => '8',
		}
	);

=head1 FUNCTIONS

=head2 Data($os)

=cut

sub Data
{
	my $os = shift;

	return ($data{$os})	if (defined $os);

	return (undef);
}

=head2 Logo($os, $size)

=cut

sub Logo
{
	my ($os, $size) = @_;

	if (defined $os)
	{
		my $logo = $DIR_LOGO_OS . ($os eq 'Mac OS X' ? 'mac_os_x' : lc $os);
		$logo .= "-${size}.png";

		return ($logo);
	}

	return (undef);
}

=head2 Version_name($os, $os_version)

=cut

sub Version_name
{
	my ($os, $os_version) = @_;
	
	return ($os_version{$os}{$os_version} || $os_version);	
}

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
