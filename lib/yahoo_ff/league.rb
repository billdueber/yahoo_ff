# Basic representation of a league.
require 'mechanize'

module YahooFF
  class League
  


    attr_accessor :login, :password, :game_weeks,
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
      @week_nums = (1..opts.fetch(:weeks, 13)).to_a
      
      self.data_dir = opts.fetch(:data_dir, '.')

      FileUtils.mkpath(@schedule_dir)
      FileUtils.mkpath(@teamweek_dir)
    end    
    
    
    def data_dir=(newdir)
      @data_dir = newdir
      @schedule_dir = "#{@data_dir}/schedules"
      @teamweek_dir = "#{@data_dir}/teamweeks"
    end
      
    

    # Log into Yahoo with the given username/password
    def login
      unless (@login and @password)
        raise "Can't log in without login and password"
      end
      
      lform = @agent.get('https://login.yahoo.com/config/login').form('login_form')
      lform.login   = @login
      lform.passwd  = @password
      begin
        @agent.submit(lform, lform.buttons.first)
      rescue Exception => e
        puts "Oops: #{e}"
      end
    end
    
    
    def load(force = false)
      get_schedules(force)
      get_team_weeks(force)
      
      sp  = YahooFF::Parser::Schedule.new(@schedule_dir)
      twp = YahooFF::Parser::TeamWeek.new(@teamweek_dir)
      
      @id_name_map = sp.id_name_map
      @schedule    = sp.schedule(@week_nums)
      
      @weeks = []
      
      @week_nums.each do |week|
        w = YahooFF::Week.new(week)
        @schedule[week].each do |opp|
          tw1 = twp.get_team_for_week(opp[0], week)
          tw2 = twp.get_team_for_week(opp[1], week)
          game = YahooFF::Game.new(week, tw1, tw2)
          w.games << game
          w.teamweeks += [tw1, tw2]
        end
        @weeks[week] = w
      end
      
    end    
    

    def get_schedules(force=false)
      raise "Tried to get_schedule without league_id" unless @id
      @week_nums.each do |week|
        filename = "#{@schedule_dir}/#{week}.html"
        unless force
          return if (File.exists? filename)
        end
        url = "http://football.fantasysports.yahoo.com/f1/#{@id}/?lhst=sched&sctype=week&scweek=#{week}"
        @agent.get(url).save(filename)
      end
    end
  
  
    def get_team_week(team, week, force=false)
      raise "Tried to get_team_week without league_id" unless @id
      url = "http://football.fantasysports.yahoo.com/f1/#{id}/#{team}?week=#{week}"
      filename = "#{@teamweek_dir}/#{team}_#{week}.html"
      unless force
        return if (File.exists? filename)
      end
      @agent.get(url).save(filename)
    end
    
  
    def get_team_weeks(force = false)
      raise "Tried to get_team_weeks without league_id" unless @id
      @teams.each do |team|
        @week_nums.each do |week|
          self.get_team_week(team, week, force)
        end
      end
    end
  end  
end