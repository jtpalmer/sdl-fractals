use strict;
use warnings;
use SDL;
use SDL::Video;
use SDL::Events ':all';
use SDLx::App;

my $title  = 'Mandelbrot Fractal';
my $width  = 640;
my $height = 480;
my $view   = [ -2, 1, -1, 1 ]; # [ min_x, $max_x, $min_y, $max_y]

sub mandelbrot {
    my ($r, $i) = @_;

    my ($r0, $i0) = ($r, $i);

    my $n = 0;
    while ($n < 255 && $r * $r + $i * $i < 2) {
        my $x = $r * $r - $i * $i + $r0;
        my $y = 2 * $r * $i + $i0;
        ($r, $i) = ($x, $y);
        $n++;
    }

    return $n;
}

{
    my ($min_x, $max_x, $min_y, $max_y) = @$view;

    my $scale_x = ($max_x - $min_x) / $width;
    my $scale_y = ($max_y - $min_y) / $height;

    sub translate {
        my ($x, $y) = @_;

        return ( $min_x + $scale_x * $x, $min_y + $scale_y * $y );
    }
}

my $app = SDLx::App->new(
	title  => $title,
	width  => $width,
	height => $height,
);

my $format = $app->surface->format;
my @palette = map { SDL::Video::map_RGB( $format, $_, $_, $_ ) } 0 .. 255;

foreach my $y ( 0 .. $height - 1 ) {
	foreach my $x ( 0 .. $width - 1 ) {
        $app->[$x][$y] = $palette[mandelbrot(translate($x, $y))];
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
