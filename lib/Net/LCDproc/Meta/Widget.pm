package Net::LCDproc::Meta::Widget;
{
    $Net::LCDproc::Meta::Widget::VERSION = '0.1.1';
}

use v5.10;
use Moose qw//;
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    class_metaroles => {
        attribute => ['Net::LCDproc::Meta::Role::Widget'],

    },
    role_metaroles =>
      {applied_attribute => ['Net::LCDproc::Meta::Role::Widget'],},

);

package Net::LCDproc::Meta::Role::Widget;
{
    $Net::LCDproc::Meta::Role::Widget::VERSION = '0.1.1';
}

use Moose::Role;

before '_process_options' => sub {
    my ($self, $name, $options) = @_;

    if (exists $options->{traits} && grep {'NoState'} @{$options->{traits}}) {
        return;
    }

    if ($name eq 'id') {

        # this is immutable
        return;
    }

    if (exists $options->{trigger}) {

        # shouldn't be another trigger
        return;
    }

    $options->{trigger} = sub {
        shift->has_changed;
    };
};

package Net::LCDproc::Meta::Widget::Trait::NoState;
{
    $Net::LCDproc::Meta::Widget::Trait::NoState::VERSION = '0.1.1';
}
use Moose::Role;
no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::NoState;
{
    $Moose::Meta::Attribute::Custom::Trait::NoState::VERSION = '0.1.1';
}
sub register_implementation {'Net::LCDproc::Meta::Widget::Trait::NoState'}

1;

__END__

=pod

=head1 NAME

Net::LCDproc::Meta::Widget

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
