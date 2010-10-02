use strict;
use warnings;
use SDL;
use SDL::Video;
use SDL::Events ':all';
use SDLx::App;
use Math::Fractal::Mandelbrot;

my $title  = 'Mandelbrot Fractal';
my $width  = 640;
my $height = 480;
my $view   = [ -2, -1, 1, 1 ];       # [ min_x, $min_y, $max_x, $max_y]

Math::Fractal::Mandelbrot->set_max_iter(255);
Math::Fractal::Mandelbrot->set_bounds( @$view, $width, $height );

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
        $app->[$x][$y]
            = $palette[ Math::Fractal::Mandelbrot->point( $x, $y ) ];
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
