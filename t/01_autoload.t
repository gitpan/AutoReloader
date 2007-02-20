# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Sub-Auto.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { use_ok('AutoReloader',qw(AUTOLOAD)) };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

mkdir 't/auto', 0755 or die "mkdir: $!\n";
mkdir 't/auto/main', 0755 or die "mkdir: $!\n";

open O, '>', 't/auto/main/getclass.al' or die "open: $!\n";

print O <<EOH;
sub {
   return __PACKAGE__;
};
EOH
close O or die "close: $!\n";
AutoReloader->auto('t/auto');
is(AutoReloader->auto(),'t/auto');
my $ret = getclass();
is($ret,'main');

sleep 1;
# let's change that sub during runtime
open O, '>', 't/auto/main/getclass.al' or die "open: $!\n";

print O <<EOH;
package Foo;
sub {
   return __PACKAGE__;
};
EOH
close O or die "close: $!\n";
$ret = getclass();
is($ret,'main');
# set the check flag for the sub
# *getclass{CODE}->check(1);
AutoReloader->check(1);

$ret = getclass();
is($ret,'Foo');

unlink 't/auto/main/getclass.al' or die "unlink t/auto/main/getclass.al: $!\n";
rmdir 't/auto/main' or die "rmdir t/auto/main: $!\n";
rmdir 't/auto' or die "rmdir t/auto: $!\n";

