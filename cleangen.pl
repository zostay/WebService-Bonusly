#!/usr/bin/env perl
use v5.14;

use File::Path 'remove_tree';

print "Removing auto-generated files ... ";
remove_tree 'lib';
say "done.";
