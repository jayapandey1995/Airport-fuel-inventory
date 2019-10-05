require 'rubygems'
require 'bundler/setup'
require "table_print"


class Airport

	class << self
		#Set global variables with airport details
		Data = [
			  ['1', 'Indira Gandhi International Airport,Delhi', '500000', '25066'],
			  ['2', 'Rajiv Gandhi International Airport,Hyderabad', '500000', '350732'],
			  ['3', 'Chhatrapati Shivaji InternationalAirport, Mumbai', '500000', '288467'],
			  ['4', 'Chennai International Airport, Chennai', '500000', '497460'],
			  ['5', 'Kempegowda International Airport,Bangalore', '500000', '123456']
			]
		Transactions = [
			  [Time.now, 'In','25066', '' , '1'],
			  [Time.now, 'In','350732', '', '2'],
			  [Time.now, 'In','288467', '', '3'],
			  [Time.now, 'In','497460', '', '4'],
			  [Time.now, 'In','123456', '', '5']
			]

		# Create table with all details of airport
		def airport_fuel_data
			hash_of_table = Data.map { |values| %w(Airport_ID Airport_Name FuelCapacity(ltrs) Fuel_Available(ltrs)).zip(values).to_h }
			tp hash_of_table #tp => for printing data in table format
			Airport.take_user_input
		end

		# Fetch details for available fuel in respective airports
		def airport_with_available_fuel
			availability = []
			Data.each do |airport|
				availability.push([airport[1], airport[3]])
			end
			availability_fuel_data = availability.map { |values| %w(Airport Fuel_Available).zip(values).to_h }
			tp availability_fuel_data #tp => for printing data in table format
			Airport.take_user_input
		end

		# Set check code on deduction of fuel
		def aircraft_code
			puts "Enter Aircraft Code:"
			aircraft_code = gets.chomp
			if aircraft_code != "6E-102"
				puts "Not a valid Code, Please Enter a valid aircraft code"
				Airport.aircraft_code
			else
				aircraft_code
			end
		end

		#Add or Deduct the amount of fuel in specific airport 
		def check_fuel_avalability(option)
			puts "Enter Airport ID:"
			airport_id = gets.chomp
			if ["1", "2", "3", "4", "5"].include?(airport_id)
				if option == "3" # For deduction
					aircraft_code = Airport.aircraft_code
				end
				puts "Enter Fuel (ltrs):"
				fuel = gets.chomp
				Data.each_with_index do |airport_data, index|
					check_airport_id = airport_data.include?(airport_id)
					if check_airport_id == true
						if option == "3"
							remaining_fuel = airport_data[3].to_i - fuel.to_i
							if remaining_fuel < 0 # If Fuel is not available
								message = "Failure: Request for the fuel is beyond availability at airport"
							else
								type = "out"
								Airport.create_transactions(airport_id, fuel, type, aircraft_code)#Create Transaction
								airport_data[3] = remaining_fuel
								message = "Success: Request for fuel the has been fulfilled"
							end
						else #Adding Fuel
							adding_fuel = airport_data[3].to_i + fuel.to_i
							if  adding_fuel <= airport_data[2].to_i # Aircraft Capacity
								type = "In"
								airport_data[3] = adding_fuel
								Airport.create_transactions(airport_id, fuel, type, aircraft_code)
								message =  "Success: Fuel inventory updated"				
							else
								message = "Error: Request Goes beyond fuel capacity of the airport"
							end
						end
						puts message
					end
				end
			else
				puts "Please enter valid Airport ID"
			end
			Airport.take_user_input
		end
		#Create Transactions
		def create_transactions(airport_id, remaining_fuel, type, code="")
			time_of_transaction = Time.now
			Transactions.push([time_of_transaction, type, remaining_fuel, code, airport_id])
		end

	# Fetch transaction respective all aircrafts
		def all_transactions
			Data.each do |airport|
				puts "Airport:  #{airport[1]}" #Airport name
				all_transactions = []
				Transactions.each do |transaction|
					if transaction[4] == airport[0] #Airport id
						all_transactions << transaction
					end
				end
				transactions_of_airport = all_transactions.map { |values| %w(Date/time Type Fuel Aircraft).zip(values).to_h}
				tp transactions_of_airport
				puts "Fuel Available:  #{airport[3]}"
				puts "-------"
			end
			Airport.take_user_input
		end

		#Take input from User
		def take_user_input
			puts "Choose Your Option:"
			user_input = gets.chomp
			Airport.getting_user_input(user_input)
		end


	# Check all inputs and call respective methods
		def getting_user_input(check_user_input)
			case check_user_input
			when "0"
				Airport.airport_fuel_data
			when "1"
				Airport.airport_with_available_fuel
			when "2","3"
				Airport.check_fuel_avalability(check_user_input)
			when "4"
				Airport.all_transactions
			when "9"
				puts "exiting.... ok"
			else
				puts "Please enter valid input"
				Airport.take_user_input
			end
		end

		Airport.take_user_input #Initialize the code
		
	end
end
