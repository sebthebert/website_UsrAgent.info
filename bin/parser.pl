#!/usr/bin/perl

use strict;
use warnings;
use Readonly;

use FindBin;

use lib "$FindBin::Bin/../lib/";

use UsrAgent::Parser::Browser;
use UsrAgent::Parser::OS;
use UsrAgent::Parser::Robot;

Readonly my @MANUFACTURERS => qw/
	Dell
    HTC
    LG
	Motorola
    Nokia
    SAMSUNG
	SHARP
    SonyEricsson
    ZTE
    /;

my $LIST_MANUFACTURERS = join '|', @MANUFACTURERS;

my %stats_browser = ();
my %stats_device  = ();
my %stats_os      = ();

=head1 FUNCTIONS

=head2 Detect_Device($ua, $ua_info)

=cut

sub Detect_Device
{
    my ($ua, $ua_info) = @_;

    if (
        (
            $ua =~
m{(?<device_manufacturer>$LIST_MANUFACTURERS)[-_ \/]?(?<device_model>([^-_ \/]+))}
        )
        || ($ua =~ m{(?<device_manufacturer>BlackBerry) ?(?<device_model>\d+)})
       )
    {
        $ua_info->{device_manufacturer} = $+{device_manufacturer};
        $ua_info->{device_model}        = $+{device_model};
    }
    elsif ($ua =~ m{(?<device_model>GT-\w\d+)})
    {
        $ua_info->{device_manufacturer} = 'Samsung';
        $ua_info->{device_model}        = $+{device_model};
    }
	elsif ($ua =~ m{(?<device_model>Moto(\w+\d+))})
    {
        $ua_info->{device_manufacturer} = 'Motorola';
        $ua_info->{device_model}        = $+{device_model};
    }
    elsif ($ua =~ m{(?<device_model>Nexus( S)?)})
    {
        $ua_info->{device_manufacturer} = 'Google';
        $ua_info->{device_model}        = $+{device_model};
    }
    elsif ($ua =~ m{(?<device_model>Transformer) TF101})
    {
        $ua_info->{device_type}         = 'tablet';
        $ua_info->{device_manufacturer} = 'Asus';
        $ua_info->{device_model}        = "EeePad " . $+{device_model};
    }
    elsif ($ua =~ m{(?<device_model>Playstation 3)}i)
    {
        $ua_info->{device_manufacturer} = 'Sony';
        $ua_info->{device_model}        = $+{device_model};
        $ua_info->{os}                  = 'Playstation OS';
        $ua_info->{os_version}          = 'N/A';
    }
    elsif (
        $ua =~ m{(?<device_manufacturer>Nintendo) (?<device_model>(DSi|Wii))})
    {
        $ua_info->{device_manufacturer} = $+{device_manufacturer};
        $ua_info->{device_model}        = $+{device_model};
        $ua_info->{os}                  = 'Nintendo OS';
        $ua_info->{os_version}          = 'N/A';
    }
	elsif ($ua =~ m{hp-tablet})
	{
		$ua_info->{device_manufacturer} = 'HP';
		$ua_info->{os} = 'WebOS';
	}
    else
    {
        return;
    }

    $stats_device{"$ua_info->{device_manufacturer} $ua_info->{device_model}"} +=
        1;
}

=head2 Detect_OS($ua, $ua_info)

=cut

