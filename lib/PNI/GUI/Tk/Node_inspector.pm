package PNI::GUI::Tk::Node_inspector;
use parent qw( PNI::Item PNI::GUI::Tk::View );
use strict;
use PNI::GUI::Tk::Canvas::Window;
use Tk::Toplevel;

sub new {
    my $self = shift->SUPER::new;
    my $arg  = {@_};

    $self->init_view(@_);

    my $controller = $self->get_controller;

    # TODO controlla che dovrebbe essere PNI::GUI::Tk::Node
    my $node = $arg->{node};
    $self->add( node => $node );

    my $canvas = $controller->get_canvas;
    my $frame = $canvas->get_tk_canvas->Labelframe( -text => $node->get_type );

    my $button = $frame->Button(
        -text    => 'Del',
        -command => sub {
            $controller->del_node_inspector;
            $controller->del_node($node);
        }
    );
    $button->pack( -anchor=>'n', -expand => 0 );

    # TODO deve essere editabile
    #my $label = $frame->Label( -text => $node->get_label );
    #$label->pack( -side => 'top' );

    my $inputs =
      $frame->Labelframe( -text => 'Inputs' )->pack( -anchor => 'w', );

    for my $input ( $node->get_inputs ) {

        # TODO dovrebbe chiedere all' input qual'è il suo inspector
        # vedi PNI::GUI::Tk::Slot::In
        $inputs->Label( -text => $input->get_name )->pack( -anchor => 'w' );

        my $slot  = $input->get_slot;
        my $data  = $slot->get_data;
        my $entry = $inputs->Entry( -text => $data );
        $entry->pack( -anchor => 'e' );
        $entry->bind(
            '<Return>' => sub {
                $slot->set_data( $entry->get );
            }
        );
    }

    my $outputs =
      $frame->Labelframe( -text => 'Outputs' )->pack( -anchor => 'w', );

    for my $output ( $node->get_outputs ) {

        my $slot = $output->get_slot;

        $outputs->Label( -text => $output->get_name )->pack( -anchor => 'w' );

        my $text = $slot->get_data;

        $outputs->Entry(
            -text  => $text,
            -state => 'readonly',
        )->pack( -anchor => 'e' );
    }

    $self->add(

        window => PNI::GUI::Tk::Canvas::Window->new(
            canvas => $canvas,
            window => $frame,
            y      => $self->get_node->get_center_y,
            x      => $self->get_node->get_center_x,
          )

    );

    $self->default_tk_bindings;

    return $self;
}

sub default_tk_bindings {
    my $self = shift;
}

# return $node : PNI::Node
sub get_node { shift->get('node') }

# return $window : PNI::GUI::Tk::Window
sub get_window { return shift->get('window') }

1
__END__

=head1 NAME

PNI::GUI::Tk::Node_inspector

=cut

