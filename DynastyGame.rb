# DYNASTY GAME
# Written in ruby 1.9.2p290--2.2.4p230

# No warrantees or guarantees are made. All standard disclosures apply.


# INTRODUCTORY INFORMATION FOR USER

puts "\n"
puts "+-----------------------------------------------------------------------+"
puts "| DYNASTY GAME v 0.10                                                   |"
puts "+-----------------------------------------------------------------------+"
puts "|                                                                       |"
puts "| Copyright 2013-2019 by Mark Ciotola. Last updated 4 November 2019     |"
puts "| Available for use under GNU license.                                  |"
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


# INITIALIZE PARAMETERS

  action = "a"
  actionDisplay = "NONE"
  gamespeed = 1  # Time multiplier to possibly be used later

  production = 1.0
  investment = 0.0
  military = 1.0
  reserves = 1.0
  conquest = 0.0
  dynastyage = 0
  efficiency = 0.25 # 0.1 might be more realistic, but makes for a slow game.
  conquestrisk = 1.0


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
puts " +---------------------------------+\n"
puts "\n"
puts "Key: Production unit = [*]  Reserve unit = (+)  Military unit = <#>"
puts "\n\n"


# GAME LOOP

while (action != "x") and (production >= 1.0) and (military >= 1.0) do

  dynastyage = dynastyage + 1

  puts "=========================================================================\n\n"
  puts "YEAR " + dynastyage.to_s + " ACTION SELECTION: \n\n"
  print "Invest in economy (i), build military (m), engage in conquest (c) \n"
  print "save in reserves (r), enter administrative mode (a) or end game (x)> "
  action = gets.chomp
  puts "\n\n"

  if action == "a"
    actionDisplay = "ADMINISTER        "
  elsif action == "r"
    actionDisplay = "INCREASE RESERVES "
  elsif action == "i"
    actionDisplay = "INVEST IN ECONOMY "
  elsif action == "m"
    actionDisplay = "BUILD UP MILITARY "
  elsif action == "c"
    actionDisplay = "CONQUEST          "
  elsif action == "x"
    actionDisplay = "TERMINATE DYNASTY "
    production = 0.0
  end


  if action == "a"

    puts "ADMINISTRATIVE MODE."
    dynastyage = dynastyage - 1  # Add back a year since not a real action.
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
    # Reserves can be used for furture consumption.
    # They can be grain, or gold that can be used to buy grain, etc.
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
    # If production falls below zero, there is a revolt and your dynasty ends.
  
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
		    #Converting production directly into military capability results in an inefficiency penalty.
		    production = production - 2.0
		  else
		end		
	  end
	end
  end

  else
    dynastyage = dynastyage - 1  # Add back a year since not a real action.
  end

  # Set up numerical display formats
  prodDisplay = (" |        Production: %6.4f \t   | ")
  mlbdDisplay = (" | Military Build-Up: %6.4f \t   | ")
  conqDisplay = (" |   Conquest Result: %6.4f \t   | ")
  invrDisplay = (" | Investment Result: %6.4f \t   | ")
  resvDisplay = (" |          Reserves: %6.4f \t   | ")
  milDisplay =  (" |          Military: %6.4f \t   | ")

  # Display results table
  puts "RESULTS for Year: " + dynastyage.to_s + " \n"
  puts " +---------------------------------+ \n"
  puts " | Action Taken: " + actionDisplay + "|\n"
  if action == "m"
      puts sprintf mlbdDisplay, mil.to_s
      elsif action == "c"
      puts sprintf mlbdDisplay, mil.to_s
      puts sprintf conqDisplay, c.to_s
      elsif action == "i"
      puts sprintf invrDisplay, inv.to_s
  end
  puts sprintf prodDisplay, production.to_s
  puts sprintf resvDisplay, reserves.to_s
  puts sprintf milDisplay, military.to_s
  puts " +---------------------------------+\n"
  puts "\n"
  
  # Show graphical representation of results
  prodGraphicCount = 0
  print " PRODUCTION: "
  counter = 1
  while prodGraphicCount < (production.to_i)
      print "+"
      if counter == 65 and prodGraphicCount < 65
          print "\n "
          counter = 0
          elsif   counter == 77
          print "\n "
          counter = 0
      end
      counter = counter + 1
      prodGraphicCount = prodGraphicCount + 1
  end
  puts "\n"
  
  resvGraphicCount = 0
  print " RESERVES:   "
  counter = 1
  while resvGraphicCount < (reserves.to_i)
      print "*"
      if counter == 65 and resvGraphicCount < 65
          print "\n "
          counter = 0
          elsif   counter == 77
          print "\n "
          counter = 0
      end
      counter = counter + 1
      resvGraphicCount = resvGraphicCount + 1
  end
  puts "\n"
  
  milGraphicCount = 0
  print " MILITARY:   "
  counter = 1
  while milGraphicCount < (military.to_i)
      print "#"
      if counter == 65 and milGraphicCount < 65
          print "\n "
          counter = 0
          elsif   counter == 77
          print "\n "
          counter = 0
      end
      counter = counter + 1
      milGraphicCount = milGraphicCount + 1
  end
  puts "\n"
  puts "\n\n"

  
# End of action loop
end

# End of game message.
puts "\n\n"
puts "YOUR DYNASTY HAS ENDED. It has lasted for: " + dynastyage.to_s + " Year(s).\n\n"

