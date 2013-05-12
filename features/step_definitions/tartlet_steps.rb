# Default list of files
FILES = %w(foo bar baz)
TMP = "tmp/aruba"

##
# doTarball
#
# takes a path to a tarball, and flags for creating said tarball. It will create
# a tarball at the given location with files foo, bar, and baz inside.
#
def doTarball(tarball,zip = true)
	
	# Save the tarball and file list for later use
	@tarball = tarball
	@files = FILES
	
	# Think out that directory
	tar_dir = File.dirname(tarball)
	archive = File.basename(tarball)
	
	# Go to the directory and make that tarball
	FileUtils.chdir File.join(TMP,tar_dir),:verbose => true do

		# Confirm the file doesn't exist before touching
		@files.each do |f|
			File.exists?(f).should == false
			FileUtils.touch f, :verbose => true
			File.exists?(f).should == true
		end

		# Tar up dem files
		sh "tar -c#{zip ? 'z' : ''}f #{archive} #{@files.join(' ')}";
		File.exists?(archive).should == true

		# Remove dem files
		@files.each do |f|
			File.exists?(f).should == true
			FileUtils.rm f, :verbose => true
			File.exists?(f).should == false
		end
	end
  
  File.exists?(File.join(TMP,tar_dir,archive)).should == true
end

##
# Given 'a zipped tarball "x"'
#
# creates zipped tarball x with files foo, bar, and baz
#
Given(/^a zipped tarball "(.*?)"$/) do |tarball|
	doTarball(tarball,true)
end

##
# Given 'a tarball "x"'
#
# creates tarball x with files foo, bar, and baz
#
Given(/^a tarball "(.*?)"$/) do |tarball|
	doTarball(tarball,false)	
end

##
# Then 'the files should be extracted in the directory "x"'
#
# asserts that files foo, bar, and baz are present in the given directory
#
Then(/^the files should be extracted in the directory "(.*?)"$/) do |dir|

	#go to the directory and determine that each file exists
	Dir.chdir File.join(TMP,dir) do
		@files.each do |file|
			File.exist?(file).should == true
		end
	end
end

##
# Given 'a list of files "x" at "y"'
#
# creates files from space delimited list x in directory y
#
Given(/^a list of files "(.*?)"$/) do |files|
	
	# Save dem files
	@files = files.split(' ')
	
	# Go to dat folder
	Dir.chdir TMP do
		
		# For each file, touch it
		@files.each do |f|
			File.exists?(f).should == false
			FileUtils.touch f, :verbose => true
			File.exists?(f).should == true
		end
	end
end

##
# filesInTarball
#
# Determines that a tarball has @files in it when extracted with given flags.
#
def filesInTarball(tarball,zip=true)

	#get the directory and the filename
	tar_dir = File.dirname(tarball)
	archive = File.basename(tarball)
	
	#rejoin for the real path
	targz = File.join(tar_dir,archive)
	
	#dat targz should exist
	File.exists?(File.join(TMP,targz)).should == true
	
	#go to the directory
	FileUtils.chdir File.join(TMP,tar_dir), :verbose => true do

    # Extract the files
    files = `tar -t#{zip ? 'z' : ''}f #{archive}`.split("\n");
    
    (files.sort == @files.sort).should == true
    
	end
	
end

##
# Then 'the files should be compressed into a zipped tarball at "x"'
#
# Determines that the zipped tarball contains @files
#
Then(/^the files should be compressed into a zipped tarball at "(.*?)"$/) do |tarball|
	filesInTarball(tarball,true)	
end

##
# Then 'the files should be compressed into a tarball at "x"'
#
# Determines that the tarball contains @files
#
Then(/^the files should be compressed into a tarball at "(.*?)"$/) do |tarball|
	filesInTarball(tarball,false)
end
