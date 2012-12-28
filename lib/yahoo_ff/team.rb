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
    
    def actual_points(slots = %w[QB WR RB TE WRRB K DEF])
      return self.points(->(p){slots.include? p.slot})
    end
    
    def best_points(positions = %w[QB WR RB TE WRRB K DEF])
      return self.best_roster(positions).actual_points(positions)
    end

    def points(filter = ->(x){true})
      @players.inject(0) {|sum, p| filter.call(p) ? sum + p.points : sum}
    end

    def best_roster(positions = %w[QB WR RB TE WRRB K DEF])
      possible = []
      @players.sort{|a,b| b.points <=> a.points}.each do |p|
        dup = p.dup
        dup.slot = 'BN'
        possible << dup
      end
    
        
      best_roster = []
      positions.each do |pos|
        possible.each do |p|
          if p.slot_to? pos and p.slot == 'BN'
            # puts "Slot #{p.name} (#{p.pos}) to #{pos} (#{p.points})"
            p.slot = pos
            best_roster << p
            break
          end
        end
      end
      best_roster += possible.find_all{|p| p.slot == 'BN'}
      return self.class.new(@team_id, @week, best_roster)
    end
    

  end
end
      
