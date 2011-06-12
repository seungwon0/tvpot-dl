use strict;

use warnings;

use Test::More tests => 4;

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

$url = 'http://media.daum.net/entertain/showcase/singer/mission?id=605#83';
$got = App::TvpotDl::get_video_id($url);
$expected = 'VA_y85BYuE4$';

is( $got, $expected, "Get video id from $url" );
