use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'RSS::NewsFeed::BBC',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/RSS/NewsFeed/BBC.pm',
    ABSTRACT_FROM => 'lib/RSS/NewsFeed/BBC.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'RSS-NewsFeed-BBC-*' },
    PREREQ_PM     => {
        'Test::More'             => 0,
        'Readonly'               => 0,
        'LWP::Simple'            => '5.827',
        'XML::RSS::Parser::Lite' => '0.10'
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);