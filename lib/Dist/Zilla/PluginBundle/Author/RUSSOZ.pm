package Dist::Zilla::PluginBundle::Author::RUSSOZ;

use strict;
use warnings;

# ABSTRACT: configure Dist::Zilla like RUSSOZ
# VERSION

use Moose 0.99;
use namespace::autoclean 0.09;

use Dist::Zilla 4.102341;    # dzil authordeps

with 'Dist::Zilla::Role::PluginBundle::Easy';

sub configure {
    my $self = shift;

    $self->add_bundle('Basic');

    $self->add_plugins(
        'MetaJSON',
        'ReadmeFromPod',
        'InstallGuide',
        [
            'GitFmtChanges' => {
                max_age    => 365,
                tag_regexp => q{^.*$},
                file_name  => q{Changes},
                log_format => q{short},
            }
        ],

        'OurPkgVersion',
        'AutoPrereqs',

        'ReportVersions::Tiny',
        'CompileTests',
        'EOLTests',
        'PodCoverageTests',
        'UnusedVarsTests',
        'CriticTests',
        'HasVersionTests',
        'KwaliteeTests',
        'MetaTests',
        'PodSyntaxTests',
        'NoTabsTests',
    );

    $self->add_plugins(
        [
            'Twitter' => {
                hash_tags => '#perl #cpan',
                tweet_url =>
                  q(http://search.cpan.org/~{{$AUTHOR_LC}}/{{$DIST}}),
                url_shortener => 'TinyURL',
            }
        ]
    ) if ( $self->twitter and not $self->fake_release );
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
