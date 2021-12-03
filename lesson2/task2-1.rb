# encoding: utf-8

arr = []
(10..100).each { |elem| arr<<elem if elem % 5 == 0 }

puts arr.to_s
