# Exercise #8 and 9

@students = []

def print_header(names)
	if names.length <1
		puts "There are no students.".center(100)
	elsif	names.length == 1
		puts "The only student of Makers Academy".center(100)
		puts "----------------------------------".center(100)
	else
		puts "The students of Makers Academy".center(100)
		puts "------------------------------".center(100)
	end
	
end

def print_students_list(students)
# this is called iteration
	students.each_with_index do |student,i|
		puts "#{i+1}. #{student[:name]} -- (#{student[:cohort]} cohort)".center(100)
	end
end

def input_students
	puts "Please enter the names of the students."
	puts "To finish, just hit return twice."
	# @students = []
	
	#get the first name, but first create a variable so that it exists
	name = nil

	while name.nil? || !name.empty? do

		puts "First name:"
		name = STDIN.gets.chomp
		name.capitalize!

		months = [:January,:February,:March,:April,:May,:June,:July,:August,:September,:October,:November,:December]
		cohort = nil
		if !name.empty? 
		
			loop do
				puts "Cohort (in numerical format):"
				cohort = STDIN.gets.to_i
				unless (1..12).include?(cohort)
					puts "Please try again"
					redo
				end
				cohort = months[cohort-1]
				break
			end
			
			# puts the input into the array
			@students << {:name => name, :cohort => cohort}
		end
	end

	
	months = [:January,:February,:March,:April,:May,:June,:July,:August,:September,:October,:November,:December]
	
	# sorts the array of students by cohort
	@students.sort {|x,y| months.index(x[:cohort]) <=> months.index(y[:cohort])} 
	
	# sorts the array by name
	# students.sort {|x,y| x[:name] <=> y[:name] } 


end


def print_footer(names)
	if names.length <1
		puts "No students enrolled.".center(100)
	elsif names.length == 1
		puts "Overall, we have #{names.length} great student.".center(100)
	else
		puts "Overall, we have #{names.length} great students.".center(100)
	end
end


def print_cohorts(students)


	months = [:January,:February,:March,:April,:May,:June,:July,:August,:September,:October,:November,:December]
	cohort = nil
			loop do
				puts "Which cohort would you like to see? Please select the month in numerical format."
				cohort = STDIN.gets.to_i
				unless (1..12).include?(cohort)
					puts "Please try again"
					redo
				end
				cohort = months[cohort-1]
				break
			end	
			
# This is how you select students of a particular cohort
	if 	@students.length == 0
		puts "There are no students enrolled in that cohort."

	elsif @students.count > 1	
		puts "The students of the #{cohort} cohort are:".center(100)
		@students.select{|student| student[:cohort] == cohort}.each_with_index do |student,i|
		puts "#{i+1}. #{student[:name]} -- (#{student[:cohort]} cohort)".center(100)
		end

	elsif @students.count == 1
		puts "The only student of the #{cohort} cohort is:".center(100)
		@students.select{|student| student[:cohort] == cohort}.each_with_index do |student,i|
		puts "#{i+1}. #{student[:name]} -- (#{student[:cohort]} cohort)".center(100)
		end

	end
end

def print_students
	puts "Do you want to 1.) Print all students? or 2.) Print by cohorts? Please choose '1' or '2'"
	option = STDIN.gets.to_i
	if option == 1
		print_header(@students)
		print_students_list(@students)
		print_footer(@students)
		interactive_menu
	elsif option == 2
		print_cohorts(@students)
		interactive_menu
	else
		puts "Invalid choice. Please choose between 1 or 2."
		option.STDIN.gets.to_i
	end
end

def interactive_menu
	loop do
	
	print_menu
	process(STDIN.gets.to_i)

	end
end

def print_menu
	puts "What do you want to do next?"
	puts "1.) Input more students" 
	puts "2.) Print names"
	puts "3.) Remove a name"
	puts "4.) Save the list to students.csv"
	puts "9.) Exit"
end

def process(selection)
	case selection
		when 1
			input_students
		when 2
			print_students
		when 3
			remove_name
		when 4
			save_students	
		when 9
			exit
		else
			puts "I don't know what you mean, please try again."
			print_menu
		end
end		

def save_students
	# open the file for writing
	file = File.open("students.csv", "w")
	# iterate over the array of students
	@students.each do |student|
		student_data = [student[:name], student[:cohort]]
		csv_line = student_data.join(",")
		file.puts csv_line
	end
# delete??
	file.close
end	

def load_students(filename = "students.csv")
	file = File.open(filename, "r")
	file.readlines.each do |line|
		name, cohort = line.chomp.split (',')
		@students << {name: name, cohort: cohort.to_sym}
	end
	file.close
end	

def try_load_students
	filename = ARGV.first
	if filename.nil?
		load_students
	elsif File.exists?(filename)
		load_students(filename)
		puts "Loaded #{@students.length} from #{filename}"
	else
		puts "Sorry, #{filename} does not exist."
		exit
	end
end

def remove_name
	puts "Which name do you want to delete?"
	puts "Please select the number"
	print_students_list(@students)
	print "Delete: "
	name = gets.to_i - 1
	@students.delete_at(name)
end

try_load_students
@students = input_students
interactive_menu

