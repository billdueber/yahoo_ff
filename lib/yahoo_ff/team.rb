# A team *for a given week*

module YahooFF
  class Team
    
    attr_reader :team_id, :week
    attr_accessor :players
    def initialize(team_id, week, players)
      @team_id = team_id
      @week = week
      @players = players
    end
    
    def actual_points
      return self.points(->(p){p.played?})
    end
    
    def best_points(positions = %w[QB WR RB TE WRRB K DEF])
      return best_roster(positions).points
    end

    def points(filter = ->(x){true})
      @players.inject(0) {|sum, p| filter.call(p) ? sum + p.points : sum}
    end

    def best_roster(positions = %w[QB WR RB TE WRRB K DEF])
      possible = @players.dup.sort {|a,b| b.points <=> a.points} 
      best_roster = []
      positions.each do |pos|
        possible.each do |p|
          if p.slot_to? pos
            best_roster << p
            break
          end
        end
      end
      return self.class.new(@team_id, @week, best_roster)
    end
      

  end
end
      
