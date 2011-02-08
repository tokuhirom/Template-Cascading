package Template::Cascading;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';
use YAML::XS;
use HTML::Zoom;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    bless {
        tmpl => $args{tmpl},
        zoom => HTML::Zoom->from_html($args{html}),
    }, $class;
}

sub cascade {
    my ($self, $stuff, $args) = @_;

    my $tmpl_data = YAML::XS::Load(do {
        if (ref $stuff eq "SCALAR") {
            $$stuff
        } else {
            open my $fh, '<:utf8', $stuff or die;
            do { local $/; <$fh> };
        }
    });
    my $zoom = $self->{zoom};
    while (my ($selector, $src) = each %$tmpl_data) {
        my $result = $self->{tmpl}->render_string($src, $args);
        $self->{zoom} = $self->{zoom}->select($selector)->replace_content($result);
    }
    return $self;
}

sub to_html { $_[0]->{zoom}->to_html }

1;
__END__

=encoding utf8

=head1 NAME

Template::Cascading -

=head1 SYNOPSIS

    use Template::Cascading;
    my $xslate = Text::Xslate->new(
        syntax => 'TTerse',
        module => [qw/Text::Xslate::Bridge::TT2Like/],
    );
    my $tmpl = Template::Cascading->new(
        tmpl => $xslate, # The object supports L<Tiffany> protocol
        html => $html,
    );
    $tmpl->cascade('detail.yml', {
        user => 'John',
        sex  => 'Male',
    });

=head1 DESCRIPTION

Template::Cascading is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
