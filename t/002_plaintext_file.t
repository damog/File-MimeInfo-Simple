use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
    use_ok 'File::MimeInfo::Simple';
}

my $textfile = File::Spec->catfile("files", "plaintext.txt");
ok mimetype($textfile) eq "sjdkf", "Plaintext file";
