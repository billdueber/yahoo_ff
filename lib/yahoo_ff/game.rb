module YahooFF
  class Game
    
    attr_accessor :teams, :week
    
    def initialize(week, team1, team2)
      @week = week;
      @team1 = team1
      @team2 = team2
      @teams = [team1, team2]
    end
  end
end

    
