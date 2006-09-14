use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'XML::SAX::Writer',
    'VERSION_FROM'  => 'Writer.pm',
    'AUTHOR'        => 'Robin Berjon',
    'ABSTRACT'      => 'SAX2 XML Writer',
    'PREREQ_PM'     => {
                        Text::Iconv             => '1.2',
                        XML::SAX::Exception     => '1.01',
                        XML::NamespaceSupport   => '1.00',
                        Test::More              => '0.40',
                        XML::Filter::BufferText => '1.00',
                       },
);
