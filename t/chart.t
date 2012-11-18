#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib/";

use UsrAgent::DB;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Renderer::Pie;

=head2 Pie

=cut

sub Pie
{
	my $conf = shift;

	my $chart = Chart::Clicker->new(
		width => $conf->{width} || 400, 
		height => $conf->{height} || 400, 
		format => 'png');
	$chart->title->text($conf->{title} || 'Pie');
	$chart->title->font->size(24);
	$chart->title->padding->bottom(5);

	my $context = $chart->get_context('default');
	my $dataset = Chart::Clicker::Data::DataSet->new(
   		series => $conf->{series});
	$chart->add_to_datasets($dataset);
	my $pie = Chart::Clicker::Renderer::Pie->new();
	$pie->brush->width(2);
	$context->renderer($pie);
	$context->domain_axis->hidden(1);
	$context->range_axis->hidden(1);
	$chart->plot->grid->visible(0);
	$chart->write_output(($conf->{file} || 'pie') . '.png');
}

=head2 Pie_Browsers

=cut

sub Pie_Browsers
{
	my $data = shift;

	my @browser_series = ();
	my $total = 0;	
	foreach my $k (keys %{$data})
	{
    	foreach my $v (keys %{$data->{$k}})
    	{
        	$total += $data->{$k}->{$v};
    	}
	}
	foreach my $k (keys %{$data})
	{
    	my @d_keys = ();
    	my @d_values = ();
    	my $i = 1;
    
    	my $subtotal = 0;
    	foreach my $v (keys %{$data->{$k}})
    	{
        	push @d_keys, $i++;
        	push @d_values, $data->{$k}->{$v};
        	$subtotal += $data->{$k}->{$v};
    	}
    	my $series = Chart::Clicker::Data::Series->new(
        	keys    => \@d_keys,
        	values  => \@d_values,
    		);
    	$series->{name} = sprintf "%s (%.2f%%)", $k, ($subtotal/$total*100);
    	push @browser_series, $series;
    	printf "%s: %s\n", $k, join(',', @d_values);
	}
	Pie({ title => 'Browsers', series => \@browser_series, file => 'Pie_Browsers' });
}

sub Pie_Browser_Versions
{
	my ($data, $browser) = @_;

	my @version_series = ();
    my $total = 0;
	my $i = 1;
	foreach my $v (keys %{$data->{$browser}})
    {
		$total += $data->{$browser}->{$v};
	}
   	foreach my $v (keys %{$data->{$browser}})
   	{
		my @d_keys = ();
    	my @d_values = ();
		push @d_keys, $i++;
        push @d_values, $data->{$browser}->{$v};
		my $series = Chart::Clicker::Data::Series->new(
            keys    => \@d_keys,
            values  => \@d_values,
            );
		$series->{name} = sprintf "%s (%.2f%%)", $v, ($data->{$browser}->{$v}/$total*100);
		push @version_series, $series;
		printf "%s: %s\n", $v, $data->{$browser}->{$v};
    }
	Pie({ title => "'$browser' Browser Versions", series => \@version_series, file => "Pie_${browser}_Versions" });
}

my $data = UsrAgent::DB::Load_Browser();
Pie_Browsers($data);
Pie_Browser_Versions($data, 'Chrome');
