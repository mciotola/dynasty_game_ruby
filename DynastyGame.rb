
# DYNASTY GAME.
# Written in ruby 1.9.2p290
# v08
# No warrantees or guarantees are made. All standard disclosures apply.


# INTRODUCTORY INFORMATION FOR USER

puts "\n"
puts "+-----------------------------------------------------------------------+"
puts "| DYNASTY GAME v 0.08                                                   |"
puts "+-----------------------------------------------------------------------+"
puts "|                                                                       |"
puts "| Copyright 2013 by Mark Ciotola; available for use under GNU license   |"
puts "|                                                                       |"
puts "+-----------------------------------------------------------------------+"
puts "\n\n"
puts "INTRODUCTION AND INSTRUCTIONS \n"
puts "\n"
puts " The Kingdom of Centralia was once great and renowned, but had drifted \n"
puts " into desolation under its prior rulers who had grown decadent and \n"
puts " lathargic.  You overthrew those rulers to restore the kingdom to its \n"
puts " former glory.  As ruler, you can develop your dynasty and invest in \n"
puts " economic production, build up its military, or engage in conquest.\n"
puts " \n"
puts " Economic investment increases productivity by improving infrastructure,\n"
puts " such as roads, bridges and canals. Building up the military allows for \n"
puts " conquest or greater defense. Successful conquest can increase production\n"
puts " by acquiring foreign resources. The amount available for development in \n"
puts " each period is 25% of production.\n"
puts " \n"
puts " During conquest, development resources automatically go towards military\n"
puts " build-up. Unsuccessful conquest will first decrease the military, and \n"
puts " then reserves and production.  Conquest at higher levels of production \n"
puts " involves larger wars. Military capacity and production must be kept at \n"
puts " least at 1, or the dynasty will end due to being conquered or starvation. \n"
puts "\n"
puts " You can set the initial conquest risk level, and later readjust it \n"
puts " in Administrative Mode. Enter indicated letter to make desired selections. \n"
puts "\n"

# THERMODYNAMICS PROXIES

  # Production is a proxy for entropy production or acheivement.
  # Efficiency is a proxy for Carnot efficiency.


# INITIALIZE PARAMETERS

  action = "a"
  actiondisplay = "NONE"
  gamespeed = 1  # Time multiplier to possibly be used later

  production = 1.0
  investment = 0.0
  military = 1.0
  reserves = 1.0
  conquest = 0.0
  dynastyage = 0
  efficiency = 0.25 # 0.1 might be more realistic, but makes for a slow game.
  saving = 0.0
  overhead = 0.0 # for later
  conquestrisk = 1.0
  taxrate = 0.25


# CONQUEST RISK SELECTION

conqriskchoice = 'l'

print "Do you wish conquest to be low (l), medium (m) or high (h) risk? [m]> "
conqriskchoice = gets.chomp
puts "\n"

if conqriskchoice == 'l'
  conquestrisk = 0.5
elsif conqriskchoice == 'm'
  conquestrisk = 1.0
elsif conqriskchoice == 'h'
  conquestrisk = 2.0
else
  puts " !!! Invalid choice. Conquest risk set to medium !!!"
  conquestrisk = 1.0
end
puts "\n\n"


# INITIAL DISPLAY

puts "=========================================================================\n\n"
puts "BEGINNING POSITION \n\n"
puts " +---------------------------------+\n"
puts " | Production: " + production.to_s + "                 | \n"
puts " |   Reserves: " + reserves.to_s + "                 | \n"
puts " |   Military: " + military.to_s + "                 | \n" 
puts " | Efficiency: " + efficiency.to_s + "                | \n"
puts " +---------------------------------+\n"
puts "\n"
puts "Key: Production unit = [*]  Reserve unit = (+)  Military unit = <#>"
puts "\n\n"


# GAME LOOP

