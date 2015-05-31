require "open-uri"

class Schedule < ActiveRecord::Base
  has_many :lessons, dependent: :destroy

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
    return if File.exists?("#{file_path}")

    write_to_file(file_path)
    parse_bsuir(file_path)
  end

  private

  def write_to_file(file_path)
    url = "http://www.bsuir.by/schedule/rest/schedule/#{group_number}"
    open("#{file_path}", 'wb') { |file| file << open(url).read }
  end

  def parse_bsuir(file_path)
    file = File.open("#{file_path}")
    doc = Nokogiri::XML(file)
    @day = ''

    doc.xpath("//scheduleModel").map do |schedule_model|
      schedule_model.children.map { |i| @day = i.text if i.name == 'weekDay' }
      schedule_model.children.map do |schedule|
        break if schedule.name == 'weekDay'

        info = {day: @day, week_number: '', lesson_type: '',
          class_room: '', num_subgroup: '', last_name: '',
          first_name: '', middle_name: '', subject: '', time: '' }

        content = schedule.children
        parse_info_for_lesson(content, info)
      end
    end
  end

  def parse_info_for_lesson(content, info)
    content.map do |i|
      if i.name == 'employee'
        i.children.map do |employee|
          info[:first_name]   = employee.text if employee.name == 'firstName'
          info[:last_name]    = employee.text if employee.name == 'lastName'
          info[:middle_name]  = employee.text if employee.name == 'middleName'
        end
      end

      info[:class_room]   = i.text if i.name == 'auditory'
      info[:time]         = i.text if i.name == 'lessonTime'
      info[:lesson_type]  = i.text if i.name == 'lessonType'
      info[:num_subgroup] = i.text if i.name == 'numSubgroup'
      info[:subject]      = i.text if i.name == 'subject'
      info[:week_number] << i.text if i.name == 'weekNumber'
    end

    save_info(info)
  end

  def save_info(info)
    teacher = info[:last_name] + ' ' + info[:first_name] + ' ' + info[:middle_name]

    self.lessons.create(
      teacher:      teacher,
      subject:      info[:subject],
      day:          info[:day],
      week_number:  info[:week_number],
      time:         info[:time],
      lesson_type:  info[:lesson_type],
      class_room:   info[:class_room],
      num_subgroup: info[:num_subgroup] )
  end
end
