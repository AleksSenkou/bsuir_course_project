require 'open-uri'

class Lesson < ActiveRecord::Base
  has_many :comments
  belongs_to :schedule

  def parse_info_about_teacher
    views = []
    teacher_url = find_teacher_url
    page = Nokogiri::HTML(open(teacher_url))

    page_info = page.css('div.comment.odd.clear-block').css('div.content')
    page_info.map { |i| views << i.text}

    views.each do |view|
      self.comments.create(content: view)
    end
  end

  private

  def find_teacher_url
    helper_url = "http://bsuir-helper.ru"
    teacher_url = "#{helper_url}"
    url_for_teachers = "#{helper_url}/lectors"

    page = Nokogiri::HTML(open(url_for_teachers))
    page.css('a').map { |a| teacher_url << a["href"] if a.text == teacher }

    teacher_url
  end
end
