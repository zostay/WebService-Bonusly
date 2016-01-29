#!/usr/bin/env perl
use v5.14;

use YAML qw( LoadFile );

my %api = %{ LoadFile('api.yml') };
my @apis = keys %api;

print "Removing auto-generated files ... ";
for my $api (@apis) {
    my $file = "lib/WebService/Bonusly/" . ucfirst($api) . ".pm";
    print "Unlinking $file.";
    unlink $file;
}
say "done.";
