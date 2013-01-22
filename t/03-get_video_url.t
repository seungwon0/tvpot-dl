use strict;

use warnings;

use Test::More tests => 2;

use App::TvpotDl;

my $video_id;
my $got;
my $expected;

$video_id = 'XcqpEg8DZZM$';
$got      = App::TvpotDl::get_video_url($video_id);
$expected = qr{ / movie[.]flv $ }xmsi;

like( $got, $expected, "Get video URL for '$video_id'" );

$video_id = 'v9cabllzXMQ5lfzPQle7moq';
$got      = App::TvpotDl::get_video_url($video_id);
$expected = qr{ / movie[.]mp4 $ }xmsi;

like( $got, $expected, "Get video URL for '$video_id'" );
