#!/usr/bin/env perl

use v5.14;
use Moose;
use List::MoreUtils qw( any );
use Template;
use YAML qw( LoadFile );

my %api = %{ LoadFile('api.yml') };
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

        my $allow_any = grep { $_ eq '*' } @{ $def->{optional} };
        if ($allow_any)  {
            @{ $def->{optional} } = grep { $_ ne '*' } @{ $def->{optional} };
            $def->{allow_any} = 1;
        }
        else {
            $def->{allow_any} = 0;
        }

        $def->{is_required} = sub {
            my $name = shift;
            any { $_ eq $name } @{ $def->{required} };
        };
    }
}

my $warning = "### AUTO-GENERATED FILE ###\n### DO NOT EDIT. YOUR CHANGES WILL BE LOST. ###";

print "Generating lib/WebService/Bonusly.pm ... ";
$tt->process('WebService/Bonusly.pm.tt', {
    WARNING  => $warning,
    services => [ sort keys %api ],
    api      => \%api,
}, 'WebService/Bonusly.pm') or die $tt->error;
say "done.";

for my $service (keys %api) {
    my $name = ucfirst $service;
    my %methods = %{ $api{$service} };

    print "Generating lib/WebService/Bonusly/$name.pm ... ";
    $tt->process('WebService/Service.pm.tt', {
        WARNING => $warning,
        service => $service,
        methods => \%methods,
    }, "WebService/Bonusly/$name.pm") or die $tt->error;
    say "done.";
}

say "Code generation is complete.";
