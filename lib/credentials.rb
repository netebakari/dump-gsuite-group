require 'json'

# A class which read/write the credentials file and refreshes access token
class Credentials
  # Acquire client id, client secret, refresh token and creates a new instance
  #
  # @param client_id [String] client id
  # @param client_secret [String] client secret
  # @param refresh_token [String] refresh token
  def initialize(client_id, client_secret, refresh_token)
    @client_id = client_id
    @client_secret = client_secret
    @refresh_token = refresh_token
  end

  # Kick the Google Oauth API and acquire a new access token.
  # Because an access token expires in a short time, we have to get a new one every time.
  #
  # @return [String] a new access token
  def get_new_token()
    result = `curl --data "refresh_token=#{@refresh_token}" --data "client_id=#{@client_id}" --data "client_secret=#{@client_secret}" --data "grant_type=refresh_token" https://www.googleapis.com/oauth2/v4/token`
    return JSON.parse(result)["access_token"]
  end

  # Creates new instance from credentials file
  #
  # @param filename [String] filename
  # @return [Credentials] instance
  def self.from_file(filename)
    content = File.open(filename, "r:utf-8"){|file| file.read}
    credentials = JSON.parse(content)
    return Credentials.new(credentials["client_id"], credentials["client_secret"], credentials["refresh_token"])
  end

  # Generates a credentials file
  #
  # @param filename [String] filename. should end with ".json"
  def put_file(filename)
    content = {
      client_id: @client_id,
      client_secret: @client_secret,
      refresh_token: @refresh_token
    }
    File.open(filename, "w:utf-8"){|file| file.write(JSON.generate(result))}
  end
end
