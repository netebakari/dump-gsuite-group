require 'json'

# A Class which handle G Suite Group
class GoogleGroups
  # Creates an empty instance.
  def initialize
    @groups = []
    @emails = []
  end

  # Adds a group
  #
  # @param id [String] group ID
  # @param email [String] group email address
  # @param description [String] description
  # @param emails [Array<String>] array of email address
  def add(id, email, name, description, emails)
    @groups.push(id: id, email: email, name: name, description: description, emails: emails.sort)
    @emails = (@emails + emails).uniq.sort
  end

  # Dumps to a JSON file
  #
  # @param filename [String] filename
  def dump_to_json(filename)
    File.open(filename, "w:utf-8"){|file| file.write(JSON.pretty_generate(@groups))}
  end

  # Dumps to a CSV file
  #
  # @param filename [String] filename
  # @param type [Symbol] `:type1` or `type2`
  # @param sep [String] separate character. A comma is default.
  # @param eol [String] new-line character. LF is default.
  def dump_to_csv(filename, type, sep = ",", eol = "\n")
    case type
      when :type1 then File.open(filename, "w:utf-8"){|file| get_csv_content_1(sep, eol){|line| file.write line }}
      when :type2 then File.open(filename, "w:utf-8"){|file| get_csv_content_2(sep, eol){|line| file.write line }}
    end
  end

  # Returns each CSV line (type-1 format)
  def get_csv_content_1(sep, eol)
    max_email_count = @groups.map{|x| x[:emails].length}.max
    first_line = ["id", "email", "name", "description"] << (1..max_email_count).map{|x| "email_#{x}"}
    yield first_line.flatten.join(sep) + eol

    for group in @groups
      line = [group[:id], group[:email], group[:name], group[:description]] << group[:emails]
      yield line.flatten.join(sep) + eol
    end
  end

  # Returns each CSV line (type-2 format)
  def get_csv_content_2(sep, eol)
    first_line = ["id", "email", "name", "description"] << @emails
    yield first_line.flatten.join(sep) + eol

    for group in @groups
      line = [group[:id], group[:email], group[:name], group[:description]]
      contained = @emails.map{|email| (group[:emails].include? email) ? "○" : ""}
      yield (line << contained).flatten.join(sep) + eol
    end
  end
end

