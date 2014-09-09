def process_data(request)
  request_lines = request.split("\n")
  size = request_lines.length
  userdata = request_lines[size-1].split("&")
  info_user = userdata[0].split("=")
  info_pass = userdata[1].split("=")
  username = info_user[1]
  password = info_pass[1]
  userinfo = Array[username,password]
  return userinfo
end
