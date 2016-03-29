use strict;
my %idfdat;
$|=1;
my @domainList;
my %idf;
sub tf{
	my $domain = $_[0];
	my @backdl=@domainList;
	my $cou;
	my %word;
	open IN,"< text/$domain.txt";
	while(<IN>){
		$_=lc $_;
		while(/(\S{2,})/g){
			$word{$1}++;
			$cou++;
		}
	}
	close IN;
	open OUT,"> tmp/$domain.tf.tmp";
	for(keys %word){
		$word{$_}/=$cou;
		$idfdat{$_}++;
		print OUT "$word{$_} $_\n";
	}
	close OUT;
	`sort -n -r tmp/$domain.tf.tmp > text/$domain.tf`;
	@domainList=@backdl;
}

sub tfidf{
	my $domain = $_[0];
	my %tfidf;
	open IN,"< text/$domain.tf"
		or die "cannot open tf data [text/$domain.tf]";
	while(<IN>){
		chomp;
		if(/([.\d]+) (\w+)/){
			my $tf=$1;
			my $word=$2;
			if($word=~/^\d*(\D+)\d*$/){
				$word=$1;
			}
			$tfidf{$word}+=$tf*$idf{$word};
		}else{
			print "error:$_\n";
		}
	}
	close IN;
	open OUT,"> tmp/$domain.tfidf.tmp";
	for(keys %tfidf){
		print OUT "$tfidf{$_} $_\n";
	}
	close OUT;
	`sort -r -n tmp/$domain.tfidf.tmp > text/$domain.tfidf`;
}
while(<STDIN>){
	chomp;
	push @domainList,$_;
}
for(@domainList){
	&tf($_);
}

open OUT,"> tmp/idf.txt.tmp";
for(keys %idfdat){
	$idf{$_}=log($#domainList/$idfdat{$_});
	print OUT "$idf{$_} $_\n";
}
close OUT;

`sort -n -r tmp/idf.txt.tmp > text/idf.txt`;

for(@domainList){
	&tfidf($_);
}
`perl makehtml.pl <list >/var/www/html/tor/tfidfs.html`;
