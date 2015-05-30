require "open-uri"

class Schedule < ActiveRecord::Base
  validates :group_number,
    numericality: { only_integer: true,
                    greater_than_or_equal_to: 112601,
                    less_than_or_equal_to: 474003 }, on: :create

  def group_present?
    agent = Mechanize.new
    page = agent.get("http://www.bsuir.by/schedule/allStudentGroups.xhtml")
    page.body.include?("#{group_number.to_s}")
  end

  def write_to_file
    file_path = "public/groups/#{group_number}.xml"
    return if File.exists?("#{file_path}")

    url = "http://www.bsuir.by/schedule/rest/schedule/#{group_number}"
    open("#{file_path}", 'wb') { |file| file << open(url).read }
  end
end
