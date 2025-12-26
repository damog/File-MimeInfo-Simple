#!/usr/bin/env perl
#
# Benchmark: File::MimeInfo::Simple vs File::MimeInfo
#
# Usage: perl benchmark/compare.pl [iterations]
#

use strict;
use warnings;
use Benchmark qw(cmpthese timethese :hireswallclock);
use File::Temp qw(tempdir);
use File::Spec;

# Check for required modules
my $have_simple = eval { require File::MimeInfo::Simple; 1 };
my $have_mimeinfo = eval { require File::MimeInfo; 1 };

die "File::MimeInfo::Simple not found. Run: perl Makefile.PL && make\n" unless $have_simple;

unless ($have_mimeinfo) {
    print "=" x 60, "\n";
    print "NOTE: File::MimeInfo not installed.\n";
    print "Install it with: cpan File::MimeInfo\n";
    print "Running benchmark for File::MimeInfo::Simple only.\n";
    print "=" x 60, "\n\n";
}

# Number of iterations
my $iterations = $ARGV[0] || 1000;

print "Benchmark: File::MimeInfo::Simple vs File::MimeInfo\n";
print "=" x 60, "\n";
print "Iterations per test: $iterations\n\n";

# Create test files
my $tempdir = tempdir(CLEANUP => 1);
my @test_files;

my %file_specs = (
    'text.txt'      => "Hello, world!\nThis is a plain text file.\n",
    'data.json'     => '{"name": "test", "value": 123}',
    'page.html'     => '<!DOCTYPE html><html><body>Test</body></html>',
    'script.pl'     => "#!/usr/bin/env perl\nprint 'Hello';\n",
    'style.css'     => 'body { color: black; }',
    'code.js'       => 'console.log("hello");',
    'config.xml'    => '<?xml version="1.0"?><root></root>',
    'readme.md'     => "# Title\n\nSome markdown content.",
    'app.ts'        => 'const x: number = 42;',
    'image.svg'     => '<svg xmlns="http://www.w3.org/2000/svg"></svg>',
);

print "Creating test files...\n";
for my $filename (sort keys %file_specs) {
    my $filepath = File::Spec->catfile($tempdir, $filename);
    open(my $fh, '>', $filepath) or die "Cannot create $filepath: $!";
    print $fh $file_specs{$filename};
    close($fh);
    push @test_files, $filepath;
    print "  - $filename\n";
}
print "\n";

# Warm up - load any lazy data
if ($have_simple) {
    File::MimeInfo::Simple::mimetype($test_files[0]);
}
if ($have_mimeinfo) {
    File::MimeInfo::mimetype($test_files[0]);
}

# Benchmark individual files
print "=" x 60, "\n";
print "Per-file results (higher is better = more calls/second)\n";
print "=" x 60, "\n\n";

for my $filepath (@test_files) {
    my $filename = (File::Spec->splitpath($filepath))[2];
    print "File: $filename\n";
    print "-" x 40, "\n";
    
    my $tests = {};
    
    $tests->{'Simple'} = sub {
        File::MimeInfo::Simple::mimetype($filepath);
    };
    
    if ($have_mimeinfo) {
        $tests->{'MimeInfo'} = sub {
            File::MimeInfo::mimetype($filepath);
        };
    }
    
    cmpthese($iterations, $tests);
    print "\n";
}

# Benchmark batch processing
print "=" x 60, "\n";
print "Batch processing: all files in sequence\n";
print "=" x 60, "\n\n";

my $batch_tests = {};

$batch_tests->{'Simple (batch)'} = sub {
    for my $f (@test_files) {
        File::MimeInfo::Simple::mimetype($f);
    }
};

if ($have_mimeinfo) {
    $batch_tests->{'MimeInfo (batch)'} = sub {
        for my $f (@test_files) {
            File::MimeInfo::mimetype($f);
        }
    };
}

cmpthese($iterations, $batch_tests);

print "\n";
print "=" x 60, "\n";
print "Summary\n";
print "=" x 60, "\n\n";

# Show detected MIME types
print "MIME types detected by File::MimeInfo::Simple:\n";
for my $filepath (@test_files) {
    my $filename = (File::Spec->splitpath($filepath))[2];
    my $mime = File::MimeInfo::Simple::mimetype($filepath) // '(undef)';
    printf "  %-15s => %s\n", $filename, $mime;
}

if ($have_mimeinfo) {
    print "\nMIME types detected by File::MimeInfo:\n";
    for my $filepath (@test_files) {
        my $filename = (File::Spec->splitpath($filepath))[2];
        my $mime = File::MimeInfo::mimetype($filepath) // '(undef)';
        printf "  %-15s => %s\n", $filename, $mime;
    }
}

print "\n";
print "Notes:\n";
print "  - File::MimeInfo::Simple uses 'file' command on Unix (content-based)\n";
print "  - File::MimeInfo uses freedesktop.org shared-mime-info database\n";
print "  - Results may vary based on system configuration\n";

