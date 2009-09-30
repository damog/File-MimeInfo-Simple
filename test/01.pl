#!/usr/bin/perl

use lib '../lib';
use File::MimeInfo::Simple '0.4';

print mimetype($ARGV[0]), "\n";