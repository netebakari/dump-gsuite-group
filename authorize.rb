require 'json'

SCOPE = "https://www.googleapis.com/auth/admin.directory.group.readonly"
REDIRECT = "urn:ietf:wg:oauth:2.0:oob"

def create_credentials_file(filename)
    print "input client id: "
    client_id = STDIN.gets.chop
    print "input client secret: "
    client_secret = STDIN.gets.chop
    print "open this url with browser and paste code:\n"
    print "---\n"
    print "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=#{client_id}&redirect_uri=#{REDIRECT}&scope=#{SCOPE}&access_type=offline\n"
    print "---\n"
    print "input authrorization code: "
    authorization_code = STDIN.gets.chop
    
    raw_auth_result = `curl --data "code=#{authorization_code}" --data "client_id=#{client_id}" --data "client_secret=#{client_secret}" --data "redirect_uri=#{REDIRECT}" --data "grant_type=authorization_code" --data "access_type=offline" https://www.googleapis.com/oauth2/v4/token`
    auth_result = JSON.parse(raw_auth_result)
    
    refresh_token = auth_result["refresh_token"]
    if (!refresh_token) then
        raise "authorization ended up with error!"
    end

    result = {
        client_id: client_id,
        client_secret: client_secret,
        refresh_token: refresh_token
    }

    File.open(filename, "w:utf-8"){|file| file.write(JSON.generate(result))}
    print "#{filename} created successfully\n"
end

filename = ARGV.length > 0 ? ARGV[0] : "./credentials.json"
create_credentials_file(filename)
