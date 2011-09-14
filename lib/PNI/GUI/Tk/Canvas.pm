package PNI::GUI::Tk::Canvas;
use parent qw( PNI::Item PNI::GUI::Tk::View );
use strict;

sub new {
    my $self = shift->SUPER::new;
    my $arg  = {@_};

    $self->init_view(@_);

    my $tk_canvas =
      $self->get_controller->get_window->get_tk_main_window->Canvas();
    $self->add( tk_canvas => $tk_canvas );

    $tk_canvas->configure(
        -confine          => 0,
        -height           => 400,
        -width            => 600,
        -scrollregion     => [ 0, 0, 1000, 1000 ],
        -xscrollincrement => 1,
        -background       => 'white'
    );

    $tk_canvas->pack( -expand => 1, -fill => 'both' );

    $self->default_tk_bindings;

    return $self;
}

sub connect_or_destroy_edge {
    my $tk_canvas = shift;
    my $self      = shift;
    my $edge      = shift;

    my $controller = $self->get_controller;
    my $closest_input;
    my $closest_distance;

    my $y = $tk_canvas->XEvent->y;
    my $x = $tk_canvas->XEvent->x;

    for my $input ( $controller->get_scenario->get_inputs ) {

        # if it is the first input, by now it is the closest
        if ( not defined $closest_input ) {
            $closest_input = $input;
        }

        my $y__closest_y = $y - $closest_input->get_center_y;
        my $x__closest_x = $x - $closest_input->get_center_x;

        my $y__center_y = $y - $input->get_center_y;
        my $x__center_x = $x - $input->get_center_x;

        my $distance =
          sqrt( $y__center_y * $y__center_y + $x__center_x * $x__center_x );
        $closest_distance =
          sqrt( $y__closest_y * $y__closest_y + $x__closest_x * $x__closest_x );

        if ( $distance < $closest_distance ) {
            $closest_input    = $input;
            $closest_distance = $distance;
        }
    }

    if ( $closest_distance > 10 ) {
        return $controller->del_edge($edge);
    }
    else {
        return $controller->connect_edge_to_input( $edge, $closest_input );
    }
}

sub connecting_edge_tk_bindings {
    my $self      = shift;
    my $edge      = shift;
    my $tk_canvas = $self->get_tk_canvas;

    $tk_canvas->CanvasBind(
        '<B1-Motion>' => sub {

            # move unconnected edge
            $edge->set_end_y( $tk_canvas->XEvent->y );
            $edge->set_end_x( $tk_canvas->XEvent->x );
        }
    );
    $tk_canvas->CanvasBind( '<ButtonPress-1>' => undef );
    $tk_canvas->CanvasBind(
        '<ButtonRelease-1>' => [ \&connect_or_destroy_edge, $self, $edge ] );
    $tk_canvas->CanvasBind( '<Double-Button-1>' => undef );
}

sub default_tk_bindings {
    my $self      = shift;
    my $tk_canvas = $self->get_tk_canvas;

    $tk_canvas->CanvasBind( '<B1-Motion>'       => undef );
    $tk_canvas->CanvasBind( '<ButtonPress-1>'   => undef );
    $tk_canvas->CanvasBind( '<ButtonRelease-1>' => undef );
    $tk_canvas->CanvasBind( '<Double-Button-1>' => [ \&double_click, $self ] );
}

sub double_click {
    my $tk_canvas  = shift;
    my $self       = shift;
    my $controller = $self->get_controller;

    my $x = $tk_canvas->XEvent->x;
    my $y = $tk_canvas->XEvent->y;

    # Do nothing when double clicking an item
    return if $tk_canvas->find( 'withtag', 'current' );

    # Disable default double click callout
    # so there is only one selector open
    $tk_canvas->CanvasBind( '<Double-Button-1>' => undef );

    # Create node selector
    $controller->add_node_selector(
        x => $x,
        y => $y,
    );
}

# override PNI::GUI::Tk::View::get_tk_canvas
# return $tk_canvas : Tk::Canvas
sub get_tk_canvas { shift->get('tk_canvas') }

sub opened_node_inspector {
    my $self = shift;

    # Clicking the canvas destroys node inspector
    $self->get_tk_canvas->CanvasBind( '<ButtonPress-1>' =>
          [ sub { $self->get_controller->del_node_inspector } ] );
}

sub opened_node_selector {
    my $self = shift;

    # Clicking the canvas destroys node selector
    $self->get_tk_canvas->CanvasBind( '<ButtonPress-1>' =>
          [ sub { $self->get_controller->del_node_selector } ] );
}

1
__END__

=head1 NAME

PNI::GUI::Tk::Canvas

=cut

