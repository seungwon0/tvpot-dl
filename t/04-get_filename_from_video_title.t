use strict;

use warnings;

use utf8;

use Test::More tests => 2;

use App::TvpotDl;

my $video_title;
my $got;
my $expected;

$video_title = ' white spaces in video title  ';
$got	     = App::TvpotDl::get_filename_from_video_title($video_title);
$expected    = 'white_spaces_in_video_title.flv';

is( $got, $expected, 'White spaces in video title' );

$video_title = 'abc/\?%*:|"<>.';
$got	     = App::TvpotDl::get_filename_from_video_title($video_title);
$expected    = 'abc.flv';

is( $got, $expected, ' in video title' );
