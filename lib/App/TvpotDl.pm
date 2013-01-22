package App::TvpotDl;

use strict;

use warnings;

use English qw< -no_match_vars >;

use LWP::Simple qw< get >;

use Carp qw< carp >;

use HTML::Entities qw< decode_entities >;

use LWP::UserAgent;

=head1 NAME

App::TvpotDl - Download flash videos from Daum tvpot

=head1 VERSION

Version 0.11.5

=cut

our $VERSION = '0.11.5';

=head1 SYNOPSIS

    use App::TvpotDl;

    my $url = 'http://tvpot.daum.net/clip/ClipView.do?clipid=29772622';

    # Get video ID
    my $video_id = App::TvpotDl::get_video_id($url);

    # Get video URL
    my $video_url = App::TvpotDl::get_video_url($video_id);

=head1 SUBROUTINES

=head2 is_valid_video_id

Returns 1 if the given video ID is valid.

=cut

sub is_valid_video_id {
    my ($video_id) = @_;

    return if !defined $video_id;

    return if length $video_id != 12 && length $video_id != 23;

    return if length $video_id == 12 && $video_id !~ /\$ $/xms;

    return 1;
}

=head2 get_video_id

Returns video ID of the given tvpot URL.

=cut

sub get_video_id {
    my ($url) = @_;

    return if !defined $url;

    # http://tvpot.daum.net/best/Top.do?from=gnb#clipid=31946003
    if ( $url =~ /[#?&] clipid = (?<clip_id> \d+)/xmsi ) {
        $url = 'http://tvpot.daum.net/clip/ClipView.do?clipid='
            . $LAST_PAREN_MATCH{clip_id};
    }

    my $document = get($url);
    if ( !defined $document ) {
        carp "Cannot fetch '$url'";
        return;
    }

    # VodPlayer.swf?vid=3i5f_JquGsk$
    my $video_id_pattern_1
        = qr{VodPlayer[.]swf [?] vid = (?<video_id> .+?) ["'&]}xmsi;

    my $func_name;

    # Story.UI.PlayerManager.createViewer('2oHFG_aR9uA$');
    $func_name = quotemeta 'Story.UI.PlayerManager.createViewer';
    my $video_id_pattern_2 = qr{$func_name [(] ' (?<video_id> .+?) '}xms;

    # daum.Music.VideoPlayer.add("body_mv_player", "_nACjJ65nKg$",
    $func_name = quotemeta 'daum.Music.VideoPlayer.add';
    my $video_id_pattern_3
        = qr{$func_name [(] "body_mv_player", \s* " (?<video_id> .+?) " ,}xms;

    # controller/video/viewer/VideoView.html?vid=90-m2tl87zM$&play_loc=...
    my $video_id_pattern_4
        = qr{/video/viewer/VideoView.html [?] vid = (?<video_id> .+?) &}xmsi;

    if (   $document !~ $video_id_pattern_1
        && $document !~ $video_id_pattern_2
        && $document !~ $video_id_pattern_3
        && $document !~ $video_id_pattern_4 )
    {
        carp $document;
        carp 'Cannot find video ID';
        return;
    }
    my $video_id = $LAST_PAREN_MATCH{video_id};

    # Remove white spaces in video ID.
    $video_id =~ s/\s+//xmsg;

    if ( !is_valid_video_id($video_id) ) {
        carp "Invalid video ID: $video_id";
        return;
    }

    return $video_id;
}

=head2 get_video_url

Returns video URL of the given video ID.

=cut

sub get_video_url {
    my ($video_id) = @_;

    return if !defined $video_id;

    my $query_url
        = 'http://videofarm.daum.net/controller/api/open/v1_2/'
        . 'MovieLocation.apixml'
        . "?vid=$video_id&preset=main";

    my $document = get($query_url);
    if ( !defined $document ) {
        carp "Cannot fetch '$query_url'";
        return;
    }

    # <![CDATA[
    # http://cdn.flvs.daum.net/fms/pos_query2.php?service_id=1001&protocol=...
    # ]]>
    my $url_pattern = qr{<!\[CDATA\[ \s* (?<url> .+?) \s* \]\]>}xms;
    if ( $document !~ $url_pattern ) {
        carp 'Cannot find URL';
        return;
    }
    my $url = $LAST_PAREN_MATCH{url};

    my $video_url;

    # http://cdn.flvs.daum.net/fms/pos_query2.php?service_id=1001&protocol=...
    if ( $url =~ /pos_query2[.]php/xmsi ) {
        $document = get($url);
        if ( !defined $document ) {
            carp "Cannot fetch '$url'";
            return;
        }

        # movieURL="http://stream.tvpot.daum.net/swxwT-/InNM6w/JgEM-E/..."
        my $video_url_pattern = qr{movieURL = " (?<video_url> .+?) "}xms;
        if ( $document !~ $video_url_pattern ) {
            carp 'Cannot find video URL';
            return;
        }
        $video_url = $LAST_PAREN_MATCH{video_url};
    }
    else {
        $video_url = $url;
    }

    return $video_url;
}

=head2 get_video_title

Returns video title of the given video ID.

=cut

sub get_video_title {
    my ($video_id) = @_;

    return if !defined $video_id;

    my $query_url
        = 'http://tvpot.daum.net/clip/ClipInfoXml.do?vid=' . $video_id;

    my $document = get($query_url);
    if ( !defined $document ) {
        carp "Cannot fetch '$query_url'";
        return;
    }

    # <TITLE><![CDATA[Just The Way You Are]]></TITLE>
    my $video_title_pattern
        = qr{<TITLE> <!\[CDATA \[ (?<video_title> .+?) \] \]> </TITLE>}xms;
    if ( $document !~ $video_title_pattern ) {
        carp 'Cannot find video title';
        return;
    }
    my $video_title = $LAST_PAREN_MATCH{video_title};

    # &amp; => &
    $video_title = decode_entities($video_title);

    return $video_title;
}

=head2 get_filename_from_video_title

Returns file name for the given video title and extension.

=cut

sub get_filename_from_video_title {
    my ( $video_title, $extension ) = @_;

    my $filename = $video_title;

    # Remove leading and trailing white spaces
    $filename =~ s/^ \s+//xms;
    $filename =~ s/\s+ $//xms;

    # Use '_' instead of white space
    $filename =~ s/\s+/_/xmsg;

    # Remove reserved characters
    $filename =~ s{[/\\?%*:|"<>.]}{_}xmsg;

    # Remove leading and trailing '_'
    $filename =~ s/^ _+//xms;
    $filename =~ s/_+ $//xms;

    # Suppress repeated '_'
    $filename =~ s/__+/_/xmsg;

    $filename .= ".$extension";

    return $filename;
}

=head1 AUTHOR

Seungwon Jeong, C<< <seungwon0 at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<seungwon0 at
gmail.com>, or through the web interface at
L<https://github.com/seungwon0/tvpot-dl/issues>.  I will be notified,
and then you'll automatically be notified of progress on your bug as I
make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::TvpotDl

You can also look for information at:

L<https://github.com/seungwon0/tvpot-dl>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Seungwon Jeong.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;    # End of App::TvpotDl
