package App::TvpotDl;

use strict;

use warnings;

use 5.010;

use autodie;

use English qw< -no_match_vars >;

use LWP::Simple qw< get getstore >;

=head1 NAME

App::TvpotDl - Download flash videos from Daum tvpot

=head1 VERSION

Version 0.4.0

=cut

our $VERSION = '0.4.0';

=head1 SYNOPSIS

    use App::TvpotDl;

    my $url = 'http://tvpot.daum.net/clip/ClipView.do?clipid=29772622';

    App::TvpotDl::download_video($url);

=head1 SUBROUTINES

=head2 get_video_id

Returns video ID of the given tvpot URL.

=cut

sub get_video_id {
    my ($url) = @_;

    my $document = get($url);
    if ( !defined $document ) {
        warn "Cannot fetch the document identified by the given URL: $url\n";
        return;
    }

    # "http://flvs.daum.net/flvPlayer.swf?vid=FlVGvam5dPM$"
    my $flv_player_url = "\Qhttp://flvs.daum.net/flvPlayer.swf\E";
    my $video_id_pattern
        = qr{" $flv_player_url [?] vid = (?<video_id>.+?) ["&]}xmsi;
    if ( $document !~ $video_id_pattern ) {
        warn "Cannot find video ID from the document.\n";
        return;
    }
    my $video_id = $LAST_PAREN_MATCH{video_id};

    return $video_id;
}

=head2 get_movie_url

Returns movie URL of the given video ID.

=cut

sub get_movie_url {
    my ($video_id) = @_;

    my $query_url
        = 'http://stream.tvpot.daum.net/fms/pos_query2.php'
        . '?service_id=1001&protocol=http&out_type=xml'
        . "&s_idx=$video_id";

    my $document = get($query_url);
    if ( !defined $document ) {
        warn 'Cannot fetch the document identified by the given URL: '
            . "$query_url\n";
        return;
    }

    # movieURL="http://stream.tvpot.daum.net/swxwT-/InNM6w/JgEM-E/OxDQ$$.flv"
    my $movie_url_pattern = qr{movieURL = "(?<movie_url>.+?)"}xmsi;
    if ( $document !~ $movie_url_pattern ) {
        warn "Cannot find movie URL from the document.\n";
        return;
    }
    my $movie_url = $LAST_PAREN_MATCH{movie_url};

    return $movie_url;
}

=head2 download_video

Downloads a flash video from the given tvpot URL.

=cut

sub download_video {
    my ($url) = @_;

    # Step 1: Get video ID
    my $video_id = get_video_id($url);
    return if !defined $video_id;
    say "Video ID: $video_id";

    # Step 2: Get movie URL
    my $movie_url = get_movie_url($video_id);
    return if !defined $movie_url;
    say "Movie URL: $movie_url";

    # Step 3: Download the movie
    my $file_name = "$video_id.flv";
    say "Downloading the movie as $file_name... "
        . '(It may takes several minutes.)';
    getstore( $movie_url, $file_name );
    say 'Download completed.';

    return;
}

=head1 AUTHOR

Seungwon Jeong, C<< <seungwon0 at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-tvpot-dl at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=tvpot-dl>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::TvpotDl

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=tvpot-dl>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/tvpot-dl>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/tvpot-dl>

=item * Search CPAN

L<http://search.cpan.org/dist/tvpot-dl/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Seungwon Jeong.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;    # End of App::TvpotDl
