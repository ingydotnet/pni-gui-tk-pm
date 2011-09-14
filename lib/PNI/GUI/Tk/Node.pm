package PNI::GUI::Tk::Node;
use parent qw( PNI::GUI::Node PNI::GUI::Tk::View PNI::GUI::Tk::Canvas::Group );
use strict;
use PNI::Error;
use PNI::GUI::Tk::Canvas::Rectangle;
use PNI::GUI::Tk::Slot::In;
use PNI::GUI::Tk::Slot::Out;

sub new {
    my $self = shift->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;
    my $arg = {@_};

    $self->init_view(@_);
    $self->init_canvas_group(@_);

    $self->add('info');

    $self->add( input => {} );

    $self->add( output => {} );

    # Set default height and width.
    my $height     = $self->get_height || 20;
    my $label_text = $self->get_label;
    my $width      = $self->get_width || 6 * length($label_text);
    $self->set_height($height);
    $self->set_width($width);

    my $canvas      = $self->get_controller->get_canvas;
    my $center_y    = $self->get_center_y;
    my $center_x    = $self->get_center_x;
    my $half_height = $height / 2;
    my $half_width  = $width / 2;
    my $self_id     = $self->id;

    my $y1 = $center_y - $half_height;
    my $y2 = $center_y + $half_height;
    my $x1 = $center_x - $half_width;
    my $x2 = $center_x + $half_width;

    my $border = PNI::GUI::Tk::Canvas::Rectangle->new(
        canvas => $canvas,
        y1     => $y1,
        y2     => $y2,
        x1     => $x1,
        x2     => $x2,
    ) or return PNI::Error::unable_to_create_item;

    $self->add_tk_id( $border->get_tk_id );
    $self->add( border => $border );

    my $text = $self->add_text(
        canvas => $canvas,
        text   => $label_text,
        y      => $center_y,
        x      => $center_x,
    ) or return PNI::Error::unable_to_create_item;

    $self->add( text => $text );

    # Draw inputs.
    #-------------------------------------------------------------------------
    my @input         = $self->get_node->get_inputs;
    my $num_of_inputs = scalar @input;

    # If there is only one input, draw it in the north-est corner
    if ( $num_of_inputs == 1 ) {

        $self->add_input(
            center_y => $y1,
            center_x => $x1,
            slot     => $input[0],
        );
    }
    else {

        # If you enter here there is no input or ...

        for ( my $i = 0 ; $i < $num_of_inputs ; $i++ ) {

            # ... you enter in this for loop.

            my $slot_distance = $width / ( $num_of_inputs - 1 );
            my $center_y      = $y1;
            my $center_x      = $x1 + $slot_distance * $i;

            $self->add_input(
                center_y => $center_y,
                center_x => $center_x,
                slot     => $input[$i],
            );
        }
    }

    #-------------------------------------------------------------------------

    # Draw outputs.
    #-------------------------------------------------------------------------
    my @output         = $self->get_node->get_outputs;
    my $num_of_outputs = scalar @output;

    # If there is only one output, draw it in the north-est corner
    if ( $num_of_outputs == 1 ) {
        my $center_y = $y2;
        my $center_x = $x1;

        $self->add_output(
            center_y => $center_y,
            center_x => $center_x,
            slot     => $output[0],
        );

    }
    else {

        # If you enter here there is no output or ...

        for ( my $i = 0 ; $i < $num_of_outputs ; $i++ ) {

            # ... you enter in this for loop.

            my $slot_distance = $width / ( $num_of_outputs - 1 );
            my $center_y      = $y2;
            my $center_x      = $x1 + $slot_distance * $i;

            $self->add_output(
                center_y => $center_y,
                center_x => $center_x,
                slot     => $input[$i],
            );
        }
    }

    #-------------------------------------------------------------------------

    $self->default_tk_bindings;

    return $self;
}

# return $input : PNI::GUI::Tk::Slot::In
sub add_input {
    my $self = shift;

    my $slot = PNI::GUI::Tk::Slot::In->new(
        @_,
        controller => $self->get_controller,
        node       => $self,
    ) or return PNI::Error::unable_to_create_item;

    my $slot_tk_id = $slot->get_tk_id;
    $self->add_tk_id($slot_tk_id);
    $self->get('input')->{$slot_tk_id} = $slot;
}

# return $output : PNI::GUI::Tk::Slot::Out
sub add_output {
    my $self = shift;

    my $slot = PNI::GUI::Tk::Slot::Out->new(
        @_,
        controller => $self->get_controller,
        node       => $self,
    ) or return PNI::Error::unable_to_create_item;

    my $slot_tk_id = $slot->get_tk_id;
    $self->add_tk_id($slot_tk_id);
    $self->get('output')->{$slot_tk_id} = $slot;
}

