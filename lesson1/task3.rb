#encoding: utf-8

print 'Введите длину первой стороны треугольника: '
a = gets.chomp.to_i
print 'Введите длину второй стороны треугольника: '
b = gets.chomp.to_i
print 'Введите длину терьей стороны треугольника: '
c = gets.chomp.to_i
max_l = [a,b,c].max
min_l = [a,b,c].min
mid_l = a + b + c - max_l - min_l

if max_l >= min_l + mid_l
	abort "Теугольника с такими сторонами не может быть!"
end

if max_l**2 == mid_l**2 + min_l**2
	puts "Это прямоугольный треугольник"
	if min_l == mid_l
		puts "Это равносторонний треугольник"
	end
elsif max_l == mid_l && max_l == min_l
	puts "Это равносторонний и равнобедренный треуsгольник"
elsif min_l == mid_l
	puts "Это равносторонний треугольник"
else
	puts "Это разносторонний треугольник"
end


