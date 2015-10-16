bin_dir :
	mkdir -p bin

string_tail : bin_dir
	cc string_tail.c -o bin/string_tail
	chmod 755 bin/string_tail

all : string_tail

clean :
	rm bin/string_tail
