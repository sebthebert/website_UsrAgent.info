=head1 NAME

UsrAgent::Browser

=cut

package UsrAgent::Browser;

use strict;
use warnings;

my $DIR_LOGO_BROWSER = "/img/logos/browser/";

my %data = (
	Chrome => 
		{ 
		color => 'yellow',
		website => 'https://www.google.com/chrome'
		},
	Firefox => 
		{ 
		color => 'orange', 
		website => 'https://www.mozilla.org/firefox/' 
		},
	'Internet Explorer' => 
		{ 
		color => 'blue', 
		website => 'http://windows.microsoft.com/en-US/internet-explorer/download-ie'
		},
	Opera => 
		{ 
		color => 'red', 
		website => 'http://www.opera.com/'
		},
	Safari => 
		{ 
		color => 'blue',
		website => 'http://www.apple.com/safari/'
		},
	);

=head1 FUNCTIONS

=head2 Data($browser)

=cut

sub Data
{
	my $browser = shift;

	return ($data{$browser})	if (defined $browser);

	return (undef);
}

=head2 Logo($browser, $size)

=cut

sub Logo
{
    my ($browser, $size) = @_;

	if (defined $browser)
	{
		$browser =~ s/ /_/g;
    	my $logo = $DIR_LOGO_BROWSER . lc $browser;
    	$logo .= "-${size}.png";

    	return ($logo);
	}

	return (undef);
}

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
