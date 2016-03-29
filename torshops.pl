use strict;
`mkdir shop`;
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
	print STDERR "$1\n";
	if(/input\.checkb/){
		print "$domain\n";
		open OUT,"> ./shop/$domain.html"
			or die "cannot write TEXT";
		print OUT;
		close OUT;
	}
}

while(<STDIN>){
	chomp;
	&rawText($_);
}
