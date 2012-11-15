=head1 NAME

UsrAgent::Device

=cut

package UsrAgent::Device;

use strict;
use warnings;

my %company_models = (
	Apple => {
		Computer => join('|', ( 
			'Macintosh',
			)),
		},
	Asus => { 
		Tablet => join('|', (
			'Transformer TF\d+',
			)),
		},
	HTC => {
		SmartPhone => join('|', (
			'Nexus One',
			)),
		},
	Samsung => {
		SmartPhone => join('|', (
			'Galaxy Nexus',
			'Nexus S',
			)),
		},
	);

=head2 Company

=cut

sub Company
{
	my $info = shift;

	if (defined $info->{device_model})
    {
		foreach my $c (keys %company_models)
		{
			foreach my $t (keys $company_models{$c})
			{
				$info->{device_company} = 
				($info->{device_model} =~ /^($company_models{$c}{$t})$/ 
				? $c : $info->{device_company});
			}
		}
	}
}

=head2 Type

=cut

sub Type
{
    my $info = shift;

	if (defined $info->{device_model})
	{
		foreach my $c (keys %company_models)
        {
            foreach my $t (keys $company_models{$c})
            {
                $info->{device_type} =
                ($info->{device_model} =~ /^($company_models{$c}{$t})$/
                ? $t : $info->{device_type});
            }
        }	
	}	
}

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