while (action != "x") and (production >= 1.0) and (military >= 1.0) do

  dynastyage = dynastyage + 1
  efficiency = efficiency * (1 - efficiency/300)

  puts "=========================================================================\n\n"
  puts "YEAR " + dynastyage.to_s + " ACTION SELECTION: \n\n"
  print "Invest in economy (i), build military (m), engage in conquest (c) \n"
  print "save in reserves (r), enter administrative mode (a) or end game (x)> "
  action = gets.chomp
  puts "\n\n"

  if action == "a"
    actiondisplay = "ADMINISTER        "
  elsif action == "r"
    actiondisplay = "INCREASE RESERVES "
  elsif action == "i"
    actiondisplay = "INVEST IN ECONOMY "
  elsif action == "m"
    actiondisplay = "BUILD UP MILITARY "
  elsif action == "c"
    actiondisplay = "CONQUEST          "
  elsif action == "x"
    actiondisplay = "TERMINATE DYNASTY "
    production = 0.0
  end


  if action == "a"

    puts "ADMINISTRATIVE MODE."
    dynastyage = dynastyage - 1
    efficiency = efficiency * (1 + efficiency/300)
    puts "\n"
  
    # Adjust conquest risk setting.
    print "Do you wish change the conquest risk to be low, medium or high>"
    conqriskchoice = gets.chomp
    puts "\n"

    if conqriskchoice == 'l'
      conquestrisk = 0.5
    elsif conqriskchoice == 'm'
      conquestrisk = 1.0
    elsif conqriskchoice == 'h'
      conquestrisk = 2.0
    else
      conquestrisk = 1.0
    end

  
  elsif action == "r"
    saving = production * efficiency
    reserves = reserves + saving
  
  
  elsif action == "i"
    # Investment has the possibility to increase production.
    inv = 0.0 + ( Random.new.rand(1.00) * production * efficiency)
    production = production + inv


  elsif action == "m"
    # Building up the military has the possibility to increase military capability.
    mil = 0.0 + (Random.new.rand(1.00) * production * efficiency)
	military = military + mil
  
  
  elsif action == "c"
    # Conquest can increase production or decrease military capability.
    # If military capability goes below 1, reserves get used to restore military.
    # If reserves go below zero, production decreases.
    # If military fall below 1, society gets conquered.
    # If production falls below zero, there is a revolt and your dynastry ends.
  
    # Automatic military build-up
    mil = 0.0 + (Random.new.rand(1.00) * production * efficiency)
    military = military + mil

    # Conquest result
    c = ( -1.0 + Random.new.rand(2.00) ) * production * conquestrisk
    if c >= 0.0
      production = production + c
    else
      military = military + c
	  if military < 1.0
	    while military < 1.0 and production > 1.0
		  if reserves >= 1.0
		    military = military + 1
		    reserves = reserves - 1.0
		  elsif production >= 1.0
		    military = military + 1.0
		    #Converting production directly into lilitary capability results in an inefficiency penalty.
		    production = production - 2.0
		  else
		end		
	  end
	end
  end

  else
    dynastyage = dynastyage - 1
  end

  # Set up numerical display formats
  proddisplay = (" |        Production: %6.4f \t   | ")
  mlbddisplay = (" | Military Build-Up: %6.4f \t   | ")
  conqdisplay = (" |   Conquest Result: %6.4f \t   | ")
  invrdisplay = (" | Investment Result: %6.4f \t   | ")
  resvdisplay = (" |          Reserves: %6.4f \t   | ")
  miltdisplay = (" |          Military: %6.4f \t   | ")
  ecefdisplay = (" |        Efficiency: %6.4f \t   | ")

  # Display results table
  puts "RESULTS for Year: " + dynastyage.to_s + " \n"
  puts " +---------------------------------+ \n"
  puts " | Action Taken: " + actiondisplay + "|\n"
  if action == "m"
    puts sprintf mlbddisplay, mil.to_s
  elsif action == "c"
    puts sprintf mlbddisplay, mil.to_s
    puts sprintf conqdisplay, c.to_s
  elsif action == "i"
    puts sprintf invrdisplay, inv.to_s
  end

  puts sprintf proddisplay, production.to_s
  puts sprintf resvdisplay, reserves.to_s
  puts sprintf miltdisplay, military.to_s
  puts sprintf ecefdisplay, efficiency.to_s

  puts " +---------------------------------+\n"
  puts "\n"
  
  # Show graphical representation of results
  prodgraphiccount = 0
  print " PRODUCTION: "
  while prodgraphiccount < (production.to_i)
    print "*"
    prodgraphiccount = prodgraphiccount + 1
  end
  puts "\n"
  resvgraphiccount = 0
  print " RESERVES:   "
  while resvgraphiccount < (reserves.to_i)
    print "+"
    resvgraphiccount = resvgraphiccount + 1
  end
  puts "\n"
  miltgraphiccount = 0
  print " MILITARY:   "
  while miltgraphiccount < (military.to_i)
    print "#"
    miltgraphiccount = miltgraphiccount + 1
  end
  puts "\n"
  puts "\n\n"

# End of action loop
end

# End of game message.
puts "\n\n"
puts "YOUR DYNASTY HAS ENDED. It has lasted for: " + dynastyage.to_s + " Year(s).\n\n"


# GRAPHCS STORAGE 

#<*> <=> [$] [=] [+] (=) (-) {=} [*] -=- -=-  (!) -^-  ?|  \ /\ /\ /\ /\
##|# 
###>
#() () () @ @ @ @ @ @ @ @ 
#(@) (#) ($) (*) <=>  (+) {*} {#} <#>

# ⚔⚗✠☖

