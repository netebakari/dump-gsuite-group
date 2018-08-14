require 'json'
require './lib/credentials.rb'
require './lib/group.rb'

# A Class which handling Google API
class GoogleApiManager
  # constructor
  #
  # @param credentials [Credentials] Credentials
  def initialize(credentials)
    @access_token = credentials.get_new_token
  end

  # get all the members who joins the given group and return the email addresses
  #
  # @param group_id [String] G Suite group id
  # @return [Array<String>] an array of email(string)
  def get_member(group_id)
    raw_result = `curl -H "Authorization: Bearer #{@access_token}" https://www.googleapis.com/admin/directory/v1/groups/#{group_id}/members`
    parsed = JSON.parse(raw_result)
    parsed["members"].map{|x| x["email"]}
  end

  # get all the groups
  #
  # @param domain [String] domain（cf: example.com）
  # @return [Array<Hash>] array of groups
  def get_groups(domain)
    raw_result = `curl -H "Authorization: Bearer #{@access_token}" https://www.googleapis.com/admin/directory/v1/groups?domain=#{domain}`
    parsed = JSON.parse(raw_result)
    return parsed["groups"].map{|x| {id: x["id"], email: x["email"], name: x["name"], description: x["description"]}}
  end
end

if (ARGV.length == 0) then
  raise "domain required!"
end

# first argument is domain
domain = ARGV[0]

# second argument is the credential file (if ommited, "./credentials.json" used)
filename = ARGV.length > 1 ? ARGV[1] : "./credentials.json"

# read credentials and create a new GoogleApiManager instance
credentials = Credentials.from_file(filename)
api = GoogleApiManager.new(credentials)
groups = GoogleGroups.new

for group in api.get_groups(domain)
  members = api.get_member(group[:id])
  groups.add(group[:id], group[:email], group[:name], group[:description], members)
end


# dump. Specify CSV separates(comma or tab or something), new-line character(CR or LF or CRLF) here.
groups.dump_to_json("dump_#{domain}.json")
groups.dump_to_csv("dump_#{domain}_1.csv", :type1, ",", "\n")
groups.dump_to_csv("dump_#{domain}_2.csv", :type2, ",", "\n")
