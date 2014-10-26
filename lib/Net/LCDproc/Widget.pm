package Net::LCDproc::Widget;
{
    $Net::LCDproc::Widget::VERSION = '0.1.1';
}

#ABSTRACT: Base class for all the widgets

use v5.10;
use Moose;
use Net::LCDproc::Meta::Widget;
use Log::Any qw($log);
use namespace::autoclean;

has id => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has type => (
    is      => 'ro',
    isa     => 'Str',
    traits  => ['NoState'],
    default => sub {
        my $pkg = shift->meta->{package};
        my @parts = split /::/, $pkg;
        return lc $parts[-1];
    },
);

has frame_id => (
    is        => 'rw',
    isa       => 'Str',
    traits    => ['NoState'],
    predicate => 'has_frame_id',

    #isa => 'Net::LCDproc::Widget::Frame',
);

has screen => (
    is     => 'rw',
    isa    => 'Net::LCDproc::Screen',
    traits => ['NoState'],
);

has is_new => (
    traits   => [qw/Bool NoState/],
    is       => 'ro',
    isa      => 'Bool',
    default  => 1,
    required => 1,
    handles  => {added => 'unset',},
);

has changed => (
    traits  => [qw/Bool NoState/],
    is      => 'rw',
    isa     => 'Bool',
    handles => {
        has_changed    => 'set',
        change_updated => 'unset',
    },
);

has _set_cmd => (
    is       => 'rw',
    isa      => 'ArrayRef',
    traits   => ['NoState'],
    required => 1,
    default  => sub { [] },
);

### Public Methods

sub set {
    my ($self, $attr_name, $new_val) = @_;

    $log->debugf('Setting %s: "%s"', $attr_name, $new_val) if $log->is_debug;
    my $attr = $self->meta->get_attribute($attr_name);
    $attr->set_value($self, $new_val);
    $self->is_changed;

    return 1;
}

sub update {
    my $self = shift;

    if ($self->is_new) {

        # needs to be added
        $self->_create_widget_on_server;
    }

    if (!$self->changed) {
        return;
    }
    $log->debug('Updating widget: ' . $self->id) if $log->is_debug;
    my $cmd_str = $self->_get_set_cmd_str;

    $self->screen->_lcdproc->_send_cmd($cmd_str);

    $self->change_updated;
    return 1;
}

# removes this widget from the LCDproc server, unhooks from $self->server, then destroys itself
sub remove {
    my $self = shift;

    my $cmd_str = sprintf 'widget_del %s %s', $self->screen->id, $self->id;
    $self->_lcdproc->_send_cmd($cmd_str);

    return 1;
}

### Private Methods
sub _get_set_cmd_str {
    my ($self) = @_;

    my $cmd_str = sprintf 'widget_set %s %s', $self->screen->id, $self->id;

    foreach my $name (@{$self->_set_cmd}) {
        my $attr = $self->meta->get_attribute($name);
        my $val  = $attr->get_value($self);

        # should only ever be Str or Int
        if ($attr->type_constraint eq 'Str') {
            $cmd_str .= " \"$val\"";
        } else {
            $cmd_str .= " $val";
        }
    }

    return $cmd_str;

}

sub _create_widget_on_server {
    my $self = shift;
    $log->debugf('Adding new widget: %s - %s', $self->id, $self->type);
    my $add_str = sprintf 'widget_add %s %s %s',
      $self->screen->id, $self->id, $self->type;

    if ($self->has_frame_id) {
        $add_str .= " -in " . $self->frame_id;
    }
    $self->screen->_lcdproc->_send_cmd($add_str);

    $self->added;

    # make sure it gets set
    $self->has_changed;
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Net::LCDproc::Widget - Base class for all the widgets

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
