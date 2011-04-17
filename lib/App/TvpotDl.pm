package App::TvpotDl;

use strict;

use warnings;

use English qw< -no_match_vars >;

use LWP::Simple qw< get >;

use Carp qw< carp >;

use HTML::Entities qw< decode_entities >;

=head1 NAME

App::TvpotDl - Download flash videos from Daum tvpot

=head1 VERSION

Version 0.8.1

=cut

our $VERSION = '0.8.1';

=head1 SYNOPSIS

    use App::TvpotDl;

    my $url = 'http://tvpot.daum.net/clip/ClipView.do?clipid=29772622';

    # Get video ID
    my $video_id = App::TvpotDl::get_video_id($url);

    # Get video URL
    my $video_url = App::TvpotDl::get_video_url($video_id);

=head1 SUBROUTINES

=head2 get_video_id

Returns video ID of the given tvpot URL.

=cut

sub get_video_id {
    my ($url) = @_;

    # http://tvpot.daum.net/best/Top.do?from=gnb#clipid=31946003
    if ( $url =~ /[#] clipid = (?<clip_id>\d+)/xmsi ) {
        $url = 'http://tvpot.daum.net/clip/ClipView.do?clipid='
            . $LAST_PAREN_MATCH{clip_id};
    }

    my $document = get($url);
    if ( !defined $document ) {
        carp "Cannot fetch the document identified by the given URL: $url\n";
        return;
    }

    # "http://flvs.daum.net/flvPlayer.swf?vid=FlVGvam5dPM$"
    my $flv_player_url = quotemeta 'http://flvs.daum.net/flvPlayer.swf';
    my $video_id_pattern
        = qr{" $flv_player_url [?] vid = (?<video_id>.+?) ["&]}xmsi;
    if ( $document !~ $video_id_pattern ) {
        carp "Cannot find video ID from the document.\n";
        return;
    }
    my $video_id = $LAST_PAREN_MATCH{video_id};

    return $video_id;
}

=head2 get_video_url

Returns video URL of the given video ID.

=cut

sub get_video_url {
    my ($video_id) = @_;

    my $query_url
        = 'http://stream.tvpot.daum.net/fms/pos_query2.php'
        . '?service_id=1001&protocol=http&out_type=xml'
        . "&s_idx=$video_id";

    my $document = get($query_url);
    if ( !defined $document ) {
        carp 'Cannot fetch the document identified by the given URL: '
            . "$query_url\n";
        return;
    }

    # movieURL="http://stream.tvpot.daum.net/swxwT-/InNM6w/JgEM-E/OxDQ$$.flv"
    my $video_url_pattern = qr{movieURL = "(?<video_url>.+?)"}xmsi;
    if ( $document !~ $video_url_pattern ) {
        carp "Cannot find video URL from the document.\n";
        return;
    }
    my $video_url = $LAST_PAREN_MATCH{video_url};

    return $video_url;
}

=head2 get_video_title

Returns video title of the given video ID.

=cut

sub get_video_title {
    my ($video_id) = @_;

    my $query_url = "http://tvpot.daum.net/clip/ClipInfoXml.do?vid=$video_id";

    my $document = get($query_url);
    if ( !defined $document ) {
        carp 'Cannot fetch the document identified by the given URL: '
            . "$query_url\n";
        return;
    }

    # <TITLE><![CDATA[Just The Way You Are]]></TITLE>
    my $video_title_pattern
        = qr{<TITLE> <!\[CDATA \[ (?<video_title>.+?) \] \]> </TITLE>}xmsi;
    if ( $document !~ $video_title_pattern ) {
        carp "Cannot find video title from the document.\n";
        return;
    }
    my $video_title = $LAST_PAREN_MATCH{video_title};

    # &amp; => &
    $video_title = decode_entities($video_title);

    return $video_title;
}

=head2 get_filename_from_video_title

Returns file name for the given video title.

=cut

sub get_filename_from_video_title {
    my ($video_title) = @_;

    my $filename = $video_title;

    # Remove leading and trailing white spaces
    $filename =~ s/^\s+//xms;
    $filename =~ s/\s+$//xms;

    # Use '_' instead of white space
    $filename =~ s/\s+/_/xmsg;

    # Remove reserved characters
    $filename =~ s{[/\\?%*:|"<>.]}{_}xmsg;

    # Remove leading and trailing '_'
    $filename =~ s/^_+//xms;
    $filename =~ s/_+$//xms;

    $filename .= '.flv';

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
