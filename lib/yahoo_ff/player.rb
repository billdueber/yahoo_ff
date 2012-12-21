module YahooFF
  class Player
    
    attr_accessor :name, :pos, :slot, :points
    
    def initialize(opts)
      @name   = opts[:name]
      @pos    = opts[:pos]
      @slot   = opts[:slot]
      @points = opts[:points]
    end
    
    def played?
      @slot != 'BN'
    end
    
    def slot_to?(slot)
      return true if slot == @slot
      return true if (slot == 'WRRB') and (%w[RB WR].include?(@pos))
      return false;
    end
  end
end