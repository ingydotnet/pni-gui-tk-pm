package PNI::GUI::Tk::Menu;
use parent qw( PNI::Item PNI::GUI::Tk::View );
use strict;

sub new {
    my $self = shift->SUPER::new;
    my $arg  = {@_};

    $self->init_view(@_);

    my $controller = $self->get_controller;
    my $window = $controller->get_window;

    my $tk_window = $window->get_tk_main_window;

    my $tk_menu = $tk_window->Menu( -type => 'menubar' );


    # Attach menu to its window.
    $tk_window->configure( -menu => $tk_menu );

    # Populate menu entries.
    $tk_menu->Cascade(
        -label     => 'Scenario',
        -tearoff   => 1,
        -menuitems => [
            [
                Button   => 'New',
                -command => [ sub { $controller->new_window; } ]
            ],
            [
                Button   => 'Open',
                -command => [ sub { $controller->open_pni_file; } ]
            ],
            [
                Button   => 'Save',
                -command => [ sub { $controller->save_pni_file; } ]
            ],
            [
                Button   => 'Save as',
                -command => [ sub { $controller->save_as_pni_file; } ]
            ],
            [
                Button   => 'Close',
                -command => [ sub { $controller->close_window; } ]
            ],
            [
                Button   => 'Exit',
                -command => [ sub { Tk::exit(); } ]
            ]
        ]
    );
    $tk_menu->Cascade(
        -label     => '~Help',
        -tearoff   => 0,
        -menuitems => [
            [
                Button   => 'About',
                -command => [
                    sub {
                        my $info_window = $tk_window->Toplevel(
                            -title => 'Perl Node Interface' );
                        $info_window->geometry('200x150+100+100');
                        $info_window->Label( -text => $_ )
                          ->pack( -anchor => 'w' )
                          for (
                            'PNI version: ' . $PNI::VERSION,
                            'PNI::GUI::Tk version: ' . $PNI::GUI::Tk::VERSION,
                            'For more info point your browser to',
                            'http://perl-node-interface.blogspot.com'
                          );
                        $info_window->resizable( 0, 0 );
                      }
                ]
            ]
        ]
    );

    ### new: __PACKAGE__ . ' id=' . $self->id
    return $self;
}

1;
__END__

=head1 NAME

PNI::GUI::Tk::Menu 

=cut

