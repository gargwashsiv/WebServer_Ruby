require 'rspec'
path = File.dirname(__FILE__)
require "#{path}/parser"

s1 = "POST /process_data HTTP/1.1\n
Host: localhost:10001\n
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:28.0) Gecko/20100101 Firefox/28.0\n
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,/;q=0.8\n
Accept-Language: en-US,en;q=0.5\n
Accept-Encoding: gzip, deflate\n
Referer: http://localhost:10001/login.html\n
Connection: keep-alive\n
Content-Type: application/x-www-form-urlencoded\n
Content-Length: 44\n

login=vishwas&password=vickygarg&commit=Login\n"

s3 = "POST /process_data HTTP/1.1\n
Host: localhost:10001\n
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:28.0) Gecko/20100101 Firefox/28.0\n
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,/;q=0.8\n
Accept-Language: en-US,en;q=0.5\n
Accept-Encoding: gzip, deflate\n
Referer: http://localhost:10001/login.html\n
Connection: keep-alive\n
Content-Type: application/x-www-form-urlencoded\n
Content-Length: 44\n

login=&password=newlife&commit=Login\n"

s4 = nil

s5 = "POST /process_data HTTP/1.1\n
Host: localhost:10001\n
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:28.0) Gecko/20100101 Firefox/28.0\n
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,/;q=0.8\n
Accept-Language: en-US,en;q=0.5\n
Accept-Encoding: gzip, deflate\n
Referer: http://localhost:10001/login.html\n
Connection: keep-alive\n
Content-Type: application/x-www-form-urlencoded\n
Content-Length: 44\n"


t1 = Array["vishwas","vickygarg"]

path ="/Users/abhishekkumar/git_projects/webserver/server_files/user.txt"
config_path = "/Users/abhishekkumar/git_projects/webserver/server_files/config.txt"

#Test Cases for Process_data method
describe 'Rspec for Parser behaviour' do
  it "If the input is valid post request output should be user Credentials" do
    expect(process_data(s1)).to eq(t1)
  end

  it "If the input is Post request with null parameters it should raise exception"  do
    expect { process_data(s3) }.to raise_error("NilDataEntryByUserException")
  end

  it "If the input is nil request it should raise exception"  do
    expect { process_data(s4) }.to raise_error("NilRequestTypeException")
  end

  it "If the input is not a valid post request it should raise exception"  do
    expect { process_data(s5) }.to raise_error("PostRequestTypeException")
  end

end


#Test Cases for file_auth method
describe 'Rspec for file_auth behaviour' do
  it "If the input is wrong file location output should be"  do
    expect {file_auth(path,"test","newlife") }.to raise_error
  end

  it "If the input is correct user credentials output should be " do
    expect(file_auth(path,"vishwas","vickygarg")).to be true
  end

  it "If the input is incorrect user credentials output should be" do
    expect(file_auth(path,"vishwas","vickygar")).to be false
  end

  it "If the input is incomplete user credentials output should be"  do
    expect {file_auth(path,"test","newlife") }.to raise_error("InsufficientUserDataException")
  end

end


#Test Cases for get_data_form_config method
describe 'Rspec for get_data_from_config behaviour' do
  it "should retrun path of file passed in parameter " do
    expect(get_data_from_config(config_path,"logfile")).to eq("/home/navyug/RubymineProjects/Web_server/server_files/log.txt\n")
  end

  it "should retrun path of file passed in parameter if available " do
    expect{get_data_from_config(config_path,"successfile")}.to raise_error("CompleteDataNotAvailableInConfigException")
  end
end

describe 'Rspec for find_config behaviour' do
it "should return path of config file if available" do
  expect(find_config()).to eq("/Users/abhishekkumar/RubymineProjects/Rspec_Test_server/server_files/config.txt")
end
end

