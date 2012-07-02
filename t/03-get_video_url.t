use strict;

use warnings;

use Test::More tests => 2;

use App::TvpotDl;

my $video_id;
my $got;
my $expected;

$video_id = 'XcqpEg8DZZM$';
$got      = App::TvpotDl::get_video_url($video_id);
$expected = qr{^ http:// [\d.]+ /daumblog/1001/3/45872803[.]flv $}xmsi;

like( $got, $expected, "Get video URL for '$video_id'" );

$video_id = 'v9cabllzXMQ5lfzPQle7moq';
$got      = App::TvpotDl::get_video_url($video_id);
$expected
    = 'http://cdn.videofarm.daum.net/videofarm/v9c/ab/'
    . 'v9cabllzXMQ5lfzPQle7moq/mp4_360P_1M_T1.mp4'
    . '?px-bps=1470707&px-bufahead=10';
is( $got, $expected, "Get video URL for '$video_id'" );
