require 'nokogiri'
require 'yahoo_ff/player'
require 'yahoo_ff/team'

module YahooFF
  module Parser
    class TeamWeek
      
      attr_accessor :teamweek_dir
      
      def initialize(teamweek_dir)
        @teamweek_dir = teamweek_dir
      end
      
      # Parse out a teamweek file and return
      # an array of players
      # @return YahooFF::Team A Team object
      
      def get_team_for_week(team, week)
        file = "#{@teamweek_dir}/#{team}_#{week}.html"
        n = Nokogiri.HTML(File.open(file))
        players = []
        
        [0,1,2].each do |i|
          t0 = n.css("#statTable#{i}")
          t0.css('tr').each do |tr|
            opts = {}
            next unless tr.css('td.pos').text =~ /\S/
            opts[:name] = tr.css('td.player a.name').text

            (pteam, ppos) = tr.css('li.ysf-player-team-pos span').text.gsub(/[() ]/, '').split('-')
            
            ppos ||= ''
            ppos.gsub! /,.*/, ''
            ppos.gsub! /(IR|NA)/, ''
            opts[:pos] = ppos
            

            opts[:points] = tr.css('td.pts').text.to_i

            slot = tr.css('td.pos').text
            slot = 'WRRB' if slot == 'W/R'
            opts[:slot] = slot
            
            players.push(YahooFF::Player.new(opts))
          end
        end
        return YahooFF::Team.new(team, week, players)
      end

    end
  end
end
