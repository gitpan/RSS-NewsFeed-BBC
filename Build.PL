use strict;use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign              => 1,
    module_name       => 'RSS::NewsFeed::BBC',
    license           => 'perl',
    dist_author       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from => 'lib/RSS/NewsFeed/BBC.pm',
    add_to_cleanup    => [ 'RSS-NewsFeed-BBC-*' ],
    build_requires    => {
        'Test::More'             => 0,
        'Readonly'               => '1.03',
        'XML::Parser::Lite'      => 0,
        'LWP::Simple'            => '5.827',
        'XML::RSS::Parser::Lite' => '0.10'
    },
);

$builder->create_build_script();