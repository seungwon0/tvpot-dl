use strict;

use warnings;

use Test::More tests => 5;

use App::TvpotDl;

my $url;
my $got;
my $expected;

$url      = 'http://tvpot.daum.net/clip/ClipView.do?clipid=29772622';
$got      = App::TvpotDl::get_video_id($url);
$expected = '3i5f_JquGsk$';

is( $got, $expected, "Get video id from $url" );

$url      = 'http://tvpot.daum.net/best/Top.do?from=gnb#clipid=31946003';
$got      = App::TvpotDl::get_video_id($url);
$expected = 'eAC1A0PSnz4$';

is( $got, $expected, "Get video id from $url" );

$url      = 'http://tvpot.daum.net/story/StoryView.do?storyid=508';
$got      = App::TvpotDl::get_video_id($url);
$expected = '2oHFG_aR9uA$';

is( $got, $expected, "Get video id from $url" );

$url = 'http://music.daum.net/song/songVideo.do?songId=8443911&videoId=8446';
$got = App::TvpotDl::get_video_id($url);
$expected = '_nACjJ65nKg$';

is( $got, $expected, "Get video id from $url" );

$url = 'http://tvpot.daum.net/best/ThemeBest.do#themeid=5014&clipid=42907566'
    . '?lu=nt_t_three_clip_3_minithumbnail';
$got      = App::TvpotDl::get_video_id($url);
$expected = 'v9e2bzVuwVMM1VecpMquvpv';

is( $got, $expected, "Get video id from $url" );
