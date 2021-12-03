# encoding: utf-8

months = {
	1 => 31,
	2 => 28,
	3 => 31,
	4 => 30,
	5 => 31,
	6 => 30,
	7 => 31,
	8 => 31,
	9 => 30,
	10 => 31,
	11 => 30,
	12 => 31
}
puts "Input the date in the format 'number.month.year"
s = gets.chomp
n, m, y = s.split('.')
answer = 0
months.each do |num, days|
	number = num.to_i
	if number < m.to_i
		if number == 2
			year = y.to_i
			if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0)
				answer += 1
				puts "sss"
			end
		end
		answer += days
	end
end
answer += n.to_i
puts "Date sequence number: #{answer} "
