=head1 NAME

UsrAgent::Web::API

=cut

package UsrAgent::Web::API;

use strict;
use warnings;

use Dancer ':syntax';

use UsrAgent::Parser;

our $VERSION = '0.1';

set serializer => 'JSON';

prefix '/api';

=head1 ROUTES

=head2 GET /api/version

=cut

get '/version' => sub
{
	return ( { version => $VERSION } );
};

get '/ua_info' => sub
{
	my $ua = request->user_agent;

	my %info = UsrAgent::Parser::Info($ua);

	return (\%info);
};

post '/ua_info' => sub
{
	return ( { params } );
};

1;

=head1 AUTHOR

Sebastien Thebert <stt@usragent.info>

=cut
