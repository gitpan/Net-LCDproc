package Net::LCDproc::Widget::Frame;
{
    $Net::LCDproc::Widget::Frame::VERSION = '0.1.0';
}

#ABSTRACT: The 'frame' widget, a screen within a screen

use v5.10;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;
extends 'Net::LCDproc::Widget';

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Net::LCDproc::Widget::Frame - The 'frame' widget, a screen within a screen

=head1 VERSION

version 0.1.0

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Net::LCDproc|Net::LCDproc>

=back

=head1 BUGS AND LIMITATIONS

You can make new bug reports, and view existing ones, through the
web interface at L<https://github.com/ioanrogers/Net-LCDproc/issues>.

=head1 SOURCE

The development version is on github at L<http://github.com/ioanrogers/Net-LCDproc>
and may be cloned from L<git://github.com/ioanrogers/Net-LCDproc.git>

=head1 AUTHOR

Ioan Rogers <ioanr@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Ioan Rogers.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut
