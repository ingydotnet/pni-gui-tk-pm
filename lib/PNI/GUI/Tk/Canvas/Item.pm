package PNI::GUI::Tk::Canvas::Item;
use parent 'PNI::Item';
use strict;
use PNI;
use PNI::Error;

sub new {
    my $class = shift;
    my $arg   = {@_};
    my $self  = $class->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;

    # $canvas is required
    my $canvas = $arg->{canvas}
      or return PNI::Error::missing_required_argument;

    # $canvas must be a PNI::GUI::Tk::Canvas
    $canvas->isa('PNI::GUI::Tk::Canvas')
      or return PNI::Error::invalid_argument_type;

    $self->add( canvas => $canvas );

    $self->add('node');

    $self->add('tk_id');

    return $self;
}

sub _bind {
    my $self  = shift;
    my $event = shift;
    if ( my $code_ref = shift ) {

        ref $code_ref eq 'CODE'
          or return PNI::Error::invalid_argument_type;

        $self->get_tk_canvas->bind( $self->get_tk_id,
            $event => [ $code_ref, @_ ] );

    }
    else {
        $self->get_tk_canvas->bind( $self->get_tk_id, $event => undef );
    }
}

sub cget {
    my $self   = shift;
    my $option = shift
      or return PNI::Error::missing_required_argument;

    return $self->get_tk_canvas->itemcget( $self->get_tk_id, $option );
}

sub configure {
    my $self = shift;
    $self->get_tk_canvas->itemconfigure( $self->get_tk_id, @_ );
}

sub delete {
    my $self = shift;
    $self->get_tk_canvas->delete( $self->get_tk_id );
}

# return $canvas : PNI::GUI::Tk::Canvas
sub get_canvas { shift->get('canvas') }

sub get_node { shift->get('node') }

# return $tk_canvas : Tk::Canvas
sub get_tk_canvas { shift->get_canvas->get_tk_canvas }

# TODO dovra essere cosi quando tutti gli item avranno il proprio nodo
# sub get_tk_id { shift->get_node->get_output('tk_id')->get_data }
sub get_tk_id { shift->get('tk_id') }

sub on_b1_motion { shift->_bind( '<B1-Motion>', @_ ) }

sub on_buttonpress_1 { shift->_bind( '<ButtonPress-1>',@_) }

sub on_buttonrelease_1 { shift->_bind( '<ButtonRelsease-1>',@_) }

sub on_double_button_1 { shift->_bind( '<Double-Button-1>', @_ ) }

sub on_enter { shift->_bind( '<Enter>', @_ ) }

sub on_leave { shift->_bind( '<Leave>', @_ ) }

sub set_node {
    my $self = shift;
    my $node = shift;

    # Every PNI::Node::Tk::Canvas::* has a canvas input.
    $node->get_input('canvas')->set_data( $self->get_tk_canvas );

    $node->task;

    $self->set( node => $node );
}

sub DESTROY {
    my $self = shift;
    PNI::root->del_node( $self->get_node );
}

1
__END__

=head1 NAME

PNI::GUI::Tk::Canvas::Item - Tk::Canvas item base class

=head1 METHODS

=head2 C<configure>

=head2 C<delete>

=head2 C<get_canvas>

=head2 C<get_tk_id>

=head2 C<on_b1_motion>

=head2 C<on_buttonpress_1>

=head2 C<on_enter>

=head2 C<on_leave>

=head2 C<set_node>

=cut

