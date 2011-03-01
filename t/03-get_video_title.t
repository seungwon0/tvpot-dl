use strict;

use warnings;

use utf8;

use Test::More tests => 2;

use App::TvpotDl;

my $video_id;
my $got;
my $expected;

$video_id = 'pUxTIeXTm5A$';
$got      = App::TvpotDl::get_video_title($video_id);
$expected = 'Just The Way You Are';

is( $got, $expected, 'get_movie_title subroutine test' );

$video_id = 'brVzii5Ivdc$';
$got	  = App::TvpotDl::get_video_title($video_id);
$expected = '아린.비타500메이킹&CF';

is( $got, $expected, 'HTML entity in title' );
