# GoCard Ruby API #

## Description ##

A simple Ruby interface to access the Queensland Transport GoCard website.
Modelled on jwpage's PHP API [https://github.com/jwpage/gocard-php-api]

Supports:

* Login
* Get Balance
* Get Activity History
* Logout

## Usage ##
    
    require 'go_card'
    go_card = GoCard.new
    go_card.login('card_number', 'password);
    p go_card->get_balance
    actions = go_card->get_history(30) # get all the journey actions for the last 30 days
    go_card->logoff()
    actions.each { |act|
      p "#{act[:time]} => #{act[:action]}, #{act[:location]}, #{act[:charge]}"
    }