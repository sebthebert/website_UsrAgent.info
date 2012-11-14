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
	'Internet Explorer' => { color => 'blue' },
	Opera => { color => 'red' },
	Safari => { color => 'blue' },
	);

=head1 FUNCTIONS

=head2 Data($browser)

=cut

sub Data
{
	my $browser = shift;

	return ($data{$browser});
}

=head2 Logo($browser, $size)

=cut

sub Logo
{
    my ($browser, $size) = @_;

    my $logo = $DIR_LOGO_BROWSER 
		. ($browser =~ /MSIE/i ? 'internet_explorer' : lc $browser);
    $logo .= "-${size}.png";

    return ($logo);
}

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
