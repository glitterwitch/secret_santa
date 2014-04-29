require_relative 'mailer'

def people_from_file(filename)
  File.open(filename, "r").lines.map do |line|
    (id, name, details, email, exclusions) = line.split(',')
    person = Person.new(id: id, email: email, name: name, details: details)
    person.add_exclusions(exclusions.chomp.split(';')) if !!exclusions
    person
  end
end

def assign_exchange!(people)

  while (!people.all?{|p| p.satisfied?}) do
    recipients = Array.new(people)

    people.each do |person|
      person.giving_to = recipients.delete(recipients.reject{|r| r == person}.sample)
    end
  end

  people
end

def send_emails(people, template_file)
  return if !people.all? {|p| p.satisfied?}

  template = File.open(template_file, "r").read
  people.each do |person|
    body = template.gsub("%%NAME%%", person.name)
                   .gsub("%%GIVING_TO%%", person.giving_to.name)
                   .gsub("%%DETAILS%%", person.giving_to.details)

    #puts body
    Mailer.send_email(person.email, ENV['EMAIL_SUBJECT'], body)
  end
end

class Person
  attr_accessor :id
  attr_accessor :email
  attr_accessor :name
  attr_accessor :details
  attr_accessor :exclusions
  attr_accessor :giving_to

  def satisfied?
    !!@giving_to && !@exclusions.include?(@giving_to.id)
  end

  def initialize(opts = {})
    @id = opts[:id]
    @email = opts[:email]
    @name = opts[:name]
    @details = opts[:details]
    @exclusions = []
  end

  def add_exclusions(ids)
    @exclusions += ids
    @exclusions.uniq!
    self
  end
end
