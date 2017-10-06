package Pod::Weaver::PluginBundle::Author::RUSSOZ;

use strict;
use warnings;

# ABSTRACT: Pod::Weaver configuration the way RUSSOZ does it
# VERSION

use Pod::Weaver::Config::Assembler;

use Pod::Elemental::Transformer::List;
use Pod::Weaver::Section::SeeAlso 1.002;
use Pod::Weaver::Section::Support 1.003;
use Pod::Weaver::Section::WarrantyDisclaimer 0.103511;
use Pod::Weaver::Plugin::Encoding 0.01;

sub _exp {    ## no critic
    Pod::Weaver::Config::Assembler->expand_package( $_[0] );
}

use namespace::clean;

sub mvp_bundle_config {
    my @plugins;
    push @plugins, (
        [ '@Author::RUSSOZ/CorePrep', _exp('@CorePrep'), {} ],
        [ '@Author::RUSSOZ/Encoding', _exp('-Encoding'), {} ],
        [
            '@Author::RUSSOZ/EnsureUniqueSections',
            _exp('-EnsureUniqueSections'),
            {}
        ],
        [ '@Author::RUSSOZ/Name',    _exp('Name'),    {} ],
        [ '@Author::RUSSOZ/Version', _exp('Version'), {} ],

        [
            '@Author::RUSSOZ/Prelude', _exp('Region'),
            { region_name => 'prelude' }
        ],
        [
            '@Author::RUSSOZ/Synopsis', _exp('Generic'),
            { header => 'SYNOPSIS' }
        ],
        [
            '@Author::RUSSOZ/Description', _exp('Generic'),
            { header => 'DESCRIPTION' }
        ],
        [
            '@Author::RUSSOZ/Overview', _exp('Generic'),
            { header => 'OVERVIEW' }
        ],
    );

    for my $plugin (
        [ 'Attributes', _exp('Collect'), { command => 'attr' } ],
        [ 'Methods',    _exp('Collect'), { command => 'method' } ],
        [ 'Functions',  _exp('Collect'), { command => 'func' } ],
      )
    {
        $plugin->[2]{header} = uc $plugin->[0];
        push @plugins, $plugin;
    }

    push @plugins,
      (
        [ '@Author::RUSSOZ/Leftovers', _exp('Leftovers'), {} ],
        [ '@Author::RUSSOZ/SeeAlso',   _exp('SeeAlso'),   {} ],
        [
            '@Author::RUSSOZ/Support',
            _exp('Support'),
            {
                'websites' => [
                    'search',   'anno',    'ratings', 'forum',
                    'kwalitee', 'testers', 'testmatrix'
                ],
                'irc'   => [ 'irc.perl.org, #sao-paulo.pm, russoz', ],
                'email' => 'RUSSOZ',
            }
        ],
        [
            '@Author::RUSSOZ/postlude', _exp('Region'),
            { region_name => 'postlude' }
        ],
        [ '@Author::RUSSOZ/Authors', _exp('Authors'), {} ],
        [ '@Author::RUSSOZ/Legal',   _exp('Legal'),   {} ],
        [
            '@Author::RUSSOZ/BugsAndLimitations', _exp('BugsAndLimitations'), {}
        ],
        [
            '@Author::RUSSOZ/WarrantyDisclaimer', _exp('WarrantyDisclaimer'), {}
        ],
        [
            '@Author::RUSSOZ/List', _exp('-Transformer'),
            { 'transformer' => 'List' }
        ],
      );

    return @plugins;
}

1;

1;

__END__

=pod

=for Pod::Coverage mvp_bundle_config

=cut

