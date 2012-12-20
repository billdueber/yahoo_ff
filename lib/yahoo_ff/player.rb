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
  end
end