use Test::More tests => 1;

use App::TvpotDl;

my $video_id = 'pUxTIeXTm5A$';
my $got	     = App::TvpotDl::get_video_title($video_id);
my $expected = 'Just The Way You Are';

is($got, $expected, 'get_video_title subroutine test');
