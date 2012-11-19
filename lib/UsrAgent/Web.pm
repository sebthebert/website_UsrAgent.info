=head1 NAME

UsrAgent::Web

=cut

package UsrAgent::Web;

use strict;
use warnings;

use Dancer ':syntax';
use Geo::IP;

use UsrAgent::Browser;
use UsrAgent::DB;
use UsrAgent::OS;
use UsrAgent::Parser;

our $VERSION = '0.1';

=head1 ROUTES

=head2 GET /

=cut

any ['get', 'post'] => '/' => sub 
{
	my $ip = request->remote_address;
	my $ua = undef;

	my $gi = Geo::IP->new(GEOIP_MEMORY_CACHE);
	my $country = $gi->country_code_by_addr($ip);
	
	if (request->method() eq "POST") 
	{
		$ua = params->{ua};		
	}
	else
	{
		$ua = request->user_agent;
	}

	my %info = UsrAgent::Parser::Info($ua);
	my $b_data = UsrAgent::Browser::Data($info{browser});
	my $os_data = UsrAgent::OS::Data($info{os});

	UsrAgent::DB::Save(\%info);

	template 'home', 
		{	
			ip => $ip, 
			country => $country,
			ua => $ua, 
			info => \%info, 
			browser_color => $b_data->{color},
			browser_logo => UsrAgent::Browser::Logo($info{browser}, 32),
			os_color => $os_data->{color},
			os_logo => UsrAgent::OS::Logo($info{os}, 32),
		};	
};

=head2 GET /about

=cut

get '/about' => sub
{
    template 'markdown', { file => config->{public} . '/md/about.md' };
};

=head2 GET /browser/:browser

=cut

get '/browser/:browser' => sub
{
	my $browser = params->{browser}; 

	my $b_data = UsrAgent::Browser::Data($browser);
	template 'browser_info',
		{
			browser => $browser,
			browser_logo => UsrAgent::Browser::Logo($browser, 512),
			website => $b_data->{website},
		}
};

=head2 GET /community

=cut

get '/community' => sub
{
	template 'community';
};

=head2 GET /os/:os

=cut

get '/os/:os' => sub
{
	my $os = params->{os};

	#my $os_data = UsrAgent::OS::Data($os);
	template 'os_info',
        {
            os => $os,
            os_logo => UsrAgent::OS::Logo($os, 512),
        }
};

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
