require './app.rb'

User.create(fname: "Tori", lname: "Amos", username: "tamos")
User.create(fname: "Alanis", lname: "Morrissette", username: "alanis")
User.create(fname: "Rei", lname: "Ayunami", username: "gits@")
User.create(fname: "Erin", lname: "Keown", username: "ekeown")

Password.create(user_id: 1, password: "123456")
Password.create(user_id: 2, password: "123456")
Password.create(user_id: 3, password: "123456")
Password.create(user_id: 4, password: "123456")

Profile.create(user_id: 1, country: "USA")
Profile.create(user_id: 2, country: "Canada")
Profile.create(user_id: 3, country: "Japan")
Profile.create(user_id: 4, country: "USA")

Post.create(user_id: 2, title: "y kant Tori read?", body: "*snicker", favorites: 3)
Post.create(user_id: 1, title: "Isn't It Ironic", body: "...that nothing in the song is actually ironic?", favorites: 3)
Post.create(user_id: 1, title: "Album is dropping", body: "Don't worry, all of my lyrics still don't rhyme.")
Post.create(user_id: 2, title: "Album is dropping", body: "Don't worry, all of my lyrics still don't rhyme. Like someone else's who blogs here.")
Post.create(user_id: 3, title: "Don't even know why I'm a member here.", body: "I don't sing.")
Post.create(user_id: 3, title: "My favorite album is by the Police.", body: "Synchronicity. Did you guess something else, maybe?")
Post.create(user_id: 4, title: "My Mother's Wake was a little awkward.", body: "I was asked to perform 'Put the Fun in Funeral'. I demurred.")
Post.create(user_id: 4, title: "Christmas is Coming.", body: "I'm not a fan. Did you know I have a song called Santa is an @$$hole?")
