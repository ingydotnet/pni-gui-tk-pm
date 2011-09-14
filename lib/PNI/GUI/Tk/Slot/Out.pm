package PNI::GUI::Tk::Slot::Out;
use strict;
use base 'PNI::GUI::Tk::Slot';
use PNI::Error;
use PNI::GUI::Tk::Canvas::Line;
use PNI::GUI::Tk::Canvas::Rectangle;

sub new {
    my $self = shift->SUPER::new(@_);
    #my $arg  = {@_};#TODO se non serve togli sta riga

    $self->add( edges => {} );

    # slot must be a PNI::Slot::Out
    $self->get_slot->isa('PNI::Slot::Out')
      or return PNI::Error::invalid_argument_type;

    $self->default_tk_bindings;

    return $self;
}

sub add_edge {
    my $self = shift;
    my $edge = shift
      or return PNI::Error::missing_required_argument;
    $edge->isa('PNI::GUI::Tk::Edge')
      or return PNI::Error::invalid_argument_type;

    # TODO per ora metto questa patch
    $self->get_slot->add_edge( $edge->get_edge );

    $self->get('edges')->{ $edge->id } = $edge;
}

sub default_tk_bindings {
    my $self         = shift;
    my $controller   = $self->get_controller;
    my $border_tk_id = $self->get_border->get_tk_id;
    my $tk_canvas    = $controller->get_canvas->get_tk_canvas;

    $tk_canvas->bind(
        $border_tk_id,
        '<ButtonPress-1>' => sub {
            $controller->connecting_edge($self);
        }
    );
    $tk_canvas->bind( $border_tk_id, '<Enter>' => [ \&show_info, $self ] );
    $tk_canvas->bind( $border_tk_id, '<Leave>' => undef );
}

sub del_edge {
    my $self = shift;
    my $edge = shift
      or return PNI::Error::missing_required_argument;

    delete $self->get('edges')->{ $edge->id };
}

sub get_edges { values %{ shift->get('edges') } }

sub show_info {
    my $tk_canvas = shift;
    my $self      = shift;
    my $center_y  = $self->get_center_y;
    my $center_x  = $self->get_center_x;

    my $tk_info_label_id = $tk_canvas->createText(
        $center_x,
        $center_y + 20,
        -text => $self->get_info,
    );

    $self->get_border->on_leave( sub { $self->hide_info($tk_info_label_id) } );
}

1
__END__

=head1 NAME

PNI::GUI::Tk::Slot::Out

=head1 METHODS

=head2 C<default_tk_bindings>

=head2 C<get_border>

=head2 C<show_info>

=cut

