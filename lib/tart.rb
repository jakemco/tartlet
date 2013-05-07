require "tart/version"

module Tart
  
  include Methadone::CLILogging
  include Methadone::SH

  OUTFILE = "archive"
  TARGET = "."

  def Tart.extractSingle(file, zip = true, dry = false, target = ".")

    # Generate the command
    command = "tar -x#{zip ? 'z' : ''}f #{file}"

    # Add the new target destination
    command += " -C #{target}" unless target == "."

    # Output or Run
    if dry then puts command else sh command end

  end


  def Tart.compressSingle(files, zip = true, dry = false, target = OUTFILE)
    
    # Add the .tar if it's not there
    target += ".tar" if target[/(\.tar)(\.gz)?\z/].nil?

    # Add the .gz if it's not there and we're zipping
    target += ".gz" if target[/\.(gz)\z/].nil? and zip
    
    # Generate the command
    command = "tar -c#{zip ? 'z' : ''}f #{target} #{files.join(' ')}"
    
    # Output or Run
    if dry then puts command else sh command end
  end

end