sub default_tk_bindings {
    my $self = shift;
    my $text = $self->get_text;

    $text->on_b1_motion( sub { $self->move } );
    $text->on_double_button_1(
        sub {
            $self->get_controller->add_node_inspector( node => $self );
        }
    );
    $text->on_enter( sub { $self->show_info } );
    $text->on_leave(undef);

    for my $slot ( $self->get_inputs, $self->get_outputs ) {
        $slot->default_tk_bindings;
    }
}

# return $border : PNI::GUI::Tk::Canvas::Rectangle
sub get_border { shift->get('border') }

sub get_input {
    my $self      = shift;
    my $slot_name = shift;

    for my $slot ( $self->get_inputs ) {
        next unless $slot->get_name eq $slot_name;
        return $slot;
    }
}

# return @input_tk_ids
sub get_input_tk_ids { keys %{ shift->get('input') } }

# return @inputs : PNI::GUI::Tk::Slot::In
sub get_inputs { values %{ shift->get('input') } }

sub get_output {
    my $self      = shift;
    my $slot_name = shift;

    for my $slot ( $self->get_outputs ) {
        next unless $slot->get_name eq $slot_name;
        return $slot;
    }
}

# return @output_tk_ids
sub get_output_tk_ids { keys %{ shift->get('output') } }

# return @outputs : PNI::GUI::Tk::Slot::Out
sub get_outputs { values %{ shift->get('output') } }

# return $text : PNI::GUI::Tk::Canvas::Text
sub get_text { shift->get('text') }

sub hide_info {
    my $self = shift;

    #    my $tk_info_label_id = shift;

#    $self->get_controller->get_canvas->get_tk_canvas->delete($tk_info_label_id);

    #    $self->default_tk_bindings;
    my $info = $self->get('info');
}

sub move {
    my $self      = shift;
    my $center_y  = $self->get_center_y;
    my $center_x  = $self->get_center_x;
    my $tk_canvas = $self->get_controller->get_canvas->get_tk_canvas;

    $self->get_border->on_enter(undef);
    $self->get_border->on_leave(undef);

    # TODO per evitare che esca dai bordi
    #my ( $x1, $y1, $x2, $y2 ) = $tk_canvas->coords( $self->id );

    my $y = $tk_canvas->XEvent->y;
    my $x = $tk_canvas->XEvent->x;

    my $dx = $x - $center_x;
    my $dy = $y - $center_y;

    # Avoid going outside canvas borders.
    # TODO can be improved
    return if $x + $dx < 1;
    return if $y + $dy < 1;

    $tk_canvas->move( $_, $dx, $dy ) for ( $self->get_tk_ids );

    $self->set_center_y($y);
    $self->set_center_x($x);

    for my $slot ( $self->get_inputs ) {
        my $center_y = $slot->get_center_y;
        my $center_x = $slot->get_center_x;

        $slot->set_center_y( $center_y + $dy );
        $slot->set_center_x( $center_x + $dx );

        if ( my $edge = $slot->get_edge ) {
            $edge->set_end_y( $center_y + $dy );
            $edge->set_end_x( $center_x + $dx );
        }
    }

    for my $slot ( $self->get_outputs ) {
        my $center_y = $slot->get_center_y;
        my $center_x = $slot->get_center_x;

        $slot->set_center_y( $center_y + $dy );
        $slot->set_center_x( $center_x + $dx );

        for my $edge ( $slot->get_edges ) {
            $edge->set_start_y( $center_y + $dy );
            $edge->set_start_x( $center_x + $dx );
        }
    }
}

sub show_info {
    my $self      = shift;
    my $tk_canvas = $self->get_controller->get_canvas->get_tk_canvas;
    my $y         = $self->get_center_y;
    my $x         = $self->get_center_x + 10 + $self->get_width / 2;

    # Get info.
    my $node = $self->get_node;

    my $id      = $node->id;
    my $inputs  = join ',', @{ $node->get('inputs_order') };
    my $outputs = join ',', @{ $node->get('outputs_order') };
    my $type    = $node->get_type;

    my $text = qq{
type: $type
id  : $id
inputs  : $inputs
outputs : $outputs
    };

    #my $tk_info_label_id =
    #  $tk_canvas->createText( $x, $y, -anchor=>'w',text => $self->get_info, );

    #my $info = $self->add_text( $x, $y, -anchor => 'w', text => $text, );

    #$self->set( info => $info );

    $self->get_text->on_enter(undef);
    $self->get_border->on_leave( sub { $self->hide_info } );
}

1
__END__

=head1 NAME

PNI::GUI::Tk::Node - default node view

=head1 METHODS

=head2 C<add_input>

=head2 C<add_output>

=head2 C<add_tk_id>

=head2 C<default_tk_bindings>

=head2 C<get_border>

=head2 C<get_text>

=head2 C<move>

=head2 C<show_input_info>

=head2 C<show_output_info>

=cut

