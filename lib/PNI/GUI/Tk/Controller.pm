package PNI::GUI::Tk::Controller;
use parent 'PNI::Item';
use strict;
use PNI;
use PNI::Error;
use PNI::File;
use PNI::GUI::Tk::Canvas;
use PNI::GUI::Tk::Edge;
use PNI::GUI::Tk::Menu;
use PNI::GUI::Tk::Node;
use PNI::GUI::Tk::Node_inspector;
use PNI::GUI::Tk::Node_selector;
use PNI::GUI::Tk::Scenario;
use PNI::GUI::Tk::Window;

sub new {
    my $self = shift->SUPER::new;
    my $arg  = {@_};

    # app is required
    my $app = $arg->{app}
      or return PNI::Error::missing_required_argument;

    # app must be a PNI::GUI::Tk::App
    $app->isa('PNI::GUI::Tk::App')
      or return PNI::Error::invalid_argument_type;

    $self->add( app => $app );

    # Create window.
    my $window = PNI::GUI::Tk::Window->new( controller => $self );
    $self->add( window => $window );

    # Create menu.
    $self->add( menu => PNI::GUI::Tk::Menu->new( controller => $self ) );

    # Create canvas.
    $self->add(
        canvas => PNI::GUI::Tk::Canvas->new(
            controller => $self,
            tk_canvas  => $window->get_tk_main_window->Canvas(),
        )
    );

    # Create scenario.
    my $scenario = PNI::GUI::Tk::Scenario->new(
        controller => $self,
        file       => $arg->{file},

        # TODO by now i'm using the root scenario
        scenario => PNI::root->add_scenario,
    ) or return PNI::Error::unable_to_create_item;

    $self->add( scenario => $scenario );

    # Set window title with .pni file path.
    $self->set_window_title( $scenario->get_file->get_path );

    # Load the content of the .pni file.
    $self->get_scenario->load_file;

    return $self
}

sub add_comment {
    my $self = shift;

    # Delete node_selector if it exists.
    $self->del_node_selector if $self->has('node_selector');

    $self->get_scenario->add_comment(@_);
}

sub add_comment_editor {
    my $self    = shift;
    my $comment = shift
      or return PNI::Error::missing_required_argument;

    print "TODO : comment editor for $comment\n";

    #my $comment_editor = PNI::GUI::Tk::Comment_editor->new();
}

# return $node : PNI::GUI::Tk::Node
sub add_node {
    my $self = shift;

    # Delete node_selector if it exists.
    $self->del_node_selector if $self->has('node_selector');

    return $self->get_scenario->add_node(@_);
}

sub add_node_inspector {
    my $self = shift;

    my $node_inspector = PNI::GUI::Tk::Node_inspector->new(
        controller => $self,
        @_
    ) or return PNI::Error::unable_to_create_item;

    $self->add( node_inspector => $node_inspector );

    $self->get_canvas->opened_node_inspector;
}

sub add_node_selector {
    my $self = shift;

    my $node_selector = PNI::GUI::Tk::Node_selector->new(
        controller => $self,
        @_
    ) or return PNI::Error::unable_to_create_item;

    $self->add( node_selector => $node_selector );

    $self->get_canvas->opened_node_selector;
}

# TODO sarebbe del_window
sub close_window {
    my $self = shift;
    my $app  = $self->get_app;

    $self->get_tk_main_window->destroy;

    $app->del_controller($self);
}

sub connect_edge_to_input {
    my $self = shift;

    my $edge = shift
      or return PNI::Error::missing_required_argument;

    my $input = shift
      or return PNI::Error::missing_required_argument;

    my $canvas = $self->get_canvas;

    if ( $input->is_connected ) {
        my $old_edge = $input->get_edge;
        $self->del_edge($old_edge);
    }

    $edge->set_target($input);
    $input->set_edge($edge);

    $self->default_tk_bindings;
}

sub connect_edge_to_output {
    my $self = shift;
    my $edge = shift
      or return PNI::Error::missing_required_argument;
    my $output = shift
      or return PNI::Error::missing_required_argument;

    my $canvas = $self->get_canvas;

    $edge->set_source($output);
    $output->add_edge($edge);
}

sub connecting_edge {
    my $self = shift;

    my $output = shift
      or return PNI::Error::missing_required_argument;

# TODO non mi sembra molto elegante questo metodo, sicuramente si puo migliorare o anche eliminare

    my $y = $output->get_center_y;
    my $x = $output->get_center_x;

    my $edge = $self->get_scenario->add_edge(
        end_y   => $y,
        end_x   => $x,
        start_y => $y,
        start_x => $x,
    );
    $self->connect_edge_to_output( $edge, $output );
    $self->get_canvas->connecting_edge_tk_bindings($edge);
}

