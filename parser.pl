while(<STDIN>){
	chomp;
	/"([0-9a-zA-Z]{16}\.onion)"/ and print "$1\n";
}
