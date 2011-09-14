package PNI::GUI::Tk::Slot::In;
use parent 'PNI::GUI::Tk::Slot';
use strict;
use PNI::Error;
use PNI::GUI::Tk::Canvas::Rectangle;

sub new {
    my $self = shift->SUPER::new(@_);

    $self->add('edge');

    $self->add('inspector');

    # slot must be a PNI::Slot::In
    $self->get_slot->isa('PNI::Slot::In')
      or return PNI::Error::invalid_argument_type;

    $self->default_tk_bindings;

    return $self;
}

sub default_tk_bindings {
    my $self      = shift;
    my $border    = $self->get_border;
    my $tk_canvas = $self->get_controller->get_canvas->get_tk_canvas;

    $border->on_buttonrelease_1(undef);
    $border->on_double_button_1(undef);
    $border->on_enter(
        sub {
            $tk_canvas->CanvasBind(
                '<ButtonPress-1>' => sub { $self->open_inspector } );
            $self->show_info;
        }
    );
    $border->on_leave(undef);

}

sub del_edge { shift->set( edge => undef ) }

sub del_inspector {
    my $self      = shift;
    my $inspector = $self->get('inspector');
    $inspector->delete;
    $self->set( inspector => undef );

}

# return $edge : PNI::GUI::Tk::Edge
sub get_edge { shift->get('edge') }

sub is_connected { defined shift->get_edge ? 1 : 0 }

# TODO non e' bellissimo, meglio come ho fatto in PNI::GUI::Tk::Edge
# return 1
sub move {
    my $self = shift;
    my ( $dx, $dy ) = @_;
    my $center_y = $self->get_center_y;
    my $center_x = $self->get_center_x;

    $self->set_center_y( $center_y + $dy );
    $self->set_center_x( $center_x + $dx );
}

sub open_inspector {
    my $self      = shift;
    my $slot      = $self->get_slot;
    my $canvas    = $self->get_controller->get_canvas;
    my $tk_canvas = $canvas->get_tk_canvas;
    my $frame     = $tk_canvas->Frame;
    my $y         = $self->get_center_y - 10;
    my $x         = $self->get_center_x;

    my $data = $slot->get_data;
    $frame->Label( -text => $slot->get_name )->pack( -side => 'left' );

    my $entry = $frame->Entry(
        -exportselection => 1,
        -text            => $data,
    );
    $entry->pack( -side => 'right' );
    $entry->bind(
        '<Return>' => sub {
            $slot->set_data( $entry->get );
            $self->del_inspector;
        }
    );

    $self->set(
        inspector => PNI::GUI::Tk::Canvas::Window->new(
            canvas => $canvas,
            window => $frame,
            y      => $y,
            x      => $x,
        )
    );

 # TODO non mi funziona
 #$tk_canvas->CanvasBind( '<ButtonRelease-1>' => sub { $self->del_inspector } );
}

sub set_edge {
    my $self = shift;
    my $edge = shift
      or return PNI::Error::missing_required_argument;

    $edge->isa('PNI::GUI::Tk::Edge')
      or return PNI::Error::invalid_argument_type;

    # TODO per ora metto questa patch
    $self->get_slot->add_edge( $edge->get_edge );

    $self->set( edge => $edge );
}

sub show_info {
    my $self      = shift;
    my $border    = $self->get_border;
    my $canvas    = $self->get_controller->get_canvas;
    my $center_y  = $self->get_center_y;
    my $center_x  = $self->get_center_x;
    my $tk_canvas = $canvas->get_tk_canvas;

    my $tk_info_label_id = $tk_canvas->createText(
        $center_x,
        $center_y - 20,
        -text => $self->get_info,
    );

    $border->on_leave(
        sub {
            $self->hide_info($tk_info_label_id);
            $canvas->default_tk_bindings;
        }
    );

}

1
__END__

=head1 NAME

PNI::GUI::Tk::Slot::In

=head1 METHODS

=head2 C<show_info>

=cut

