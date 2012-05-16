#!perl
# vim:ts=4:sw=4:expandtab
#
# Regression test to check if borders are correctly restored after an inplace
# restart.
# found in eb8ad348b28e243cba1972e802ca8ee636472fc9
#
use List::Util qw(first);
use i3test;

my $i3 = i3(get_socket_path());
my $tmp = fresh_workspace;
my $window = open_window;

sub get_border_style {
    my @content = @{get_ws_content($tmp)};
    my $wininfo = first { $_->{window} == $window->id } @content;

    return $wininfo->{border};
}

is(get_border_style(), 'normal', 'border style normal');

cmd 'border 1pixel';

is(get_border_style(), '1pixel', 'border style 1pixel after changing');

# perform an inplace-restart
cmd 'restart';

does_i3_live;

is(get_border_style(), '1pixel', 'border style still 1pixel after restart');

done_testing;