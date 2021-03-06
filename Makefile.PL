use inc::Module::Install;
use Module::Install::AuthorTests;

name 'Template-Cascading';
all_from 'lib/Template/Cascading.pm';

# requires '';
# requires 'Exporter' => 5.63; # use Exporter 'import';
# requires 'Plack' =>  0.9949;
requires 'YAML';
requires 'Text::Xslate';
requires 'HTML::Zoom';


tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More' => 0.96; # done_testing, subtest
# test_requires 'Test::Requires';
author_tests('xt');
WriteAll;
