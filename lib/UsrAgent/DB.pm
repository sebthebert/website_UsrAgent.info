=head1 NAME

UsrAgent::DB

=cut

package UsrAgent::DB;

use strict;
use warnings;

use File::Slurp;
use JSON;

my $FILE_BROWSER = "$FindBin::Bin/../data/useragent_browser.json";
my $FILE_OS = "$FindBin::Bin/../data/useragent_os.json";

=head1 FUNCTIONS
=cut

sub Get
{
	return (from_json(read_file($FILE_OS)));
}

sub Save
{
	my $data = shift;
	my ($b, $bv) = ($data->{browser} || 'N/A', $data->{browser_version} || 'N/A');
	my ($os, $osv) = ($data->{os} || 'N/A', $data->{os_version} || 'N/A');

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
