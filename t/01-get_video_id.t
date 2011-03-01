use strict;

use warnings;

use Test::More tests => 1;

use App::TvpotDl;

my $url	     = 'http://tvpot.daum.net/clip/ClipView.do?clipid=29772622';
my $got	     = App::TvpotDl::get_video_id($url);
my $expected = '3i5f_JquGsk$';

is($got, $expected, 'get_video_id subroutine test');
