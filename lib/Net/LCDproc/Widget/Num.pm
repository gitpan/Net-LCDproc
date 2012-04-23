package Net::LCDproc::Widget::Num;
{
    $Net::LCDproc::Widget::Num::VERSION = '0.1.0';
}

#ABSTRACT: 'num' widget

use v5.10;
use Moose;
use namespace::autoclean;

extends 'Net::LCDproc::Widget';

has ['x', 'int'] => (
    is       => 'rw',
    isa      => 'Int',
    required => 1,
    default  => 1,
    trigger  => sub {
        $_[0]->has_changed;
    },
);

has '+type' => (default => 'num',);

has '+_set_cmd' => (default => sub { [qw/ x int /] },);

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Net::LCDproc::Widget::Num - 'num' widget

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
