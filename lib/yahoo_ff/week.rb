# A week has:
#   - a number (for sorting)
#   - a schedule (who played whom)
#   - a set of teamweeks
#   - a set of games (basically, the teamweeks mapped onto the schedule)

module YahooFF
  class Week
    
    attr_accessor :week, :games, :teamweeks
    
    def initialize(week)
      @week = week
      @games = []
      @teamweeks = []
    end
  end
end
