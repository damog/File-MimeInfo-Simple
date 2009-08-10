#!/usr/bin/env perl

use inc::Module::Install;

name 'File-MimeInfo-Simple';

perl_version '5.010';

all_from 'lib/File/MimeInfo/Simple.pm';

requires 'Modern::Perl' => '1.03';
requires 'Capture::Tiny' => '0.06';

license 'MIT';

WriteAll;