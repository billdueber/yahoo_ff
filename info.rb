$:.unshift('lib')
require 'yahoo_ff'

league = YahooFF::League.new(:username=>'wdueber', :password=>'schlepp', :league_id=>168293, :teams=>14, :weeks=>13, :data_dir=>'./sample')
league.load!

puts "Actual vs Maximum possible points"
puts ["Team Name", "Actual", "Best Possible", "Pct"].join("\t")
league.teams.each_pair do |team_id, games|
  team_name = league.team_name(team_id)
  actual = games.reduce(0) {|sum, t| sum + t.actual_points}
  best   = games.reduce(0) {|sum, t| sum + t.best_points}
  puts [team_name, actual, best, (actual * 1.0) / best].join("\t")
end

puts ''

puts "Number of wins in regular season"
puts ["Team Name", "Actual", "Me best", "Both best"].join("\t")
league.team_games.each_pair do |team_id, games|
  team_name = league.team_name(team_id)
  actual, mebest, bothbest = 0,0,0
  games.each do |g|
    next if g.teams.map{|t| t.team_id}.include? 14 # league average
    actual += 1 if g.team(team_id).actual_points > g.opp(team_id).actual_points
    mebest += 1 if g.team(team_id).best_points > g.opp(team_id).actual_points
    bothbest += 1 if g.team(team_id).best_points > g.opp(team_id).best_points    
  end
  puts [team_name, actual, mebest, bothbest].join("\t")
end

puts "Wins if we eliminate some positions"
puts ["Actual", "No TE", "No K"].join("\t")
league.team_games.each_pair do |team_id, games|
  team_name = league.team_name(team_id)
  actual, note, nok = 0,0,0
  games.each do |g|
    next if g.teams.map{|t| t.team_id}.include? 14 # league average
    actual += 1 if g.team(team_id).actual_points > g.opp(team_id).actual_points
    note +=1 if g.team(team_id).actual_points(%w[QB WR RB WRRB K DEF]) > g.opp(team_id).actual_points(  %w[QB WR RB WRRB K DEF])
    nok +=1 if g.team(team_id).actual_points(%w[QB WR RB WRRB TE DEF]) > g.opp(team_id).actual_points(  %w[QB WR RB WRRB TE DEF])
  end
  puts [team_name, actual, note, nok].join("\t")
end