sub default_tk_bindings {
    my $self     = shift;
    my $canvas   = $self->get_canvas;
    my $scenario = $self->get_scenario;

    $canvas->default_tk_bindings;

    for my $slot ( $scenario->get_inputs, $scenario->get_outputs ) {
        $slot->default_tk_bindings;
    }
}

sub del_comment {
    my $self    = shift;
    my $comment = shift
      or return PNI::Error::missing_required_argument;

    print "TODO del comment $comment\n";
}

sub del_edge {
    my $self = shift;
    my $edge = shift
      or return PNI::Error::missing_required_argument;

    my $source = $edge->get_source;
    my $target = $edge->get_target;

    defined $source and $source->del_edge($edge);
    defined $target and $target->del_edge($edge);

    $self->get_scenario->del_edge($edge);

    $edge->get_line->delete;

    $self->default_tk_bindings;
}

sub del_node {
    my $self = shift;
    my $node = shift
      or return PNI::Error::missing_required_argument;

    my $scenario  = $self->get_scenario;
    my $tk_canvas = $self->get_tk_canvas;

    # Delete all edges first.
    for my $input ( $node->get_inputs ) {
        my $edge = $input->get_edge;
        next unless $edge;
        $self->del_edge( $edge );
    }
    for my $output ( $node->get_outputs ) {
        for my $edge ( $output->get_edges ) {
            $self->del_edge($edge);

            #TODO usa i grep map ecc
        }
    }

    # TODO sarebbe da mettere in PNI::GUI::Tk::Canvas::Group
    # piu che altro dentro il del_node dello scenario
    $tk_canvas->delete($_) for ( $node->get_tk_ids );

    $scenario->del_node($node);

    $self->default_tk_bindings;
}

sub del_node_inspector {
    my $self           = shift;
    my $canvas         = $self->get_canvas;
    my $node_inspector = $self->get_node_inspector;

    my $tk_canvas = $self->get_tk_canvas;
    my $window    = $node_inspector->get_window;
    my $tk_id     = $window->get_tk_id;
    $tk_canvas->delete($tk_id);

    $self->del('node_inspector');

    $canvas->default_tk_bindings;
}

sub del_node_selector {
    my $self          = shift;
    my $canvas        = $self->get_canvas;
    my $node_selector = $self->get_node_selector;

    my $tk_canvas = $self->get_tk_canvas;
    my $window    = $node_selector->get_window;
    my $tk_id     = $window->get_tk_id;
    $tk_canvas->delete($tk_id);

    $self->del('node_selector');

    $canvas->default_tk_bindings;
}

sub get_app { shift->get('app') }

sub get_canvas { shift->get('canvas') }

sub get_node_inspector { shift->get('node_inspector') }

sub get_node_selector { shift->get('node_selector') }

sub get_tk_canvas { shift->get_canvas->get_tk_canvas }

sub get_tk_main_window { shift->get_window->get_tk_main_window }

sub get_scenario { shift->get('scenario') }

sub get_window { shift->get('window') }

sub open_pni_file {
    my $self = shift;

    my $path =
      $self->get_tk_main_window->getOpenFile( -title => 'Open .pni file', )
      or return;

    $self->get_app->add_controller( file => PNI::File->new( path => $path ) );
}

sub save_pni_file {
    my $self     = shift;
    my $scenario = $self->get_scenario;
    return $scenario->save_file
}

sub save_as_pni_file {
    my $self     = shift;
    my $scenario = $self->get_scenario;

    my $path =
      $self->get_tk_main_window->getSaveFile( -title => 'Save as .pni file', );

    $scenario->set_file( PNI::File->new( path => $path ) );
    $scenario->save_file;
}

sub select_edge {

    #print @_, "\n";
}

sub set_window_title {
    my $self  = shift;
    my $title = shift
      or return PNI::Error::missing_required_argument;

    my $window = $self->get_window;
    return $window->set_title($title)
}

sub new_window { shift->get_app->add_controller }

1
__END__

=head1 NAME

PNI::GUI::Tk::Controller - 

=head1 METHODS

=head2 C<close_window>

    $self->close_window;

Close Tk window and delete controller.

=head2 C<save_as_pni_file>

    $self->save_as_pni_file;

Opens a Tk getSaveFile window to let the user choose a path, and saves scenario content.

=head2 C<save_pni_file>

    $self->save_pni_file;

Save scenario content in its .pni file.

=cut

