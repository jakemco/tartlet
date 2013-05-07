Feature: Sane Use of tar
  In order to compress a set of files into a tarball or extract files from a tarball
  I want a simple command
  So I don't have to remember tar flags

  Scenario: Basic UI
    When I get help for "tart"
    Then the exit status should be 0
    And the banner should be present
    And there should be a one line summary of what the app does
    And the banner should include the version
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |--output|
      |--tarball|
    And the banner should document that this app's arguments are:
      |command|which is required|
      |files|which is many|

  Scenario: Extract Zipped Tarball
    Given a zipped tarball "archive.tar.gz"
    When I successfully run `tart extract archive.tar.gz`
    Then the files should be extracted in the directory "."

  Scenario: Extract Tarball
    Given a tarball "archive.tar"
    When I successfully run `tart --tar extract archive.tar`
    Then the files should be extracted in the directory "."

  Scenario: Compress Zipped Tarball
    Given a list of files "foo bar baz"
    When I successfully run `tart compress foo bar baz`
    Then the files should be compressed into a zipped tarball at "archive.tar.gz"

  Scenario: Compress Tarball
    Given a list of files "foo bar baz"
    When I successfully run `tart --tar compress foo bar baz`
    Then the files should be compressed into a tarball at "archive.tar"
