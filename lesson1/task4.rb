#encoding: utf-8

print 'Введите коэффициент а: '
a = gets.chomp.to_i
print 'Введите коэффициент b: '
b = gets.chomp.to_i
print 'Введите коэффициент c: '
c = gets.chomp.to_i

D = b*b - 4 * a * c
if D < 0
	puts "Дискриминант #{D}. Корней нет"
elsif D == 0
	x = -b / (2 * a)
	puts "Дискриминант #{D}. Корень уравнения: #{x}"
else
	x1 = (-b - Math.sqrt(D)) / (2 * a)
	x2 = (-b + Math.sqrt(D)) / (2 * a)
	puts "Дискриминант #{D}. Первый корень: #{x1}, второй корень: #{x2}"
end