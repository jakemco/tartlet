require "tartlet/version"

module Tartlet
  
  OUTFILE = "archive"
  TARGET = "."

  def Tartlet.extractSingle(file, zip = true, target = TARGET)

    # Generate the command
    command = "tar -x#{zip ? 'z' : ''}f #{file}"

    # Add the new target destination
    command += " -C #{target}" unless target == "."

    # Output or Run
    return command
    
  end


  def Tartlet.compressSingle(files, zip = true, target = OUTFILE)
    
    # Add the .tar if it's not there
    target += ".tar" if target[/(\.tar)(\.gz)?\z/].nil?

    # Add the .gz if it's not there and we're zipping
    target += ".gz" if target[/\.(gz)\z/].nil? and zip
    
    # Generate the command
    command = "tar -c#{zip ? 'z' : ''}f #{target} #{files.join(' ')}"
    
    # Output or Run
    return command
  end

  def Tartlet.listSingle(file, zip = true)
    return "tar -#{zip ? 'z' : ''}tvf #{file}"
  end

end
