
###
# XML::SAX::Writer tests
# Petr Cimprich <petr@gingerall.com>
# 09/11/2006 - v0.01
###

use strict;

use Test::More tests => 3;
use XML::SAX::Writer qw();

my $isoL1 = ($^O eq 'VMS') ? 'iso8859-1' : 'iso-8859-1';
my $out = '';
my $str1 = 'foo'; 
my $str2 = 'žščřďťňáéíóůúý'; # can't be encoded in iso-8859-1


##################################################
# encoding test
my $w = XML::SAX::Writer->new({
                                EncodeFrom  => 'utf-8',
                                EncodeTo    => $isoL1,
                                Output      => \$out,
                               })->{Handler};

$w->start_document;
$w->start_element({Name	=> 'root', 
		   Prefix => '', 
		   LocalName => 'root',
		   NamespaceURI => '',
		   Attributes => {}});
$w->characters({Data => $str1});
$w->end_element({Name	=> 'root', 
		 Prefix => '', 
		 LocalName => 'root',
		 NamespaceURI => ''});
$w->end_document;
#print $out;

ok($out eq "<root>$str1</root>", 'ASCII characters');


##################################################
# encoding error - char does not exist in a codepage
$w = XML::SAX::Writer->new({
                             EncodeFrom  => 'utf-8',
                             EncodeTo    => $isoL1,
                             Output      => \$out,
                            })->{Handler};

# silent warnings since now
$SIG{__WARN__} = sub {};

$w->start_document;
$w->start_element({Name	=> 'root', 
		   Prefix => '', 
		   LocalName => 'root',
		   NamespaceURI => '',
		   Attributes => {}});
$w->characters({Data => $str2});
$w->end_element({Name	=> 'root', 
		 Prefix => '', 
		 LocalName => 'root',
		 NamespaceURI => ''});
$w->end_document;

ok($out eq "<root>_LOST_DATA_</root>", 'Latin2 characters');

##################################################
# Whitespace not properly escaped in attribute values #11
# https://github.com/perigrin/xml-sax-writer/issues/11

$w = XML::SAX::Writer->new({Output => \$out})->{Handler};
$w->start_document;
$w->start_element({
    Name	=> 'root', 
    Prefix => '', 
    LocalName => 'root',
    NamespaceURI => '',
    Attributes => {
        whitespace => {
            Name	=> 'whitespace', 
            Prefix => '', 
            LocalName => 'whitespace',
            NamespaceURI => '',
            Value => "tab=[\t],newline=[\n],carriage_return=[\r]"
        }
    }
});
$w->end_element({Name	=> 'root', 
		 Prefix => '', 
		 LocalName => 'root',
		 NamespaceURI => ''});
$w->end_document;
is($out, 
    "<root whitespace='tab=[&#x9;],newline=[&#xA;],carriage_return=[&#xD;]' />", 
    'attributes with whitespace');
