
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Client library to interact with L<LCDproc|http://lcdproc.sourceforge.net/>",
  "dist_author" => [
    "Ioan Rogers <ioanr\@cpan.org>"
  ],
  "dist_name" => "Net-LCDproc",
  "dist_version" => "0.1.0",
  "license" => "gpl",
  "module_name" => "Net::LCDproc",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Data::Dumper" => 0,
    "IO::Socket::INET" => 0,
    "Log::Any" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "Readonly" => 0,
    "Throwable::Error" => 0,
    "namespace::autoclean" => 0,
    "perl" => "v5.10.0"
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
