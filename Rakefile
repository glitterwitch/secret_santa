require_relative 'secret_santa'

desc "read in people from a file"
task :test_create, [:filename] do |t, args|
  people_from_file(args.filename).each { |p| puts p.name }
end

desc "try to email people"
task :email_assign, [:people_file,:template_file] do |t, args|
  people = people_from_file(args.people_file)
  assign_exchange!(people)

  send_emails(people, args.template_file)
end


desc "try to assign people, print it out"
task :test_assign, [:filename] do |t, args|
  people = people_from_file(args.filename)
  assign_exchange!(people)

  people.each do |person|
    puts "#{person.name} should give to #{person.giving_to.name}"
  end
end
