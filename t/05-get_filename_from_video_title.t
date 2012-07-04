use strict;

use warnings;

use Test::More tests => 4;

use App::TvpotDl;

my $video_title;
my $extension;
my $got;
my $expected;

$video_title = ' white spaces in video title  ';
$extension   = 'flv';
$got
    = App::TvpotDl::get_filename_from_video_title( $video_title, $extension );
$expected = 'white_spaces_in_video_title.flv';

is( $got, $expected, 'White spaces in video title' );

$video_title = 'abc/\?%*:|"<>.';
$extension   = 'flv';
$got
    = App::TvpotDl::get_filename_from_video_title( $video_title, $extension );
$expected = 'abc.flv';

is( $got, $expected, 'Reserved characters in video title' );

$video_title = 'title';
$extension   = 'mp4';
$got
    = App::TvpotDl::get_filename_from_video_title( $video_title, $extension );
$expected = 'title.mp4';

is( $got, $expected, '.mp4 extension' );

$video_title = '__a__b__c__';
$extension   = 'mp4';
$got
    = App::TvpotDl::get_filename_from_video_title( $video_title, $extension );
$expected = 'a_b_c.mp4';

is( $got, $expected, q{Repeated '_'} );
