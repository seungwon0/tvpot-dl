use Test::More tests => 1;

use App::TvpotDl;

my $video_id = '3i5f_JquGsk$';
my $got	     = App::TvpotDl::get_movie_url($video_id);
my $expected = 'http://stream.tvpot.daum.net/swxwT-/InNM6w/JgEM-E/OxDQ$$.flv';

is($got, $expected, 'get_movie_url subroutine test');
