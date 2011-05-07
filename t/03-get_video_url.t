use strict;

use warnings;

use Test::More tests => 1;

use App::TvpotDl;

my $video_id = '3i5f_JquGsk$';
my $got	     = App::TvpotDl::get_video_url($video_id);
my $expected = 'http://stream.tvpot.daum.net/swxwT-/InNM6w/JgEM-E/OxDQ$$.flv';

is($got, $expected, 'get_video_url subroutine test');
