package Net::LCDproc::Meta::Screen;
{
    $Net::LCDproc::Meta::Screen::VERSION = '0.1.1';
}

use v5.10;
use Moose::Role;
use Moose::Util::TypeConstraints;

has changed => (
    traits  => ['Bool'],
    is      => 'rw',
    isa     => 'Bool',
    handles => {
        is_changed     => 'set',
        change_updated => 'unset',
    },
);

has cmd_str => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_cmd_str',
);

package Moose::Meta::Attribute::Custom::Trait::LCDprocScreen;
{
    $Moose::Meta::Attribute::Custom::Trait::LCDprocScreen::VERSION = '0.1.1';
}
sub register_implementation {'Net::LCDproc::Meta::Screen'}

1;

__END__

=pod

=head1 NAME

Net::LCDproc::Meta::Screen

=head1 VERSION

version 0.1.1

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
