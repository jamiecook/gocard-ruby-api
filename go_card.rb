require 'rubygems'
require 'mechanize'
require 'time'

class GoCard
  def initialize()
    @mech = Mechanize.new
  end
  
  def login(card_no, password)
    @mech.get('https://www.seqits.com.au/webtix/welcome/welcome.do/') do |page|
      # Click the login link
      #login_page = a.click(page.link_with(:text => /Log In/))
  
      # Submit the login form
  	  page = page.form_with(:action => '/webtix/welcome/welcome.do') do |f|
        f['cardOps'] = 'Display' 
        f['cardNum'] = card_no
        f['pass']    = password
      end.click_button
    end
  end
  
  def logoff()
    @mech.get("https://www.seqits.com.au/webtix/welcome/welcome.do?logout=true")
    @mech = nil
  end
   
  def get_balance()
    raise "Did you forget to login?" unless @mech
    page = @mech.get("https://www.seqits.com.au/webtix/cardinfo/summary.do")
    page.parser.xpath("//*[@class=\"results_table\"]").first.content =~ /(\$[0-9]*\.[0-9]*)/
    return $1
  end
  
  def get_history(period)
    start_date = Time.now - (3600 * 24 * period)
    history_page = @mech.get("https://www.seqits.com.au/webtix/cardinfo/history.do")
    result_page = history_page.form_with(:action => '/webtix/cardinfo/history.do') do |form|
      form['startDate'] = start_date.strftime("%d-%b-%Y")
      form['endDate']   = Time.now.strftime("%d-%b-%Y")
    end.click_button
  
    table = result_page.parser.xpath("//*[@class='results_table']//tr")
    table.shift # Get rid of the headers
    table.map { |tr|
      results = tr.xpath('./td').map { |c| c.content.strip.chomp }
      { :time => Time.parse(results[0]), :action => results[1], :location => results[2], :charge => results[3] }
    }
  end
end
