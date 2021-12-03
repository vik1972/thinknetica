# encoding: utf-8

vowel_letters = {
	а: 1,
	е: 6,
	ё: 7,
	и: 10,
	о: 16,
	у: 21,
	ы: 29,
	э: 31,
	ю: 32,
	я: 33
}

vowel_letters.each_key { |k| print k, ' '}
