#Function to authenticate the user
def file_auth(path,username,password)
  flag =0
  f = File.open(path, "r")
  f.each_line do |line|
    # puts line
    data = line.split(" ")
    if data[0]==username
      flag= 1
      if data[1]==password
        puts "successfully authenticated"
        return true
      else
        puts "wrong passoword"
        return false
      end
    end
  end
  if flag==0
    puts "User's credentials are not available"
    return false
  end
  f.close
end

#Function to store the content of a file in a string
def file_to_string(path)
  file = File.open(path, "rb")
  response = file.read
  return response
end

#Function to read the config file
def get_data_from_config(path,data)
  flag =0
  f = File.open(path, "r")
  f.each_line do |line|
    full_path = line.split("##")
    if full_path[0]==data
      flag =1;
      return full_path[1]
      # break;
    end
  end
  if flag==0
    return nil
  end
end


#Function to check if the file exist in a folder or not
def file_exist(name)
  if File.exist?(name)
    return true
  else
    return false
  end
end


#Function to get the current directory
def find_config()
  current_path = Dir.pwd
  file_path = current_path+"/"+"server_files/config.txt"
  return file_path
end

=begin
#Testing our application
#config_path = find_config()
#dataname = get_data_from_config(config_path,"userfile")
#data = file_auth(dataname.chop!,"vishwas","vickygarg")
#puts data
=end