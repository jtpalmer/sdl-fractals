use strict;
use warnings;
use SDL;
use SDL::Video;
use SDL::Events ':all';
use SDLx::App;
use Math::Fractal::Julia;

my $title  = 'Julia Fractal';
my $width  = 640;
my $height = 480;
my $view   = [ -2.0, -1.5, 2.0, 1.5 ];    # [ min_x, $min_y, $max_x, $max_y]

Math::Fractal::Julia->set_max_iter(255);
Math::Fractal::Julia->set_bounds( @$view, $width, $height );

# See http://en.wikipedia.org/wiki/File:Julia_set_%28ice%29.png
Math::Fractal::Julia->set_constant( -0.726895347709114071439,
    0.188887129043845954792 );

my $app = SDLx::App->new(
    title  => $title,
    width  => $width,
    height => $height,
    depth  => 32,
);

my $format = $app->surface->format;
my @palette
    = map { SDL::Video::map_RGB( $format, $_, $_, $_ ) } reverse 0 .. 255;
$palette[0] = SDL::Video::map_RGB( $format, 0, 0, 0 );

foreach my $y ( 0 .. $height - 1 ) {
    foreach my $x ( 0 .. $width - 1 ) {
        my $v = Math::Fractal::Julia->point( $x, $height - $y - 1 );
        $app->[$x][$y] = $palette[$v];
    }
    $app->update;
}
$app->update;

$app->add_event_handler(
    sub {
        my ($event) = @_;
        return 0 if $event->type == SDL_QUIT;
        return 0 if $event->key_sym == SDLK_ESCAPE;
        return 1;
    }
);

$app->run;
