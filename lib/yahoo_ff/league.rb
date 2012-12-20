# Basic representation of a league.
require 'mechanize'

module Yahoo_FF
  class League
  


    attr_accessor :login, :password, 
                  :id, :teams, :weeks, :data_dir
  
    #@param Hash opts Options
    #@option opts [String] :username Your Yahoo username
    #@option opts [String] :password Your Yahoo password
    #@option opts [String] :league_id The league ID
    #@option opts [Integer] :teams Number of teams
    #@option opts [Weeks] :weeks Weeks in the season
    #@option opts [String] :data_dir Directory to save data
  
  
    def initialize(opts)
      @agent =  Mechanize.new
      @agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
      @login = opts.fetch(:username, 'wdueber')
      @password = opts.fetch(:password,'schlepp')
      @id = opts.fetch(:league_id)
      @teams = (1..opts.fetch(:teams)).to_a
      @weeks = (1..opts.fetch(:weeks, 13)).to_a
      @data_dir = opts.fetch(:save_dir, '.')
    
      @schedule_dir = "#{@data_dir}/schedules"
      @teamweek_dir = "#{@data_dir}/teamweeks"

      FileUtils.mkpath(@schedule_dir)
      FileUtils.mkpath(@teamweek_dir)

      login
    end    
    

    # Log into Yahoo with the given username/password
    def login
      lform = @agent.get('https://login.yahoo.com/config/login').form('login_form')
      lform.login   = @login
      lform.passwd  = @password
      begin
        @agent.submit(lform, lform.buttons.first)
      rescue Exception => e
        puts "Oops: #{e}"
      end
    end
  

    def get_schedules(force=false)
      @weeks.each do |week|
        filename = "#{@schedule_dir}/#{week}.html"
        unless force
          return if (File.exists? filename)
        end
        url = "http://football.fantasysports.yahoo.com/f1/#{@id}/?lhst=sched&sctype=week&scweek=#{week}"
        @agent.get(url).save(filename)
      end
    end
  
  
    def get_team_week(team, week, force=false)
      url = "http://football.fantasysports.yahoo.com/f1/#{id}/#{team}?week=#{week}"
      filename = "#{@teamweek_dir}/#{team}_#{week}.html"
      unless force
        return if (File.exists? filename)
      end
      @agent.get(url).save(filename)
    end
    
  
    def get_team_weeks(force = false)
      @teams.each do |team|
        @weeks.each do |week|
          self.get_team_week(team, week, force)
        end
      end
    end
  end  
end