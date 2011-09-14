package PNI::GUI::Tk::Canvas::Line;
use parent 'PNI::GUI::Tk::Canvas::Item';
use strict;
use PNI::Error;

sub new {
    my $class = shift;
    my $arg   = {@_};
    my $self  = $class->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;

    my $end_y = $arg->{end_y};
    $self->add( end_y => $end_y );

    my $end_x = $arg->{end_x};
    $self->add( end_x => $end_x );

    my $start_y = $arg->{start_y};
    $self->add( start_y => $start_y );

    my $start_x = $arg->{start_x};
    $self->add( start_x => $start_x );

    # TODO metti nella forma come Window e Text
    my $tk_canvas = $self->get_tk_canvas;
    my $tk_id = $tk_canvas->createLine( $start_x, $start_y, $end_x, $end_y );
    $self->set( tk_id => $tk_id );

    return $self;
}

# TODO questi metodi sono da rivedere, devo usare le api di Tk, non della memoria aggiuntiva per valori che Tk mi da gia
sub get_end_y { shift->get('end_y') }

sub get_end_x { shift->get('end_x') }

# return $start_y
sub get_start_y { shift->get('start_y') }

# return $start_x
sub get_start_x { shift->get('start_x') }

sub set_end_y {
    my $self  = shift;
    my $end_y = shift
      or return PNI::Error::missing_required_argument;

    $self->get_tk_canvas->coords(
        $self->get_tk_id, $self->get_start_x, $self->get_start_y,
        $self->get_end_x, $end_y,
    );

    return $self->set( end_y => $end_y );
}

sub set_end_x {
    my $self  = shift;
    my $end_x = shift
      or return PNI::Error::missing_required_argument;

    $self->get_tk_canvas->coords(
        $self->get_tk_id, $self->get_start_x, $self->get_start_y,
        $end_x,           $self->get_end_y,
    );

    return $self->set( end_x => $end_x );
}

sub set_start_y {
    my $self    = shift;
    my $start_y = shift
      or return PNI::Error::missing_required_argument;

    $self->get_tk_canvas->coords(
        $self->get_tk_id, $self->get_start_x, $start_y,
        $self->get_end_x, $self->get_end_y,
    );

    return $self->set( start_y => $start_y );
}

sub set_start_x {
    my $self    = shift;
    my $start_x = shift
      or return PNI::Error::missing_required_argument;

    $self->get_tk_canvas->coords(
        $self->get_tk_id, $start_x, $self->get_start_y,
        $self->get_end_x, $self->get_end_y,
    );

    return $self->set( start_x => $start_x );
}

1;
__END__

=head1 NAME

PNI::GUI::Tk::Canvas::Line - Tk::Canvas line item

=head2 C<get_end_x>

=head2 C<get_end_y>

=head2 C<get_start_x>

=head2 C<get_start_y>

=head2 C<set_end_x>

=head2 C<set_end_y>

=head2 C<set_start_x>

=head2 C<set_start_y>

=cut
