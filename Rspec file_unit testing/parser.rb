#Function to parse the HTTP Request
#This function return the array having username and password
def process_data(request)
  begin
    if(request==nil)
      raise "NilRequestTypeException"
    end

    request_lines = request.split("\n")
    size = request_lines.length
    userdata = request_lines[size-1].split("&")
    if(userdata.length==1)
      raise "PostRequestTypeException"
    end
    info_user = userdata[0].split("=")
    info_pass = userdata[1].split("=")
    if(info_user.length==1 || info_pass.length==1)
      raise "NilDataEntryByUserException"
    end
    username = info_user[1]
    password = info_pass[1]
    userinfo = Array[username,password]
  end
  return userinfo
end


def file_auth(path,username,password)
  flag =0
  begin
    f = File.open(path, "r")
    f.each_line do |line|
      # puts line
      data = line.split(" ")
      if data[0]==username
        flag= 1
        if(data.length==1)
          raise "InsufficientUserDataException"
        end
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
  end
  f.close
end


def get_data_from_config(path,data)
  flag =0
  begin
    f = File.open(path, "r")
    f.each_line do |line|
      full_path = line.split("##")
      if full_path[0]==data
        flag =1;
        if(full_path[1]=="\n")
          raise "CompleteDataNotAvailableInConfigException"
        end
        return full_path[1]
        # break;
      end
    end
    if flag==0
      return nil
    end
  end
end

def find_config()
  current_path = Dir.pwd
  file_path = current_path+"/"+"server_files/config.txt"
  begin
    if !(File.exist?(file_path))
      raise "ConfigFileNotAvailable"
    end
  end
  return file_path
end


