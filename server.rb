require 'socket'
require 'uri'
load 'parser.rb'
load 'file_handling.rb'


#Parse the current request to get the required file
def parse_request(request)
  request_element = request.split(" ")
  request_line = request_element[1]
  uri = URI(request_line)
  path = (uri.path)
  return path
end

#Hash to store the content type of our file
#We are assuming for two type of files for now
file_content_type = Hash["html"=> "text/html","txt"=>"text/plain"]

def content_type(path)
  ext = File.extname(path).split(".").last
  return ext
end

#Function to write a particular file on the socket
def write_on_socket(path,hash={},socket)
  if File.exist?(path) && !File.directory?(path)
    ext = content_type(path)
    File.open(path, "rb") do |file|
      socket.print "HTTP/1.1 200 OK\r\n" +
                       "Content-Type: #{hash[ext]}\r\n" +
                       "Content-Length: #{file.size}\r\n" +
                       "Connection: close\r\n"

      socket.print "\r\n"
      IO.copy_stream(file, socket)
    end
  else
    current_dir = Dir.pwd
    errorfile_path = current_dir+"/server_files/error.html"
    file = File.open(errorfile_path, 'rb')
    response = file.read
    socket.print "HTTP/1.1 200 ok\r\n "+
                     "Content-Type: text/html\r\n"+
                     "Content-Length: #{response.bytesize}\r\n"+
                     "connection: close \r\n"
    socket.print "\r\n"
    socket.print response
  end
end

#Opening a server at the localhost and a particular port number
server = TCPServer.new('localhost',10001)
loop do
  socket = server.accept
  request_body = socket.recv(1024)
  request_lines = request_body.split("\n")
  first_line = request_lines[0].split(" ")
  if first_line[0]=="GET"
    file_name = parse_request(request_lines[0])
    parent_path = Dir.pwd
    file_path = parent_path+"/"+"server_files"+file_name
    write_on_socket(file_path,file_content_type,socket)
  elsif first_line[0]=="POST"
    method_name = first_line[1][1..-1]
    if method_name =="process_data"
       userinfo = process_data(request_body)
       config_path = find_config()
       dataname = get_data_from_config(config_path,"userfile")
       data = file_auth(dataname.chop!,userinfo[0],userinfo[1])
       if data
           write_on_socket("/home/navyug/RubymineProjects/Web_server/server_files/success.html",file_content_type,socket)
       else
          write_on_socket("/home/navyug/RubymineProjects/Web_server/server_files/failure.html",file_content_type,socket)
       end
    end
  else
    puts "Unknown request type"
  end
end
socket.close