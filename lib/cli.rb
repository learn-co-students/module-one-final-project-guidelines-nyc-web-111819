




def run
    welcome
    create_user

end


def welcome
#welcome
puts "Welcome to Music Source"
puts "Input name"
end

def create_user
#login to get username
user_name = gets.chomp
User.create(name: "#{user_name}") 
end


