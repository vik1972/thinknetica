# encoding: utf-8

arr = [1, 1]
f1 = f2 = 1
f = f1 + f2
while f <= 100
	arr.push(f)
	f2 = f1
	f1 = f
	f = f1 + f2
end

puts arr.to_s
