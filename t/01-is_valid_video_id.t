use strict;

use warnings;

use Test::More tests => 3;

use App::TvpotDl;

my $video_id;

$video_id = 'Rw_rswoFVm0$';
ok( App::TvpotDl::is_valid_video_id($video_id), $video_id );

$video_id = 'Kp7b2f1YR_Q$';
ok( App::TvpotDl::is_valid_video_id($video_id), $video_id );

$video_id = 'Invalid video ID';
ok( !App::TvpotDl::is_valid_video_id($video_id), $video_id );
