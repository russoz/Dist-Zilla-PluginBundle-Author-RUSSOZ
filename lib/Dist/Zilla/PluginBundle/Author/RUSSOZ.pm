package Dist::Zilla::PluginBundle::Author::RUSSOZ;

use strict;
use warnings;

# ABSTRACT: configure Dist::Zilla like RUSSOZ
# VERSION

use Moose 0.99;
use namespace::autoclean 0.09;

use Dist::Zilla 4.102341;    # dzil authordeps
use Dist::Zilla::PluginBundle::TestingMania 0.012;
use Dist::Zilla::Plugin::MetaJSON;
use Dist::Zilla::Plugin::ReadmeFromPod;
use Dist::Zilla::Plugin::InstallGuide;
use Dist::Zilla::Plugin::Signature;

with 'Dist::Zilla::Role::PluginBundle::Easy';

has auto_prereqs => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => 1,
);

has no404 => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
        ( defined $_[0]->payload->{no404} and $_[0]->payload->{no404} == 1 )
          ? 1
          : 0;
    },
);

has github => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
        ( defined $_[0]->payload->{github} and $_[0]->payload->{github} == 0 )
          ? 0
          : 1;
    },
);

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

has task_weaver => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
        ( defined $_[0]->payload->{task_weaver}
              and $_[0]->payload->{task_weaver} == 1 ) ? 1 : 0;
    },
);

has signature => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
        ( defined $_[0]->payload->{signature}
              and $_[0]->payload->{signature} == 0 ) ? 0 : 1;
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
    );

    $self->add_plugins('GithubMeta')  if $self->github;
    $self->add_plugins('AutoPrereqs') if $self->auto_prereqs;

    if ( $self->task_weaver ) {
        $self->add_plugins('TaskWeaver');
    }
    else {
        $self->add_plugins( 'ReportVersions::Tiny',
            [ 'PodWeaver' => { config_plugin => '@Author::RUSSOZ' }, ],
        );

        $self->add_plugins('Test::UseAllModules');
        $self->add_bundle( 'TestingMania' =>
              { disable => q{Test::CPAN::Changes,SynopsisTests}, } );
        $self->add_plugins('Test::Pod::No404s')
          if ( $self->no404 || $ENV{NO404} );
    }

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

    $self->add_plugins('Signature') if $self->signature;

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
	; auto_prereqs = 1
	; github = 1
	; no404 = 0
	; task_weaver = 0
	; no_twitter = 0
	; twitter_tags = <empty>
	; signature = 1

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
	[GithubMeta]                        ; if github = 1
	[AutoPrereqs]                       ; unless auto_prereqs = 0

	[ReportVersions::Tiny]
	[PodWeaver]
	config_plugin = @Author::RUSSOZ

	; if task_weaver =1
	[TaskWeaver]

	; else (task_weaver = 0)
	[@TestingMania]
	disable = Test::CPAN::Changes, SynopsisTests
	[Test::Pod::No404]

	; endif

	[Twitter]
	tweet_url = http://search.cpan.org/~{{$AUTHOR_LC}}/{{$DIST}}
	hash_tags = #perl #cpan             ; plus tags in twitter_tags
	url_shortener = TinyURL

	[Signature]                         ; if signature = 1

=head1 USAGE

Just put C<[@Author::RUSSOZ]> in your F<dist.ini>. You can supply the following
options:

=for :list
* auto_prereqs
Whether the module will use C<AutoPrereqs> or not. Default = 1.
* github
If using github, enable C<[GithubMeta]>. Default = 1.
* no404
Whether to use C<[Test::Pod::No404]> in the distribution. Default = 0.
* no_twitter
Releases of this module shouldn't be tweeted. Default = 0.
* twitter_tags
Additional hash tags to be used in the release tweet.
The tags C<#cpan> and C<#perl> are always prepended.
* signature
Whether to GPG sign the module or not. Default = 1.
* task_weaver
Set to 1 if this is a C<Task::> distribution. It will enable C<[TaskWeaver]>
while disabling C<[PodWeaver]> and all release tests. Default = 0.

=for Pod::Coverage configure

=head1 SEE ALSO

C<L<Dist::Zilla>>

=head1 ACKNOWLEDGMENTS

Much of the first implementation was shamelessly copied from
L<Dist::Zilla::PluginBundle::Author::DOHERTY>.

=cut

