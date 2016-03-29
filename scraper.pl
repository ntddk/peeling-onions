use strict;
`mkdir text`;
sub rawText{
	my $domain=$_[0];
	open HTML,"cat /var/www/html/tor/tor-scan/$domain.html |"
		or die "cannot open HTML file";
	my $text;
	while(<HTML>){
		chomp;
		$text.=" $_";
	}
	close HTML;
	$_=$text;
	/(^.{50})/;
	print "$1\n";
	s/\s+/ /ig;
	s/<script[^>]*>.*?<\/script>/ /ig;
	s/<style[^>]*>.*?<\/style>/ /ig;
	s/&nbsp;/ /ig;
	s/<head>.*?<\/head>/ /g;
	s/<[^>]+>//ig;
	s/[^\w\d]/ /ig;
	s/ . / /g;
	s/\s+/ /ig;
	print "$1\n\n";
	

	open OUT,"> ./text/$domain.txt"
		or die "cannot write TEXT";
	print OUT;
	close OUT;
}

while(<STDIN>){
	chomp;
	&rawText($_);
}
