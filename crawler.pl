#!/usr/bin/perl
use POSIX ":sys_wait_h";
my $cou=0;
while(<STDIN>){
	$cou++;
	chomp;
	my $f=fork;
	unless($f){
		my $domain=$_;
		`torsocks wget --connect-timeout=50 --tries=1  --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.5; rv:8.0.1) Gecko/20100101 Firefox/8.0.1" -O tmp/$domain.html $domain 2>>/dev/null`;
		if(-s "./tmp/$domain.html" == 0){
			`rm ./tmp/$domain.html`;
			`echo $domain >> nullList`;
		}else{
			`cp ./tmp/$domain.html /var/www/html/tor/tor-scan/`;
			`mv ./tmp/$domain.html ./dat/`;
			`echo $domain >> existList`;

		}
		exit;
	}
	if($f==-1){
		`echo "fork error" >> log`;
	}
	#`echo end$cou >> log`;
	if($cou%20 == 0){
		while(waitpid(-1,&WNOHANG)>0){}
		`echo sleep$cou >> log`;
		sleep 30;
	}
}
