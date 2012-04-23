package Net::LCDproc::Screen;
{
    $Net::LCDproc::Screen::VERSION = '0.1.0';
}

#ABSTRACT: represents an LCDproc screen

use v5.10;
use Moose;
use Moose::Util::TypeConstraints;
use Log::Any qw($log);
use namespace::autoclean;

with 'Net::LCDproc::Meta::Attribute::LCDproc::Screen';

has id => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has name => (
    traits  => ['LCDprocScreen'],
    is      => 'ro',
    isa     => 'Str',
    changed => 0,
    cmd_str => '-name',
);

has ['width', 'height' . 'duration', 'timeout', 'cursor_x', 'cursor_y'] => (
    traits  => ['LCDprocScreen'],
    is      => 'ro',
    isa     => 'Int',
    changed => 0,
);

has priority => (
    traits  => ['LCDprocScreen'],
    is      => 'ro',
    isa     => enum([qw[hidden background info foreground alert input]]),
    changed => 0,
);

has heartbeat => (
    traits  => ['LCDprocScreen'],
    is      => 'ro',
    isa     => enum([qw[on off open]]),
    changed => 0,
    cmd_str => '-heartbeat',
);

has backlight => (
    traits  => ['LCDprocScreen'],
    is      => 'ro',
    isa     => enum([qw[on off open toggle blink flash ]]),
    changed => 0,
);

has cursor => (
    traits  => ['LCDprocScreen'],
    is      => 'ro',
    isa     => enum([qw[on off under block]]),
    changed => 0,
);

has widgets => (
    is      => 'rw',
    isa     => 'ArrayRef[Net::LCDproc::Widget]',
    default => sub { [] },
    lazy    => 1,
);

has is_new => (
    traits   => ['Bool'],
    is       => 'ro',
    isa      => 'Bool',
    default  => 1,
    required => 1,
    handles  => {added => 'unset',},
);

has _lcdproc => (
    is  => 'rw',
    isa => 'Net::LCDproc',
);

### Public Methods
sub set {
    my ($self, $attr_name, $new_val) = @_;

    if ($log->is_debug) {
        $log->debugf('Setting %s: [%s]', $attr_name, $new_val);
    }
    my $attr = $self->meta->get_attribute($attr_name);
    $attr->set_value($self, $new_val);
    $attr->is_changed;
    return 1;
}

# updates the screen on the server
sub update {
    my $self = shift;

    if ($self->is_new) {

        # screen needs to be added
        if ($log->is_debug) { $log->debug('Adding ' . $self->id) }
        $self->_lcdproc->_send_cmd('screen_add ' . $self->id);
        $self->added;
    }

    # even if the screen was new, we leave defaults up to the LCDproc server
    # so nothing *has* to be set
    my $changes = $self->_list_changes;

    if ($changes) {
        if ($log->is_debug) { $log->debug('Updating screen: ' . $self->id) }
        foreach my $attr_name (@{$changes}) {

            my $cmd_str = $self->_get_cmd_str_for($attr_name);

            $self->_lcdproc->_send_cmd($cmd_str);

            my $attr = $self->meta->get_attribute($attr_name);
            $attr->change_updated;
        }
    }

    # now check the the widgets attached to this screen
    foreach my $widget (@{$self->widgets}) {
        $widget->update;
    }
    return 1;
}

# TODO accept an arrayref of widgets
sub add_widget {
    my ($self, $widget) = @_;
    $widget->screen($self);
    push @{$self->widgets}, $widget;
    return 1;
}

# removes screen from N::L, deletes from server, then cascades and kills its widgets (optionally not)
sub remove {
    my ($self, $keep_widgets) = @_;

    if (!defined $keep_widgets) {
        foreach my $widget (@{$self->widgets}) {
            $widget->remove;
        }
    }
    return 1;
}

### Private Methods

sub _get_cmd_str_for {
    my ($self, $attr_name) = @_;

    my $cmd_str = 'screen_set ' . $self->id;

    my $attr = $self->meta->get_attribute($attr_name);
    if (   $attr->does('Net::LCDproc::Meta::Attribute::Trait')
        && $attr->has_cmd_str)
    {
        $cmd_str .= sprintf ' %s "%s"', $attr->cmd_str,
          $attr->get_value($self);
        return $cmd_str;
    }

    return;

}

sub _list_changes {
    my $self = shift;

    my @changes;

    foreach my $attr_name ($self->meta->get_attribute_list) {
        my $attr = $self->meta->get_attribute($attr_name);
        if (   $attr->does('Net::LCDproc::Meta::Attribute::Trait')
            && $attr->changed)
        {
            if ($attr->changed) {
                push @changes, $attr_name;
            }
        }
    }
    if (scalar @changes == 0) {
        return;
    }
    return \@changes;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Net::LCDproc::Screen - represents an LCDproc screen

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
