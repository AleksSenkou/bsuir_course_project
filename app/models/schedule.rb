require "open-uri"

class Schedule < ActiveRecord::Base
  has_many :lessons

  validates :group_number,
    numericality: { only_integer: true,
                    greater_than_or_equal_to: 112601,
                    less_than_or_equal_to: 474003 }, on: :create


  def group_present?
    agent = Mechanize.new
    page = agent.get("http://www.bsuir.by/schedule/allStudentGroups.xhtml")
    page.body.include?("#{group_number.to_s}")
  end

  def parse_info
    file_path = "public/groups/#{group_number}.xml"
    write_to_file(file_path)

    info = { last_name: '', first_name: '', middle_name: '',
             subject: '' }

    save_teaches_and_subjects(file_path, info)
  end

  private

  def write_to_file(file_path)
    return if File.exists?("#{file_path}")
    url = "http://www.bsuir.by/schedule/rest/schedule/#{group_number}"
    open("#{file_path}", 'wb') { |file| file << open(url).read }
  end

  def save_teaches_and_subjects(file_path, info)
    file = File.open("#{file_path}")
    doc = Nokogiri::XML(file)

    path = "//scheduleModel"
    doc.xpath(path).map do |schedule_model|
      path = "//scheduleModel//schedule" # each lesson
      schedule_model.xpath(path).map do |schedule|

        if schedule.children[5].children.text == "ФизК (вкл. СПИДиН)"
          save_info_for_sport_lesson(schedule)
          next
        end

        info[:subject] = schedule.children[7].children.text

        schedule.children[1].children.map do |i|
          info[:first_name] = i.text if i.name == 'firstName'
          info[:last_name] = i.text if i.name == 'lastName'
          info[:middle_name] = i.text if i.name == 'middleName'
        end
        # binding.pry if info[:last_name] == 'Байрак'
      end
    end
  end

  def save_info_for_sport_lesson(schedule)
    info[:subject] = "ФизК (вкл. СПИДиН)"
  end
end
