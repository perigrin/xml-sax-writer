use inc::Module::Install;

name 'XML-SAX-Writer';
all_from 'lib/XML/SAX/Writer.pm';

requires 'Text::Iconv'             => '1.2';
requires 'XML::SAX::Exception'     => '1.01';
requires 'XML::NamespaceSupport'   => '1.00';
requires 'XML::Filter::BufferText' => '1.00';
build_requires 'Test::More'              => '0.40';

WriteAll;