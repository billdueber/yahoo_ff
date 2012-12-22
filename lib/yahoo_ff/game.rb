module YahooFF
  class Game
    
    attr_accessor :teams, :week
    
    def initialize(week, team1, team2)
      @week = week;
      @team1 = team1
      @team2 = team2
      @teams = [team1, team2]
    end
    
      
    def team(team_id)
      return @team1 if @team1.team_id == team_id
      return @team2 if @team2.team_id == team_id
      return nil
    end
    
    def opp(team_id)
      return @team2 if @team1.team_id == team_id
      return @team1 if @team2.team_id == team_id
      return nil
    end
            
    
    def winner(meth = :actual_points)
      t1 = @team1.send(meth) 
      t2 = @team2.send(meth)
      return @team1 if t1 > t2
      return @team2 if t2 > t1
      return nil
    end
    
  end
end

    
