package WebService::Bonusly::Base;

use v5.14;
use Class::Load qw( load_class );
use Moose;
use Furl;

# ABSTRACT: A utility class for WebService::Bonusly

=head1 DESCRIPTION

This is a utility class for the Bonus.ly web service. 

See L<WebService::Bonusly>.

=cut

our $BONUSLY_API_URL = 'https://bonus.ly/api/v1/';

has token => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

has base_url => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
    default     => $BONUSLY_API_URL,
);

has ua => (
    is          => 'ro',
    required    => 1,
    lazy        => 1,
    builder     => '_build_ua',
);

# Undocumented attribute, mostly useful for testing. Use at your own risk!
has _json_flags => (
    is          => 'ro',
    isa         => 'HashRef',
    required    => 1,
    default     => sub { {} },
);

has debug => (
    is          => 'rw',
    isa         => 'Bool',
    required    => 1,
    default     => 0,
);

sub _build_ua { Furl->new }

sub _service_builder {
    my ($class, $service_name) = @_;

    my $_build_service = "_build_$service_name";
    $class->meta->add_method("_build_$service_name" => sub {
        my $self = shift;
        my $class_name = ucfirst $service_name;
        load_class("WebService::Bonusly::$class_name")->new(
            ws => $self,
        );
    });

    return $_build_service;
}

sub print_debug {
    return unless $_[0]->debug;
    shift;
    warn @_, "\n";
}

__PACKAGE__->meta->make_immutable;
