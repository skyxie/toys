bin_dir :
	mkdir -p bin

dec_bin : bin_dir
	cc dec_bin.c -o bin/dec_bin -lm
	chmod 755 bin/dec_bin

float_comparison : bin_dir
	cc float_comparison.c -o bin/float_comparison -lm
	chmod 755 bin/float_comparison

all : dec_bin float_comparison

clean :
	rm bin/dec_bin
	rm bin/float_comparison
