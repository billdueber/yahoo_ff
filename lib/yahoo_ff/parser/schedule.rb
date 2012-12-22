module YahooFF
  module Parser
    class Schedule
      
      attr_accessor :schedule_dir
      def initialize(schedule_dir)
        @schedule_dir = schedule_dir
        @id_name_map = nil
        @opponents = {}
      end
      
      def id_name_map
        return @id_name_map if @id_name_map
        @id_name_map = {}
        filename = "#{@schedule_dir}/1.html"
        n = Nokogiri.HTML(File.open(filename))
        n.css('#scheduletable td.team a').each do |t|
          name = t.text
          num = t.attr('href').split('/')[-1]
          @id_name_map[num] = name
        end
        return @id_name_map
      end
      
      # Figure out which teams played each other for the
      # given week
      #
      # @return Array of the form [[team_id1, team_id2], ...]
      def opponents(week)
        return @opponents[week] if @opponents[week]
        
        filename = "#{@schedule_dir}/#{week}.html"
        n = Nokogiri.HTML(File.open(filename))

        @opponents[week] = []

        t = n.css('#scheduletable')
        games = t.css('table table tr').each_slice(2)
        games.each do |g|
          first, second = *g
          t1 = first.css('td.team a')[0]
          t1num = t1.attr('href').split('/')[-1]
          t1name = t1.text

          t2 = second.css('td.team a')[0]
          t2num = t2.attr('href').split('/')[-1]
          t2name = t2.text
          
          @opponents[week] << [t1num, t2num]
        end
        
        return @opponents[week]
      end
      
      def schedule(weeks) 
        weeks.each do |w|
          self.opponents(w)
        end
        return @opponents
      end
      
    end
  end
end
        
