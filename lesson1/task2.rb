#encoding: utf-8

print 'Введите длину основания треугольника: '
a = gets.chomp.to_i
print 'Введите высоту треугольника: '
h = gets.chomp.to_i

s = (h * a) / 2.0
puts "Площадь треугольника равна #{s}"

