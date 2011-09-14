use ExtUtils::MakeMaker;

WriteMakefile
  ABSTRACT_FROM => 'lib/PNI/GUI/Tk.pm',
  AUTHOR        => 'G. Casati <fibo@cpan.org>',
  EXE_FILES     => ['pniguitk'],
  NAME          => 'PNI-GUI-Tk',
  PREREQ_PM     => {
    PNI::Core      => '0.04',
    PNI::Node::Tk  => '0.14',
    Tk::MatchEntry => '0.4',
  },
  VERSION_FROM => 'lib/PNI/GUI/Tk.pm',
