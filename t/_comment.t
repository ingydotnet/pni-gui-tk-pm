use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Comment;
use PNI::GUI::Tk::Controller;
use Test::More;

my $app = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );

my $center_y = 10;
my $center_x = 10;
my $content  = 'This is a comment';

my $comment = PNI::GUI::Tk::Comment->new(
    center_y   => $center_y,
    center_x   => $center_x,
    controller => $controller,
    content    => $content,
);
isa_ok $comment, 'PNI::GUI::Tk::Comment';

done_testing;
__END__

