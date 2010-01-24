#!/usr/bin/env perl

use inc::Module::Install;

name 'File-MimeInfo-Simple';

perl_version '5.005';

all_from 'lib/File/MimeInfo/Simple.pm';

license 'MIT';
install_share;

test_requires 'Test::More' => '0';

WriteAll;