package Pod::Weaver::PluginBundle::Author::RUSSOZ;

use strict;
use warnings;

# ABSTRACT: Pod::Weaver configuration the way RUSSOZ does it
# VERSION

use Pod::Weaver::Config::Assembler;

sub _exp { Pod::Weaver::Config::Assembler->expand_package( $_[0] ) } ## no critic

use namespace::clean;

sub mvp_bundle_config {
    return (
        [ '@Author::RUSSOZ/CorePrep', _exp('@CorePrep'), {} ],
        [ '@Author::RUSSOZ/Name',     _exp('Name'),      {} ],
        [ '@Author::RUSSOZ/prelude', _exp('Region'), { region_name => 'prelude' } ],

        [ 'SYNOPSIS',    _exp('Generic'), {} ],
        [ 'DESCRIPTION', _exp('Generic'), {} ],
        [ 'OVERVIEW',    _exp('Generic'), {} ],

        [ 'ATTRIBUTES', _exp('Collect'), { command => 'attr' } ],
        [ 'METHODS',    _exp('Collect'), { command => 'method' } ],
        [ 'FUNCTIONS',  _exp('Collect'), { command => 'func' } ],
        [ 'TYPES',      _exp('Collect'), { command => 'type' } ],

        [ '@Author::RUSSOZ/Leftovers', _exp('Leftovers'), {} ],

        [ '@Author::RUSSOZ/postlude', _exp('Region'), { region_name => 'postlude' } ],

        [ '@Author::RUSSOZ/Authors', _exp('Authors'), {} ],
        [ '@Author::RUSSOZ/Legal',   _exp('Legal'),   {} ],

        [ '@Author::RUSSOZ/List',     _exp('-Transformer'), { transformer => 'List' } ],
        [ '@Author::RUSSOZ/Encoding', _exp('-Encoding'),    {} ],
    );
}

1;

