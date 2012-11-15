=head1 NAME

UsrAgent::Device

=cut

package UsrAgent::Device;

use strict;
use warnings;

my %company = (
	Asus => qw/
		'Transformer TF\d+'
		/,
	HTC => qw/ 
		'Nexus One'
		/,
	Samsung => qw/
		'Galaxy Nexus'
		'Nexus S'
		/
	);

=head2 Company

=cut

sub Company
{
	my $info = shift;

    $info->{device_company} = ($info->{device_model} =~ /^Nexus One$/ ? 'HTC' : $info->{device_company});
    $info->{device_company} = ($info->{device_model} =~ /^(Galaxy Nexus|Nexus S)$/ ? 'Samsung' : $info->{device_company});
    $info->{device_company} = ($info->{device_model} =~ /^Macintosh$/ ? 'Apple' : $info->{device_company});
    $info->{device_company} = ($info->{device_model} =~ /^Transformer TF\d+$/ ? 'Asus' : $info->{device_company});
}

=head2 Type

=cut

sub Type
{
    my $info = shift;

    $info->{device_type} = ($info->{device_model} =~ /^Nexus One$/ ? 'SmartPhone' : $info->{device_type});
    $info->{device_type} = ($info->{device_model} =~ /^(Galaxy Nexus|Nexus S)$/ ? 'SmartPhone' : $info->{device_type});
    $info->{device_type} = ($info->{device_model} =~ /^Macintosh$/ ? 'Computer' : $info->{device_type});
    $info->{device_type} = ($info->{device_model} =~ /^Transformer TF\d+$/ ? 'Tablet' : $info->{device_type});
}

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
