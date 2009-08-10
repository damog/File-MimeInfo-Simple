#!/usr/bin/perl

use lib '../lib';
use File::MimeInfo::Simple;

print mimetype($ARGV[0]), "\n";