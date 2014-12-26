all:
	ruby main.rb
lint:
	rubocop -l
cop:
	rubocop
