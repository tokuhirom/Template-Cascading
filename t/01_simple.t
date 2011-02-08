use strict;
use warnings;
use utf8;
use Test::More;
use Template::Cascading;
use Text::Xslate;

my $xslate = Text::Xslate->new(
    syntax => 'TTerse',
);

is(
Template::Cascading->new(
    tmpl => $xslate,
    html   => slurp('t/test/simple/base.html'),
)->cascade('t/test/simple/detail.yml', {
    user => 'John',
    sex  => 'male',
})->to_html, <<'...');
<!doctype html>
<html>
    <head>
        <title>John page</title>
    </head>
    <body>
        <div class="container">
            <div id="Content">Wow! John is male!!!
</div>
        </div>
    </body>
</html>
...

done_testing;

sub slurp {
    open my $fh, '<:utf8', $_[0] or die;
    do { local $/; <$fh> };
}
