# Default list of files
FILES = %w(foo bar baz)

def resetEnv
	FileUtils.rm_rf ENV['CWD'], :verbose => true
	FileUtils.mkdir ENV['CWD'], :verbose => true
  FileUtils.chdir ENV['CWD'], :verbose => true
end

def dirReplace(dir)
	return dir
end

##
# doTarball
#
# takes a path to a tarball, and flags for creating said tarball. It will create
# a tarball at the given location with files foo, bar, and baz inside.
#
def doTarball(tarball,flags = "czf")
	
	# Save the tarball and file list for later use
	@tarball = tarball
	@files = FILES
	
	# Think out that directory
	tar_dir = File.dirname(tarball)
	archive = File.basename(tarball)
	
	# Go to the directory and make that tarball
	FileUtils.chdir tar_dir,:verbose => true do

		# Confirm the file doesn't exist before touching
		@files.each do |f|
			File.exists?(f).should == false
			FileUtils.touch f, :verbose => true
			File.exists?(f).should == true
		end

		# Tar up dem files
		sh "tar -#{flags} #{archive} #{@files.join(' ')}";
		File.exists?(archive).should == true

		# Remove dem files
		@files.each do |f|
			File.exists?(f).should == true
			FileUtils.rm f, :verbose => true
			File.exists?(f).should == false
		end
	end
end

##
# Given 'a zipped tarball "x"'
#
# creates zipped tarball x with files foo, bar, and baz
#
Given(/^a zipped tarball "(.*?)"$/) do |tarball|
	resetEnv
	doTarball(tarball,"czf")
end

##
# Given 'a tarball "x"'
#
# creates tarball x with files foo, bar, and baz
#
Given(/^a tarball "(.*?)"$/) do |tarball|
	resetEnv
	doTarball(tarball,"cf")	
end

##
# Then 'the files should be extracted in the directory "x"'
#
# asserts that files foo, bar, and baz are present in the given directory
#
Then(/^the files should be extracted in the directory "(.*?)"$/) do |dir|

	#get the directory path
	file_dir = File.dirname(dir)
	
	#replace shit
	file_dir = dirReplace(file_dir)

	#put the ending back on if needed
	file_dir = File.join(file_dir, File.basename(dir))
	
	#check that it's a directory
	Dir.exist?(file_dir).should == true
	
	#go to the directory and determine that each file exists
	Dir.chdir file_dir do
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
	
	# Clear dat env
	resetEnv

	# Save dem files
	@files = files.split(' ')
	
	# Go to dat folder
	Dir.chdir ENV['CWD'] do
		
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
def filesInTarball(tarball,flags="xzf")
	#get the directory and the filename
	tar_dir = File.dirname(tarball)
	archive = File.basename(tarball)
	
	#replace current directory
	tar_dir = dirReplace(tar_dir)
	
	#rejoin for the real path
	targz = File.join(tar_dir,archive)
	
	#dat targz should exist
	File.exists?(targz).should == true
	
	#go to the directory
	FileUtils.chdir tar_dir, :verbose => true do

		# Create a new folder and move the targz there
		FileUtils.rm_rf "extract", :verbose => true if Dir.exists?("extract")
		FileUtils.mkdir "extract", :verbose => true
		
		# Copy the targz into the new folder
		FileUtils.cp archive, File.join("extract",archive), :verbose => true

		# move to the new directory and extract
		FileUtils.chdir "extract", :verbose => true do

			# Confirm the files don't exist
			@files.each do |f|
				File.exists?(f).should == false
			end

			# Extract the files
			sh "tar -#{flags} #{archive}"

			# Confirm the files DO exist
			@files.each do |f|
				File.exists?(f).should == true
			end
		end

		FileUtils.rm_rf "extract", :verbose => true
		Dir.exists?("extract").should == false
	end
	
end

##
# Then 'the files should be compressed into a zipped tarball at "x"'
#
# Determines that the zipped tarball contains @files
#
Then(/^the files should be compressed into a zipped tarball at "(.*?)"$/) do |tarball|
	filesInTarball(tarball,"xzf")	
end

##
# Then 'the files should be compressed into a tarball at "x"'
#
# Determines that the tarball contains @files
#
Then(/^the files should be compressed into a tarball at "(.*?)"$/) do |tarball|
	filesInTarball(tarball,"xf")
end
