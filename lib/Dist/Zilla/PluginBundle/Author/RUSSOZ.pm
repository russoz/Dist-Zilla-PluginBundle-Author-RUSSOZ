package Dist::Zilla::PluginBundle::Author::RUSSOZ;

use strict;
use warnings;

# ABSTRACT: configure Dist::Zilla like RUSSOZ
# VERSION

use Moose 0.99;
use namespace::autoclean 0.09;

use Dist::Zilla 4.102341;    # dzil authordeps

with 'Dist::Zilla::Role::PluginBundle::Easy';

has twitter => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
        ( defined $_[0]->payload->{no_twitter}
              and $_[0]->payload->{no_twitter} == 1 ) ? 0 : 1;
    },
);

has twitter_tags => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my @t =
          defined( $_[0]->payload->{twitter_tags} )
          ? ( $_[0]->payload->{twitter_tags} )
          : ();
        return join( ' ', q{#cpan}, q{#perl}, @t );
    },
);

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
    );

    $self->add_bundle(
        'TestingMania' => { disable => q{Test::CPAN::Changes} } );

    $self->add_plugins(
        [
            'Twitter' => {
                hash_tags => $self->twitter_tags,
                tweet_url =>
                  q(http://search.cpan.org/~{{$AUTHOR_LC}}/{{$DIST}}),
                url_shortener => 'TinyURL',
            }
        ]
    ) if ( $self->twitter );
    return;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=pod

=head1 SYNOPSIS

	# in dist.ini
	[@Author::RUSSOZ]

=head1 DESCRIPTION

C<Dist::Zilla::PluginBundle::Author::RUSSOZ> provides shorthand for
a L<Dist::Zilla> configuration approximately like:

	[@Basic]

	[MetaJSON]
	[ReadmeFromPod]
	[InstallGuide]
	[GitFmtChanges]
	max_age    = 365
	tag_regexp = ^.*$
	file_name  = Changes
	log_format = short

	[OurPkgVersion]
	[AutoPrereqs]

	[ReportVersions::Tiny]
	[@TestingMania]

	[Twitter]
	tweet_url = http://search.cpan.org/~{{$AUTHOR_LC}}/{{$DIST}}
	hash_tags = #perl #cpan
	url_shortener = TinyURL

=head1 USAGE

Just put C<[@Author::RUSSOZ]> in your F<dist.ini>. You can supply the following
options:

=over 4

=item *

C<no_twitter> says that releases of this module shouldn't be tweeted.

=item *

C<twitter_tags> says which B<additional> hash tags will be used in the
release tweet. The tags C<#cpan> and C<#perl> are always added.

=back

=for Pod::Coverage configure

=head1 SEE ALSO

C<L<Dist::Zilla>>

=head1 ACKNOWLEDGMENTS

Much of the first implementation was shamelessly copied from
L<Dist::Zilla::PluginBundle::Author::DOHERTY>.

=cut

