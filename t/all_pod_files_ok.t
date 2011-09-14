use strict;
use warnings;
use Test::More;
use English qw(-no_match_vars);

if ( not $ENV{TEST_AUTHOR} ) {
     my $msg = 'Author test.  Set $ENV{TEST_AUTHOR} to a true value to run.';
     plan( skip_all => $msg );
}

eval "use Test::Pod 1.00";

if ( $EVAL_ERROR ) {
   my $msg = 'Test::Pod required to check pod files';
   plan( skip_all => $msg );
}

all_pod_files_ok();


