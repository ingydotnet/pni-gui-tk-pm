package PNI::GUI::Tk::Window;
use parent qw( PNI::Item PNI::GUI::Tk::View );
use strict;
use PNI;
use PNI::Error;

sub new {
    my $self = shift->SUPER::new;

    $self->init_view(@_);

    # It is necessary to use a PNI::Node::Tk::MainWindow
    # so PNI loop and Tk mainloop can coexist
    my $main_window_node = PNI::node 'Tk::MainWindow';

    my $tk_main_window = $main_window_node->get_output('object')->get_data;

    $tk_main_window->protocol( 'WM_DELETE_WINDOW',
        sub { $self->get_controller->close_window; } );

    $self->add( tk_main_window => $tk_main_window );

    # TODO add key bindings
    #$self->default_tk_bindings;

    return $self;
}

sub default_tk_bindings {
    my $self           = shift;
    my $tk_main_window = $self->get_tk_main_window;

    $tk_main_window->bind(
        '<Any-KeyPress>' => sub {
            my ($c) = @_;
            my $e = $c->XEvent;
            my ( $x, $y, $W, $K, $A ) = ( $e->x, $e->y, $e->K, $e->W, $e->A );

            print "A key was pressed:\n";
            print "  x = $x\n";
            print "  y = $y\n";
            print "  W = $K\n";
            print "  K = $W\n";
            print "  A = $A\n";
        }
    );
}

# return $tk_main_window : Tk::MainWindow
sub get_tk_main_window { shift->get('tk_main_window') }

sub set_title {
    my $self  = shift;
    my $title = shift
      or return PNI::Error::missing_required_argument;

    $self->get_tk_main_window->title($title);
}

1;
__END__

=head1 NAME

PNI::GUI::Tk::Window

=head1 METHODS

=head2 C<get_tk_main_window>

=cut

