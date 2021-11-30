#encoding: utf-8

print 'Введите Ваше имя: '
name = gets.chomp.capitalize!
print 'Введите Ваш рост: '
height = gets.chomp.to_i

weight = (height - 110) * 1.15
if weight < 0
	puts "#{name} Ваш вес #{weight}, уже оптимальный!"
else
	puts "#{name} Ваш вес #{weight}, пока не оптимальный)"
end
