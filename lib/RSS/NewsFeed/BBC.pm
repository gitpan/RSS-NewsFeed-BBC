package RSS::NewsFeed::BBC;

use strict;use warnings;

use overload q("") => \&as_string, fallback => 1;

use Carp;
use Readonly;
use LWP::Simple;
use Data::Dumper;
use XML::RSS::Parser::Lite;

=head1 NAME

RSS::NewsFeed::BBC - Interface to BBC News Feed.

=head1 VERSION

Version 0.05

=cut

our $VERSION = '0.05';

Readonly my $NATIONAL      => 'http://feeds.bbci.co.uk/news/rss.xml';
Readonly my $INTERNATIONAL => 'http://feeds.bbci.co.uk/news/rss.xml?edition=int';

sub new
{
    my $class = shift;
    my $self  = { '_title'       => 'Undefined',
                  '_url'         => 'Undefined',
                  '_description' => 'Undefined' };
    
    bless $self, $class;
    return $self;
}

=head1 METHODS

=head2 get_title()

Returns the news feed title of national/international  BBC news. This  should *ONLY* be called
after method get_national() or get_international(), otherwise it will return Undefined.

    use strict; use warnigns;
    use RSS::NewsFeed::BBC;
    
    my $news     = RSS::NewsFeed::BBC->new();
    my $national = $news->get_national();
    my $title    = $news->get_title();

=cut

sub get_title
{
    my $self = shift;
    return $self->{_title};
}

=head2 get_url()

Returns  the  news feed URL of national/international  BBC news. This  should *ONLY* be called
after method get_national() or get_international(), otherwise it will return Undefined.

    use strict; use warnigns;
    use RSS::NewsFeed::BBC;
    
    my $news     = RSS::NewsFeed::BBC->new();
    my $national = $news->get_national();
    my $url      = $news->get_url();

=cut

sub get_url
{
    my $self = shift;
    return $self->{_url};
}

=head2 get_description()

Returns  the  news feed description of national/international BBC news. This  should *ONLY* be
called after method get_national() or get_international(), otherwise it will return Undefined.

    use strict; use warnigns;
    use RSS::NewsFeed::BBC;
    
    my $news        = RSS::NewsFeed::BBC->new();
    my $national    = $news->get_national();
    my $description = $news->get_description();

=cut

sub get_description
{
    my $self = shift;
    return $self->{_description};
}

=head2 get_national()

Returns the BBC National news.

    use strict; use warnigns;
    use RSS::NewsFeed::BBC;
    
    my $news     = RSS::NewsFeed::BBC->new();
    my $national = $news->get_national();

=cut

sub get_national
{
    my $self = shift;
    return $self->_fetch_news($NATIONAL);
}

=head2 get_international()

Returns the BBC International news.

    use strict; use warnigns;
    use RSS::NewsFeed::BBC;
    
    my $news          = RSS::NewsFeed::BBC->new();
    my $international = $news->get_international();

=cut

sub get_international
{
    my $self = shift;
    return $self->_fetch_news($INTERNATIONAL);    
}

=head2 as_xml()

Returns latest news in in XML format. This should *ONLY* be called after method get_national()
or get_international().

    use strict; use warnigns;
    use RSS::NewsFeed::BBC;
    
    my $news     = RSS::NewsFeed::BBC->new();
    my $national = $news->get_national();

    print $news->as_xml();

=cut

sub as_xml
{
    my $self = shift;
    my $xml = qq {<?xml version="1.0" encoding="UTF-8"?>\n};
    $xml.= qq {<news>\n};
    foreach (@{$self->{_news}})
    {
        $xml .= qq {\t<item>\n};
        $xml .= qq {\t\t<title> $_->{title} </title>\n};
        $xml .= qq {\t\t<url> $_->{url} </url>\n};
        $xml .= qq {\t\t<description> $_->{description} </description>\n};
        $xml .= qq {\t</item>\n};
    }
    $xml.= qq {</news>};
    return $xml;
}

=head2 as_string()

Returns latest news in a human readable format.

    use strict; use warnigns;
    use RSS::NewsFeed::BBC;
    
    my $news     = RSS::NewsFeed::BBC->new();
    my $national = $news->get_national();

    print $news->as_string();

    # or even simply
    print $news;

=cut

sub as_string
{
    my $self = shift;
    my ($news);
    
    foreach (@{$self->{_news}})
    {
        $news .= sprintf("      Title: %s\n", $_->{title});
        $news .= sprintf("        URL: %s\n", $_->{url});
        $news .= sprintf("Description: %s\n", $_->{description});
        $news .= "-------------------\n";
    }
    return $news;
}

sub _fetch_news
{
    my $self   = shift;
    my $url    = shift;
    
    my $news   = [];
    my $xml    = get($url);
    my $parser = XML::RSS::Parser::Lite->new();
    $parser->parse($xml);
    $self->{_title}       = $parser->get('title');
    $self->{_url}         = $parser->get('url');
    $self->{_description} = $parser->get('description');
    
    for (my $i = 0; $i < $parser->count(); $i++) 
    {
        my $item = $parser->get($i);
        push @{$news}, 
            { title       => $item->get('title'),
              url         => $item->get('url'),
              description => $item->get('description') };
    }
    $self->{_news} = $news;
    return $news;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please  report  any  bugs  or  feature  requests to C<bug-rss-newsfeed-bbc at rt.cpan.org>, or
through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=RSS-NewsFeed-BBC>.  
I will be notified,  and  then you will automatically be notified of progress on your bug as I
make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc RSS::NewsFeed::BBC

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=RSS-NewsFeed-BBC>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/RSS-NewsFeed-BBC>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/RSS-NewsFeed-BBC>

=item * Search CPAN

L<http://search.cpan.org/dist/RSS-NewsFeed-BBC/>

=back

=head1 ACKNOWLEDGEMENTS

RSS::NewsFeed::BBC provides information from BBC official website.  This information should be
used as it is without any modifications. BBC remains the sole owner of the data. The terms and
condition for RSS Feed can be found here http://www.bbc.co.uk/terms/additional_rss.shtml.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mohammad S Anwar.

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed  in  the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

1; # End of RSS::NewsFeed::BBC