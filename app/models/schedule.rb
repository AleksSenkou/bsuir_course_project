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
    write_to_file(file_path)
    parse_bsuir(file_path)
  end

  private

  def write_to_file(file_path)
    return if File.exists?("#{file_path}")
    url = "http://www.bsuir.by/schedule/rest/schedule/#{group_number}"
    open("#{file_path}", 'wb') { |file| file << open(url).read }
  end

  def parse_bsuir(file_path)
    file = File.open("#{file_path}")
    doc = Nokogiri::XML(file)
    info = {}
    @day = ''
    @count = 0

    doc.xpath("//scheduleModel").map do |schedule_model|
      schedule_model.children.map { |i| @day = i.text if i.name == 'weekDay' }
      schedule_model.children.map do |schedule|
        break if schedule.name == 'weekDay'

        info = {week_number: '', day: @day}
        content = schedule.children

        if content[5].text == "ФизК (вкл. СПИДиН)"
          parse_info_for_sport_lesson(content, info)
          next
        end

        parse_info_for_normal_lesson(content, info)
        @count += 1
      end
    end
  end

  def parse_info_for_normal_lesson(content, info)
    content[1].children.map do |i|
      info[:first_name]  = i.text if i.name == 'firstName'
      info[:last_name]   = i.text if i.name == 'lastName'
      info[:middle_name] = i.text if i.name == 'middleName'
    end

    info[:class_room]    = content[0].text
    info[:time]          = content[2].text
    info[:lesson_type]   = content[3].text
    info[:num_subgroup]  = content[5].text
    info[:subject]       = content[7].text

    content.map do |i|
      info[:week_number] << i.text if i.name == 'weekNumber'
    end

    save_info(info)
  end

  def parse_info_for_sport_lesson(content, info)
    content.map do |i|
      info[:week_number] << i.text if i.name == 'weekNumber'
    end

    info[:last_name]    = ''
    info[:middle_name]  = ''
    info[:first_name]   = ''
    info[:class_room]   = ''
    info[:time]         = content[0].text
    info[:lesson_type]  = content[1].text
    info[:num_subgroup] = content[3].text
    info[:subject]      = content[5].text

    save_info(info)
  end

  def save_info(info)
    teacher = info[:last_name] + ' ' + info[:first_name] + ' ' + info[:middle_name]

    @lesson = self.lessons.create_with(subject: info[:subject]).find_or_create_by(teacher: teacher)

    @lesson.options.create( day:          info[:day],
                            week_number:  info[:week_number],
                            time:         info[:time],
                            lesson_type:  info[:lesson_type],
                            class_room:   info[:class_room],
                            num_subgroup: info[:num_subgroup] )
  end
end
