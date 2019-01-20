use 5.010;
use strict;

my %seen;

my $fname = $ARGV[0];
if (not defined $fname) {
    die "Usage: $0 file_name";
}

open(f, "<:encoding(UTF-8)", $fname) or die "Cannot open file $fname";
while (my $x = <f>) {
    chomp $x;
    if ($x =~ /.*xmlUrl.*/) {
        if ($seen{$x}++ == 1) {
            say "Duplicate: $x";
        }
    }

    # say "$x";
}
close(f);

