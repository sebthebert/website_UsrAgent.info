package UsrAgent::Parser::Robot;

use strict;
use warnings;
use Readonly;

Readonly my @ROBOTS => qw/
    Apple-PubSub
    Baiduspider
    bingbot
    BLP_bbot
    Ezooms
    Feedfetcher-Google
    Googlebot
    Googlebot-Image
    Googlebot-Mobile
    MJ12bot
    msnbot
    msnbot-media
    SkimWordsBot
    Snapbot
    Sogou
    Sosospider
    VoilaBot
	Yahoo!
    YandexBot
    /;

Readonly my $LIST_ROBOTS => join '|', @ROBOTS;

=head1 FUNCTIONS

=head2 Info

=cut

sub Info
{
	my ($ua, $ua_info) = @_;

    if (   ($ua =~ m{(?<bot>$LIST_ROBOTS)[ /]v?(?<bot_version>\d+(\.\d+\.\d+)?)})
        || ($ua =~ m{(?<bot>$LIST_ROBOTS)}))
    {
        $ua_info->{bot}                 = $+{bot};
        $ua_info->{bot_version}         = $+{bot_version} || '';
        $ua_info->{os}                  = 'N/A';
        $ua_info->{os_version}          = 'N/A';
        $ua_info->{device_type}         = 'N/A';
        $ua_info->{device_manufacturer} = 'N/A';
        $ua_info->{device_model}        = 'N/A';
        $ua_info->{browser}             = 'N/A';
        $ua_info->{browser_version}     = 'N/A';
    }
}

1;
