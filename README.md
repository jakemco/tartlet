# Tartlet

A wrapper for tar that provides sensible defaults

## Description

Tar horror stories. Everyone has one. You used the wrong flags and accidentally
overwrote one of your source files without a backup. Or you extracted a tarball
over your current directory and deleted half the updates to your project. You
spent 30 minutes scouring Google for the right set of flags to extract a zipped
tarball instead of an unzipped one. Why are there so many flags!?!

Enter Tartlet. Tartlet is a small commandline wrapper around tar that handles
the obnoxious flags for you. Need to extract an archive?

    tartlet extract thinmints.tar.gz

Mmmmmmm. Delicious extracted cookies. Need to compress a set of files?

    tartlet compress butter sugar flour --output cookie

Mmmmmmmmm. Chocolaty compressed cookies. Tartlet makes it easy to make archives
(and apparently I'm craving cookies- please hold).

## Installation


Install via gem as:

    $ gem install tartlet

## Usage

Tartlet takes a command and then a list of files, with optional flags thrown
anywhere.

### Commands

* `compress` - takes a list of files, and by default compresses them into
gzipped tarball `archive.tar.gz`

    ex:

        $ tartlet compress foo bar baz

* `extract` - takes a single zipped tarball and extracts it into the current
directory

    ex:

        $ tartlet extract archive.tar.gz

### Options

Options can be placed anywhere in the command, eg. `tartlet -d compress -o
target file1 file2` is the same as `tartlet compress file1 file2 -d -o target`
which is the same as `tartlet compress -d file1 -o target file2`. I prefer to
put -d before the command, -t after the command but before the files, and -o at
the very end, but put them in whatever order makes sense to you.

* `-o VALUE`, `--output VALUE` - instead of using the default output
(archive.tar.gz or the current directory), direct output to **VALUE**. For
compression archive name, tartlet will automatically append the proper file
suffix (.tar or .tar.gz) if it is not already provided.

    ex:

        # extract contents of archive into folder 'dirname'
        $ tartlet extract archive.tar.gz -o dirname

        # compress list of files into tarball 'files.tar.gz'
        $ tartlet compress foo bar baz -o files.tar.gz
        -- or --
        $ tartlet compress foo bar baz -o files

* `--tarball`, `-tar`, or `-t` - treat tarball as not-gzipped, e.g.
`archive.tar` (vs the default assumption of a gzipped tarball, eg
`archive.tar.gz`)

    ex:

        # extract contents of archive into current directory
        $ tartlet extract --tarball archive.tar

        # compress files into non-zipped tarball
        $ tartlet compress --tarball foo bar baz

* `--dry-run`, `--dry`, `-d` - don't execute any commands, simply print to
stdout the tar command that would be produced by tartlet

    ex:

        $ tartlet --dry compress foo bar baz --tarball -o files
        tar -cf files.tar foo bar baz

        $ tartlet extract --dry-run lotsoffiles.tar.gz -o safefolder
        tar -xzf lotsoffiles.tar.gz -C safefolder

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO Features:

* Clobber Checks:

	* **compress** - Make sure that the target archive doesn't already exist
	  before creating the file.
	
	* **extract** - Make sure that the files in the tarball don't already exist
	  in the output directory.

* Multiple Extract:

	Allow a list of files to extract, and extract all of them into separate
	directories