sub Detect_OS
{
    my ($ua, $ua_info) = @_;

    if (
        (
            $ua =~
m{(?<os>(Android|Bada|iPad;( U;)? CPU OS|hpwOS|iPhone OS|Mac OS X|MIDP|SunOS|Symbian(OS)?|Ubuntu|webOS|Windows( NT| Phone OS| XP)?))[\/ -](?<os_version>\d+((\.|_)\d+)?)}
        )
        || ($ua =~ m{(?<os>Linux) (?<os_version>(armv7l|i.86|mips|x86_64))})
        || ($ua =~ m{(?<os>Android);})
        || ($ua =~ m{(?<os>BlackBerry)})
        || ($ua =~ m{(?<os>Mac OS X)})
        || ($ua =~ m{(?<os>Windows) (?<os_version>(98|CE))})
       )
    {
        $ua_info->{os} = $+{os};
        $ua_info->{os_version} = $+{os_version} || '';
        if (
            ($ua_info->{os} =~ m{(Linux|Mac OS X|Ubuntu|Windows NT)})
            || (   ($ua_info->{os} =~ m{Windows})
                && ($ua_info->{os_version} =~ m{9.}))
           )
        {
            $ua_info->{device_type}         = 'computer';
            $ua_info->{device_manufacturer} = 'N/A';
            $ua_info->{device_model}        = 'N/A';
            $stats_device{
                "$ua_info->{device_manufacturer} $ua_info->{device_model}"} +=
                1;
        }
        elsif ($ua_info->{os} =~ m{(iPhone|iPad)})
        {
            $ua_info->{device_model} = $1;
            $ua_info->{device_type} =
                ($ua_info->{os} =~ m{iPhone} ? 'phone' : 'tablet');
            $ua_info->{device_manufacturer} = 'Apple';
            $stats_device{
                "$ua_info->{device_manufacturer} $ua_info->{device_model}"} +=
                1;
        }

#    $ua_info->{device_type} = ($ua_info->{os} =~ /(Linux|Mac OS X|Ubuntu|Windows (98|NT|Phone OS))/ ? 'computer'
#    	: ($ua_info->{os} =~ /(Bada|iPhone OS)/ ? 'phone' : 'unknown'));

		if ($ua_info->{os} =~ /^Windows (NT)?/)
		{
			$ua_info->{os} = 'Windows';
			$ua_info->{os_version} = UsrAgent::Parser::OS::Windows_Version("$ua_info->{os} $ua_info->{os_version}");
		}
        $stats_os{"$ua_info->{os} $ua_info->{os_version}"} += 1;
    }
    elsif ($ua =~ m{Darwin}i)
    {
        my $version = UsrAgent::Parser::OS::Darwin_to_OSX_Version($ua);
        $ua_info->{os} = 'Mac OS X';
        $ua_info->{os_version} = $version || '';
        $stats_os{"$ua_info->{os} $ua_info->{os_version}"} += 1;
    }
}

my $total           = 0;
my @missing_browser = ();
my @missing_device  = ();
my @missing_os      = ();

if (open my $fh, '<', "$FindBin::Bin/../data/user_agents.txt")
{
    while (<$fh>)
    {
        $total++;
        my %ua_info = ();
        my $ua      = $_;
        chomp $ua;

        UsrAgent::Parser::Robot::Info($ua, \%ua_info);
        if (!$ua_info{bot})
        {
            UsrAgent::Parser::Browser::Info($ua, \%ua_info);
            if (defined $ua_info{browser} && defined $ua_info{browser_version})
			{
				$stats_browser{"$ua_info{browser} $ua_info{browser_version}"} += 1;
			}
            Detect_Device($ua, \%ua_info);
            Detect_OS($ua, \%ua_info);

            if (!$ua_info{os})
            {
                push @missing_os, $ua;
            }
            if (!$ua_info{browser})
            {
                push @missing_browser, $ua;
            }
            if (!$ua_info{device_manufacturer})
            {
                push @missing_device, $ua;
            }
        }
    }
    close $fh;
}

=head2 comment
foreach my $k (sort keys %stats_device)
{
    printf "%s: %d (%.2f%%)\n", $k, $stats_device{$k},
        $stats_device{$k} / $total * 100;
}
foreach my $k (sort keys %stats_browser)
{
    printf "%s: %d (%.2f%%)\n", $k, $stats_browser{$k},
        $stats_browser{$k} / $total * 100;
}
foreach my $k (sort keys %stats_os)
{
    printf "%s: %d (%.2f%%)\n", $k, $stats_os{$k}, $stats_os{$k} / $total * 100;
}
printf "Unknown: %d/%d (%.2f%%)\n", scalar(@missing_os), $total,
    scalar(@missing_os) / $total * 100;
=cut
printf "\n ### Missing OS: %d ###\n", scalar(@missing_os);
foreach my $m (@missing_os)
{
    print "$m\n";
}

printf "\n ### Missing Browsers: %d ###\n", scalar(@missing_browser);
foreach my $m (@missing_browser)
{
    print "$m\n";
}

printf "\n ### Missing Devices: %d ###\n", scalar(@missing_device);
foreach my $m (@missing_device)
{
    print "$m\n";
}
