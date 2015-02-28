all:
	ruby main.rb
lint:
	rubocop -l
cop:
	rubocop
bundle:
	bundle install
sure:
	echo "You've made it! "
check:
	bundle check
todo:
	grep "TODO\|FIXME\|XXX" . -rn | grep -v "\.git"
