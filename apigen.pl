#!/usr/bin/env perl

use v5.14;
use Moose;
use List::MoreUtils qw( any );
use Template;

my %api = (
    bonuses => {
        list => {
            path     => 'bonuses',
            optional => [ qw( limit start_time end_time non_zero top_level giver_email receiver_email user_email hashtag ) ],
        },
        get => {
            path     => 'bonuses/:id',
            required => [ qw( id ) ],
        },
        give => {
            method   => 'POST',
            path     => 'bonuses',
            required => [ qw( receiver_email reason amount ) ],
            optional => [ qw( giver_email ) ],
        },
    },

    users => {
        list => {
            path     => 'users',
        },
        get => {
            path     => 'users/:id',
            required => [ qw( id ) ],
        },
        me => {
            path     => 'users/me',
        },
        redemptions => {
            path     => 'users/:id/redemptions',
        },
        add => {
            method   => 'POST',
            path     => 'users',
            required => [ qw( email first_name last_name ) ],
            optional => [ qw( %custom_properties user_mode budget_boost external_unique_id ) ],
        },
        update => {
            method   => 'PUT',
            path     => 'users/:id',
            required => [ qw( id ) ],
            optional => [ qw( email first_name last_name %custom_properties user_mode budget_boost external_unique_id ) ],
        },
        delete => {
            method   => 'DELETE',
            path     => 'users/:id',
            required => [ qw( id ) ],
        },
    },

    values => {
        list => {
            path     => 'values',
        },
        get => {
            path     => 'values/:id',
            required => [ qw( id ) ],
        },
    },

    companies => {
        show => {
            path     => 'companies/show',
        },
        update => {
            method   => 'PUT',
            path     => 'companies/update',
            optional => [ qw( name %custom_properties ) ],
        },
    },

    leaderboards => {
        standouts => {
            path     => 'analytics/standouts',
            optional => [ qw( role value custom_property_name custom_property_value ) ],
        },
    },

    rewards => {
        list => {
            path     => 'rewards',
            optional => [ qw( catalog_country request_country personalize_for ) ],
        },
        get => {
            path     => 'rewards/:id',
            required => [ qw( id ) ],
        },
        take => {
            method   => 'POST',
            path     => 'rewards',
            required => [ qw( denomination_id user_id ) ],
        },
    },

    redemptions => {
        get => {
            path     => 'redemptions/:id',
            required => [ qw( id ) ],
        },
    },

    authentication => {
        sessions => {
            method   => 'POST',
            path     => 'sessions',
            required => [ qw( email password ) ],
            token    => 0,
        },
    },
);

my $tt = Template->new(
    INCLUDE_PATH => 'tmpl',
    OUTPUT_PATH  => 'lib',
);

for my $service (keys %api) {
    for my $method (keys %{ $api{$service} }) {
        my $def = $api{$service}{$method};
        $def->{optional} //= [];
        $def->{required} //= [];
        $def->{method}   //= 'GET';
        $def->{token}    //= 1;

        $def->{is_required} = sub {
            my $name = shift;
            any { $_ eq $name } @{ $def->{required} };
        };
    }
}

print "Generating lib/WebService/Bonusly.pm ... ";
$tt->process('WebService/Bonusly.pm.tt', {
    services => [ sort keys %api ],
    api      => \%api,
}, 'WebService/Bonusly.pm') or die $tt->error;
say "done.";

for my $service (keys %api) {
    my $name = ucfirst $service;
    my %methods = %{ $api{$service} };

    print "Generating lib/WebService/Bonusly/$name.pm ... ";
    $tt->process('WebService/Service.pm.tt', {
        service => $service,
        methods => \%methods,
    }, "WebService/Bonusly/$name.pm") or die $tt->error;
    say "done.";
}

say "Code generation is complete.";
