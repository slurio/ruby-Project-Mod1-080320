require 'pry'
require 'tty-prompt'
require 'colorize'
require 'tty-color'
require 'tty-box'
require 'catpix'

class CLI


    def self.start_game
        prompt = TTY::Prompt.new
        selection = prompt.select("What would you like to do?") do |menu|
            menu.choice name: "Start Game".colorize(:green), value: 1
            menu.choice name: "Stop Music".colorize(:light_yellow), value: 2
            menu.choice name: "Quit".colorize(:red), value: 3
        end
        if selection == 3
            box = TTY::Box.frame(width: 30, height: 8, align: :center, border: :thick, padding: 2) do "Thank you for playing!  Sam L. & Russ S." end
                puts box.colorize(:red)
                pid = fork{ exec 'killall', 'afplay' }
                sleep(3)
                exit!
        elsif selection == 2
            pid = fork{ exec 'killall', 'afplay' }
            CLI.start_game
        else selection == 1
            return true
        end
    end


    pid = fork{ exec 'afplay', 'assets/music/got_main_theme_very_extended.mp3'}
    # pid = fork{ exec ‘killall’, “afplay” }
    def start
        prompt = TTY::Prompt.new
        box = TTY::Box.frame(width: 30, height: 8, align: :center, border: :thick, padding: 2) do "Welcome to Game of Thrones CLI RPG!" end
        puts box.colorize(:light_red)
        sleep (2)
        user = User.login
        user.create_skill_set #if new user
        user.start_game
        house_selection = prompt.select("Please pick a house") do |menu|
            menu.choice name: "House Stark of Winterfell".colorize(:light_blue), value: 1
            menu.choice name: "House Lannister of Casterly Rock".colorize(:light_red), value: 2, disabled: "(Everyone in this house is dead.)"
            menu.choice name: "House Baratheon of Storms End".colorize(:light_yellow), value: 3, disabled: "(This house is dead, too.)"
            end
        if house_selection == 1
            UserHouse.find_or_create_by(user_id: user.id, house_id: House.first.id)
            box = TTY::Box.frame(width: 30, height: 8, align: :center, border: :thick, padding: 2) do "Welcome to House Stark, #{user.name} Stark." end
            puts box.colorize(:light_blue)
            # sleep (2)
            prompt.select("Enter Winterfell".colorize(:light_blue), %w(Enter))
            House.first.welcome_home
        end
    end
end