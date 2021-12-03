# encoding: utf-8

basket = Hash.new
loop do
	print "Введите название товара или стоп (если хотите прекратить ввод): "
	user_input = gets.chomp

  break if user_input == 'стоп'

	product = user_input
	print "Введите цену товара: "
	cur_price = gets.chomp.to_f
	print "Введите количество товара: "
	cur_count = gets.chomp.to_f
	basket[product] = {price: cur_price, count: cur_count}
end

total = 0
basket.each do |product, val|
	price = val[:price]
	count = val[:count]
	total += price * count
	puts "#{product} " + "цена: #{price}" + " количество: #{count}" + " сумма: #{price*count}"
end
puts "Итого: #{total}"
