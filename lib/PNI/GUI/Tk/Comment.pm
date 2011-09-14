package PNI::GUI::Tk::Comment;
use parent qw( PNI::GUI::Comment PNI::GUI::Tk::View );
use strict;
use PNI::Error;
use PNI::GUI::Tk::Canvas::Text;

sub new {
    my $self = shift->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;
    my $arg = {@_};

    $self->init_view(@_);

    my $canvas = $self->get_controller->get_canvas;

    my $canvas_text = PNI::GUI::Tk::Canvas::Text->new(
        canvas => $canvas,
        text   => $self->get_content,
        y      => $self->get_center_y,
        x      => $self->get_center_x,
    ) or return PNI::Error::unable_to_create_item;

    $self->add( canvas_text => $canvas_text );

    $self->default_tk_bindings;

    return $self;
}

sub default_tk_bindings {
    my $self       = shift;
    my $canvas_text = $self->get_canvas_text;
    my $controller = $self->get_controller;
    my $tk_canvas  = $controller->get_canvas->get_tk_canvas;

    $canvas_text->on_b1_motion( sub { $self->move } );
    $canvas_text->on_double_button_1(
        sub {
            $controller->del_comment($self);
            $controller->add_comment_editor(
                entry => $self->get_content,
                y     => $self->get_center_y,
                x     => $self->get_center_x,
            );
        }
    );
}

sub get_canvas_text { shift->get('canvas_text') }

sub move {
    my $self      = shift;
    my $center_y  = $self->get_center_y;
    my $center_x  = $self->get_center_x;
    my $tk_canvas = $self->get_controller->get_canvas->get_tk_canvas;

    my $y = $tk_canvas->XEvent->y;
    my $x = $tk_canvas->XEvent->x;

    my $dx = $x - $center_x;
    my $dy = $y - $center_y;

    # avoid going outside canvas borders
    # TODO can be improved
    return if $x + $dx < 1;
    return if $y + $dy < 1;

    my $canvas_text_tk_id = $self->get_canvas_text->get_tk_id;
    $tk_canvas->move( $canvas_text_tk_id, $dx, $dy );

    $self->set_center_y($y);
    $self->set_center_x($x);

}

1
__END__

=head1 NAME 

PNI::GUI::Tk::Comment

=cut

