#!perl
# vim:ts=4:sw=4:expandtab

use i3test;

fresh_workspace;

# Build two vertical columns inside a horizontal workspace:
#
# +------------+------------+
# | top-left   | top-right  |
# +------------+------------+
# | bottom-left| bottom-right|
# +------------+------------+
my $top_left = open_window;
my $top_right = open_window;

cmd 'focus left, split v';
my $bottom_left = open_window;

cmd 'focus right, split v';
my $bottom_right = open_window;

# Make bottom-left the left column's most recently focused child, then move to
# top-right without traversing the split. Focus history must not override the
# only spatially adjacent target when moving left.
cmd '[id=' . $bottom_left->id . '] focus';
cmd '[id=' . $top_right->id . '] focus';
cmd 'focus left';

is($x->input_focus, $top_left->id,
   'directional focus chooses the spatially adjacent window over focus history');

cmd '[id=' . $bottom_right->id . '] focus';
cmd '[id=' . $top_left->id . '] focus';
cmd 'focus right';
is($x->input_focus, $top_right->id,
   'spatial adjacency wins over focus history when moving right');

fresh_workspace;

# Build the same grid grouped as horizontal rows to exercise vertical focus.
my $vertical_top_left = open_window;
cmd 'split v';
my $vertical_bottom_left = open_window;

cmd 'focus up, split h';
my $vertical_top_right = open_window;

cmd 'focus down, split h';
my $vertical_bottom_right = open_window;

cmd '[id=' . $vertical_top_right->id . '] focus';
cmd '[id=' . $vertical_bottom_left->id . '] focus';
cmd 'focus up';
is($x->input_focus, $vertical_top_left->id,
   'spatial adjacency wins over focus history when moving up');

cmd '[id=' . $vertical_bottom_right->id . '] focus';
cmd '[id=' . $vertical_top_left->id . '] focus';
cmd 'focus down';
is($x->input_focus, $vertical_bottom_left->id,
   'spatial adjacency wins over focus history when moving down');

fresh_workspace;

# A full-height window beside two stacked windows overlaps both candidates.
# This is a genuine split choice, so retain the existing focus-history tie
# breaker.
my $ambiguous_top = open_window;
my $full_height = open_window;
cmd 'focus left, split v';
my $ambiguous_bottom = open_window;

cmd '[id=' . $ambiguous_top->id . '] focus';
cmd '[id=' . $full_height->id . '] focus';
cmd 'focus left';
is($x->input_focus, $ambiguous_top->id,
   'focus history breaks a tie between overlapping targets');

cmd '[id=' . $ambiguous_bottom->id . '] focus';
cmd '[id=' . $full_height->id . '] focus';
cmd 'focus left';
is($x->input_focus, $ambiguous_bottom->id,
   'focus-history tie breaking follows the most recently focused target');

done_testing;
