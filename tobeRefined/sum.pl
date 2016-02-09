#!/usr/bin/perl
use 5.017; use strict; use warnings;
use Scalar::Util qw/looks_like_number/;
use Getopt::Std; getopts "=", \my%o;
#use Data::Dump qw/dump/;
my $llnfunc= sub{ looks_like_number shift @_ }  ;
binmode STDIN, 'utf8';

my ($sum, $lln, $nlln) = (0)x3;
my $header; ($header=<>)=~s/\n$// if ( $o{q/=/} );
while( <> ) {
    chomp ;
    #print dump( $llnfunc->($_) ); next;
    if ( $llnfunc->( $_ ) ) {
	$sum+= $_ ;
	$lln++;
    } else {
	$nlln ++;
    }
}

print qq{header="$header"\t} if( $o{q/=/} );
print sprintf qq{sum=%d\tcounted=%d\tave=%f\tnot counted:%d\n}, $sum,$lln, $sum/$lln, $nlln;

=encoding utf8
=head1

sum.pl


    入力の値を行ごとに単純に足し合わせる。補助情報として、何行が数として扱われたか、平均値など出力する。
    数かどうかの判定は Scalar::Util の looks_like_number 関数を使っている。値は単純に足している。atof など使っていない。
=cut
