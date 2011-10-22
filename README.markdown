# GoCard Ruby API #

## Description ##

A simple Ruby interface to access the Queensland Transport GoCard website.
Modelled on jwpage's PHP API [https://github.com/jwpage/gocard-php-api]

Supports:

* Login
* Get Balance
* Get Activity History
* Logout

## Requirements ##
This API requires the mechanize gem [https://github.com/tenderlove/mechanize], I haven't quite figured out how to bundle this into a gem yet so for now you will have to install it manually: 

    gem install mechanize

## Usage ##
    
    require 'go_card'
    
    go_card = GoCard.new
    
    # Login and get the account balance
    go_card.login('card_number', 'password);
    puts go_card->get_balance
    
    # get all the journey actions for the last 30 days
    go_card->get_history(30).each { |act|
      puts "#{act[:time]} => #{act[:action]}, #{act[:location]}, #{act[:charge]}"
    }
    
    go_card->logoff()
    