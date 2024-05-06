project(
  'sexpresso',
  'cpp',
  version : '1.0.0',
  default_options : [
    'warning_level=3',
    'optimization=3',
    'cpp_std=c++11'
  ]
)

include = include_directories('include')
tests = include_directories('tests')

sexpresso = library(
  'sexpresso', [
    'src/sexpresso.cc',
  ], include_directories: include)

buildtype = get_option('buildtype')
if buildtype != 'release'
  tests_sexpresso = executable(
    'tests_sexpresso', [
      'tests/tests_sexpresso.cc',
    ], include_directories: [include, tests],
    link_with: sexpresso,
    build_by_default: false
  )

  tests_sexpresso_std = executable(
    'tests_sexpresso_std', [
      'tests/tests_sexpresso_std.cc',
    ], include_directories: [include, tests],
    link_with: sexpresso,
    build_by_default: false
  )

  test('Testing Sexpresso Library', tests_sexpresso)
  test('Testing Sexpresso STD integration', tests_sexpresso_std)
endif
