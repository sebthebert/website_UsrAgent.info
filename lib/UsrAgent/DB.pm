=head1 NAME

UsrAgent::DB

=cut

package UsrAgent::DB;

use strict;
use warnings;

use File::Slurp;
use JSON;

my $FILE_BROWSER = "$FindBin::Bin/../data/useragent_browser.json";
my $FILE_DEVICE = "$FindBin::Bin/../data/useragent_device.json";
my $FILE_OS = "$FindBin::Bin/../data/useragent_os.json";

=head1 FUNCTIONS

=cut

sub Load_Browser
{
	if (-r $FILE_BROWSER)
    {
        my $json_data = from_json(read_file($FILE_BROWSER));

		return ($json_data);
	}	

	return (undef);
}

=head2 Save($data)

=cut

sub Save
{
	my $data = shift;

	Save_Browser($data);
	Save_Device($data);
	Save_OS($data);
}

sub Save_Browser
{
	my $data = shift;
	
	my ($b, $bv) = ($data->{browser} || 'N/A', $data->{browser_version} || 'N/A');
	my $json_data = undef;
    my $json_text = undef;

	if (-r $FILE_BROWSER)
    {
        $json_data = from_json(read_file($FILE_BROWSER));

        $json_data->{$b}->{$bv} = (defined $json_data->{$b}->{$bv}
            ? $json_data->{$b}->{$bv} + 1 : 1);
        $json_text = to_json($json_data, { ascii => 1, pretty => 1 });
    }
    else
    {
        my %json = ();
        $json{$b}{$bv} = 1;
        $json_text = to_json(\%json, { ascii => 1, pretty => 1 });
    }
    write_file($FILE_BROWSER, $json_text);	
}

sub Save_Device
{
	my $data = shift;

	my ($dt, $dc, $dm) = ($data->{device_type} || 'N/A', 
		$data->{device_company} || 'N/A', $data->{device_model} || 'N/A');
	my $json_data = undef;
    my $json_text = undef;

    if (-r $FILE_DEVICE)
	{
		$json_data = from_json(read_file($FILE_DEVICE));

		$json_data->{$dt}->{$dc}->{$dm} = 
			(defined $json_data->{$dt}->{$dc}->{$dm}
            ? $json_data->{$dt}->{$dc}->{$dm} + 1 : 1);
		$json_text = to_json($json_data, { ascii => 1, pretty => 1 });
	}
	else
	{
		my %json = ();
        $json{$dt}{$dc}{$dm} = 1;
        $json_text = to_json(\%json, { ascii => 1, pretty => 1 });
	}
	write_file($FILE_DEVICE, $json_text);
}

sub Save_OS
{
	my $data = shift;

	my ($os, $osv) = ($data->{os} || 'N/A', $data->{os_version} || 'N/A');
    my $json_data = undef;
    my $json_text = undef;

	if (-r $FILE_OS)
    {
        $json_data = from_json(read_file($FILE_OS));

        $json_data->{$os}->{$osv} = (defined $json_data->{$os}->{$osv}
            ? $json_data->{$os}->{$osv} + 1 : 1);
        $json_text = to_json($json_data, { ascii => 1, pretty => 1 });
    }
    else
    {
        my %json = ();
        $json{$os}{$osv} = 1;
        $json_text = to_json(\%json, { ascii => 1, pretty => 1 });
    }
    write_file($FILE_OS, $json_text);
}

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
