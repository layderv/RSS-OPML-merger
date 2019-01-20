use 5.010;
use strict;
use warnings;

use XML::OPML::LibXML;

my $fname = $ARGV[0];
if (not defined $fname) {
    die "Usage: $0 file_name";
}

my $doc = XML::OPML::LibXML->new->parse_file($fname);
my $res = "";

my $title = $doc->title;
# my $date_created = $doc->date_created;
# my $date_modified = $doc->date_modified;
# my $owner_name = $doc->owner_name;

$res .= "
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<opml version=\"1.0\">
<head>
\t<title>$title</title>
</head>
<body>
";

my @outline = $doc->outline;
my %seen;
for my $outline (@outline) {
    if (! $outline->is_container) {
        $res .= outline_to_str($outline) . "\n";
    } else {
        my $s = parse_container($outline);
        next if $seen{$s}++;
        $res .= $s . "\n";
    }
}
$res .= "</body>\n</opml>";

say $res;

sub parse_container {
    my $c = shift;
    my $title = $c->title;
    my $text = $c->text;

    my $res = "<outline title=\"$title\" text=\"$text\">";
    
    my @children = $c->children;
    my %seen;
    for my $child (@children) {
        if (! $child->is_container) {
            my $s = outline_to_str($child);
            next if $seen{$s}++;
            $res .= "\n" . $s;
        } else {
            $res .= "\n" . parse_container($child);
        }
    }
    return $res . "\n</outline>";
}

sub outline_to_str {
    my $outline = shift;

    my $type        = $outline->type;
    my $xml_url     = $outline->xml_url;
    my $html_url    = $outline->html_url;
    my $text        = $outline->text;
    my $title       = $outline->title;

    return 
    "\t<outline type=\"$type\" 
    \t\ttext=\"$text\" 
    \t\ttitle=\"$title\" 
    \t\txmlUrl=\"$xml_url\" 
    \t\thtmlUrl=\"$html_url\" />";
}
