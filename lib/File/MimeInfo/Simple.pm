package File::MimeInfo::Simple;

use Modern::Perl;
use Carp;
use Capture::Tiny qw/capture/;

require Exporter;

our $VERSION = '0.1';

our @ISA = qw(Exporter);
our @EXPORT = qw(mimetype);

sub mimetype {
	my ($filename) = shift;
	
	croak "No filename passed to mimetype()" unless $filename;
	croak "Unable to read file: $filename" if -d $filename or ! -r $filename;
	
	my $output;
	# if platform -> windows
	if($^O =~ m!MSWin32!i) {
		# nothing by now
	} else {
		($output) = capture {
			system("file --mime -br $filename")
		}
	}
		
	chomp $output; $output;
}

1;

=head1 NAME

File::MimeInfo::Simple - Simple implementation to determine file type

=head1 USAGE

 use File::MimeInfo::Simple;
 say mimetype("/Users/damog/vatos_rudos.jpg"); # prints out 'image/jpeg'

=head1 DESCRIPTION

C<File::MimeInfo::Simple> is a much simpler implementation and uses a much
simpler approach than C<File::MimeInfo>, using the 'file' command on a
UNIX-based operating system. Windows support will be available soon. It's
inspired on Matt Aimonetti's mimetype-fu used on Ruby and the Rails world.

=head1 FUNCTIONS

=head2 mimetype( $filename )

C<mimetype> is exported by default. It receives a parameter, the file
path. It returns an string containing the mime type for the file.

=head1 DEPENDENCIES

=over

=item C<Modern::Perl>

=item C<Capture::Tiny>

=back

They are both great and excellent modules that everyone should install,
use and advocate on a regular basis.

=head1 TODO

Make it work for Windows.

=head1 AUTHOR

David Moreno &lt;david@axiombox.com&gt;.

=head1 LICENSE

Copyright 2009 David Moreno.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

