#!/usr/bin/perl

use lib '../lib';
use File::MimeInfo::Simple '0.6';

print mimetype($ARGV[0]), "\n";
