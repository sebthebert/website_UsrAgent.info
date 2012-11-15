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

my $data = UsrAgent::DB::Load_Browser();
my @d_series = ();

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
	$series->{name} = sprintf "%s (%.1f)", $k, ($subtotal/$total*100);
	push @d_series, $series;
	printf "%s: %s\n", $k, join(',', @d_values);
}

my $chart = Chart::Clicker->new(width => 400, height => 400, format => 'png');
my $defctx = $chart->get_context('default');

my $dataset = Chart::Clicker::Data::DataSet->new(
	series  => \@d_series);
$chart->add_to_datasets($dataset);

my $pie = Chart::Clicker::Renderer::Pie->new(
        opacity => .75,
    );
$pie->brush->width(2);

$defctx->renderer($pie);

$defctx->domain_axis->hidden(1);
$defctx->range_axis->hidden(1);
$chart->plot->grid->visible(0);

$chart->write_output('pie.png');
