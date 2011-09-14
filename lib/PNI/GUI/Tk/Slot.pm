package PNI::GUI::Tk::Slot;
use parent qw( PNI::GUI::Slot PNI::GUI::Tk::View );
use strict;
use PNI::Error;

sub new {
    my $self = shift->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;
    my $arg = {@_};

    $self->init_view(@_);

    # $half_side defaults to 4
    my $half_side = $arg->{half_side} || 4;
    $self->add( half_side => $half_side );

    my $canvas        = $self->get_controller->get_canvas;
    my $center_y = $self->get_center_y;
    my $center_x = $self->get_center_x;
    my $tk_canvas     = $canvas->get_tk_canvas;
    my $y1            = $center_y - $half_side;
    my $y2            = $center_y + $half_side;
    my $x1            = $center_x - $half_side;
    my $x2            = $center_x + $half_side;
    my @border_config = qw( -activefill black -fill gray );

    my $border = PNI::GUI::Tk::Canvas::Rectangle->new(
        canvas => $canvas,
        y1     => $y1,
        y2     => $y2,
        x1     => $x1,
        x2     => $x2,
    ) or return PNI::Error::unable_to_create_item;
    $border->configure(@border_config);

    # TODO verifica se serve mettere l'id del node o si puo mettere il self id
    #      oppure addirittura non serve neanche
    my $node = $self->get_node;
    $tk_canvas->addtag( $node->id, 'withtag', $border->get_tk_id );
    $self->add( tk_id  => $border->get_tk_id );
    $self->add( border => $border );

    return $self;
}

# return $border : PNI::GUI::Tk::Canvas::Rectangle
sub get_border { shift->get('border') }

sub get_info {
    my $self = shift;
    my $slot = $self->get_slot;

    my $data;

    if ( $slot->is_defined ) {
        $data = $slot->get_data;
    }
    else { $data = 'UNDEF' }

    return $slot->get_name . ' : ' . $data;
}

sub get_tk_id { shift->get('tk_id') }

sub hide_info {
    my $self             = shift;
    my $tk_info_label_id = shift;

    $self->get_controller->get_canvas->get_tk_canvas->delete($tk_info_label_id);

    $self->get_border->on_leave(undef);
}

1
__END__

=head1 NAME

PNI::GUI::Tk::Slot

=head1 METHODS

=head2 C<hide_info>

=cut

