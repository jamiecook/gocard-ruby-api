require 'rubygems'
require 'mechanize'
require 'time'

class GoCard
  attr_accessor :mech

  def initialize(card_no, password)
    @mech = Mechanize.new
    @mech.get('https://gocard.translink.com.au/webtix/') do |page|
      page.form_with(:action => '/webtix/welcome/welcome.do') do |f|
        f['cardOps'] = 'Display' 
        f['cardNum'] = card_no
        f['pass']    = password
      end.click_button # Submit the login form
    end
  end
  
  def logoff()
    @mech.get("https://www.seqits.com.au/webtix/welcome/welcome.do?logout=true")
    @mech = nil
  end
   
  def get_balance()
    page = @mech.get("https://gocard.translink.com.au/webtix/tickets-and-fares/go-card/online/summary")
    page.parser.xpath("//*[@class=\"go-card-table\"]").first.content =~ /(\$[0-9]*\.[0-9]*)/
    return $1
  end
  
  def get_history(period)
    start_date = Time.now - (3600 * 24 * period)
    history_page = @mech.get("https://gocard.translink.com.au/webtix/tickets-and-fares/go-card/online/history")
    result_page = history_page.form_with(:action => '/webtix/tickets-and-fares/go-card/online/history') do |form|
      form['startDate'] = start_date.strftime("%d-%b-%Y")
      form['endDate']   = Time.now.strftime("%d-%b-%Y")
    end.click_button
  
    table = result_page.parser.xpath("//*[@class='history-table']//tr")
    table.shift # Get rid of the headers
    table.shift # get rid of the date row
    table.map { |tr|
      results = tr.xpath('./td').map { |c| c.content.strip.chomp }
      { :touch_on_time  => Time.parse(results[0]), :touch_on_location  => results[1], 
        :touch_off_time => Time.parse(results[2]), :touch_off_location => results[3], :charge => results[4] 
      }
    }
  end
end