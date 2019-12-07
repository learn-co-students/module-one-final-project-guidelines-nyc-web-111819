# User.destroy_all
# Activity.destroy_all
# UserActivity.destroy_all

mike = User.create(name: "Mike")
gabe = User.create(name: "Gabe")
tim = User.create(name: "Tim")
bob = User.create(name: "Bob")

# la = Location.create(name: "LA")
# bk = Location.create(name: "Brooklyn")
# mia = Location.create(name: "Miami")
# nas = Location.create(name: "Nassau")
# fpo = Location.create(name: "Freeport")

surf = Activity.create(name: "surf")
sunning = Activity.create(name: "sunning")
cricket = Activity.create(name: "cricket")
bar_hop = Activity.create(name: "bar hop")
basketball = Activity.create(name: "basketball")
baseball = Activity.create(name: "baseball")
hockey = Activity.create(name: "hockey")

Event.create(user_id: mike.id, activity_id: surf.id)
Event.create(user_id: mike.id, activity_id: baseball.id)
Event.create(user_id: gabe.id, activity_id: baseball.id)
Event.create(user_id: tim.id, activity_id: bar_hop.id)
Event.create(user_id: gabe.id, activity_id: hockey.id)
Event.create(user_id: mike.id, activity_id: hockey.id)
Event.create(user_id: bob.id, activity_id: cricket.id)