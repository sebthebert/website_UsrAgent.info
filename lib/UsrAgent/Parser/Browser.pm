package UsrAgent::Parser::Browser;

use strict;
use warnings;
use Readonly;

Readonly my @BROWSERS => qw/
    AtomicBrowser
    BonEcho
    BrowserNG
    Camino
    curl
    Dolfin
    Epiphany
    Firefox
    Iceweasel
	Jasmine
    Java
    K-Meleon
    Konqueror
    MSIE
    NetFront
    Opera
    Safari
    Thunderbird
    Wget
    /;

Readonly my $LIST_BROWSERS => join '|', @BROWSERS;

=head1 FUNCTIONS

=head2 Info

=cut

sub Info
{
    my ($ua, $ua_info) = @_;

    if (($ua =~ m{(?<browser>$LIST_BROWSERS)( |\/)(?<browser_version>\d+(\.\d+\.\d+)?)})
        || ($ua =~ m{(?<browser>AppleWebKit)/(?<browser_version>\d+(\.\d+\.\d+)?)})
    	|| ($ua =~ m{(?<browser>BlackBerry)})
    )
    {
    	$ua_info->{browser} = $+{browser};
    	$ua_info->{browser_version} = $+{browser_version} || '';
    }
}

1;
