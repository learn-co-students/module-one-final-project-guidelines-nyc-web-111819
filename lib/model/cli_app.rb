require 'pry'

         # MANTRA 
         # what next?
         # give user a choice
         # get user input 
         # execute their choice
         # WHAT NEXT ?!?!?
class CliApp


    def welcome_message
       puts "Welcome to Planner"
       login_signup
    end

    def login_signup
      puts "Enter your name to start or exit to quit"
      user_input = gets.chomp
      if user_input == "exit"
         return
      else
        new_acc(user_input)
      end
   end

   # Create
   def new_acc(name)
      @current_user = User.find_or_create_by(name: name)
      main_option_menu
    end

    def main_option_menu
      puts "Would you like to see ..."
      puts "1. All Activities"
      puts "2. Just your own?"
      puts "3. Update your Info?"
      choice = gets.chomp
      handle_user_choice(choice)
   end

    def handle_user_choice(choice)

       case choice
        when '1'
         Activity.all.each do |acts|
            puts acts.name 
          end 
          puts "How about making a selection?"
            selection = gets.chomp
            add_selection(selection)
          when '2' 
            current_user_stuff = @current_user.activities.each { |activity| puts activity.name }
            puts "1. Create an Activity"
            puts "2. Unattend an Activity"
            # Read
            puts "3. Just read"
              choice = gets.chomp
              alter_activity(choice)
          when "3"
              puts "Change your name"
              update_you
          end
    end

    def add_selection(selection)
       found_selection = Activity.find_or_create_by(name: "#{selection}")
       Event.create(user_id: @current_user.id, activity_id: found_selection.id)
       puts "#{selection} was made for you"
       main_option_menu
    end

    def alter_activity(choice)
        case choice
            when "1"  
               puts "Please input an activity to save"
               activity = gets.chomp
               found_activity = Activity.find_or_create_by(name: activity)
               Event.create(user_id: @current_user.id, activity_id: found_activity.id)
               puts "#{activity} was made for you"
               here_is_your_list
            when "2"
               # Delete
               puts "Choose an activity to unattend"
               activity = gets.chomp
               found_activity = Activity.find_by(name: activity)
               binding.pry
               puts "#{found_activity.name} will be Deleted"
               Event.destroy_by(user_id: @current_user.id,  activity_id: found_activity.id)
               puts "Done!!"
               here_is_your_list
               when "3"
                  @current_user.activities.each { |activity| puts activity.name } 
                  welcome_message
         end
    end
    # Update
    def update_you
      puts "What name do you prefer?"
         new_name = gets.chomp
         # @current_user.update(name: new_name)
         @current_user.name = new_name
         @current_user.save
         puts "You are now #{new_name}"
         main_option_menu
   end

    def find_users_by_name(name)
      User.find_by(name: name).activities.each do |activity|
         puts "#{activity.users.name}"
      end
   end

   #def all_followers_by_name(name)
   #    Activity.find_by(name: name).users.each do |user|
          
   #   end
   #end

    def here_is_your_list
      @current_user.activities.reload.each { |activity| puts activity.name } 
       sleep(3)
       main_option_menu
    end

    def every_one
      User.all
    end

end
