#!/usr/bin/perl 
use 5.011 ; use strict ; use warnings ; use feature qw/say/ ; 
use List::Util qw/sum/ ; 
use Term::ANSIColor qw/:constants color/ ; $Term::ANSIColor::AUTORESET = 1 ; 
use Getopt::Std ; getopts "e:mz=" , \my %o ; 
use PerlIO::gzip ; 

my (@key,%value,$pole,$intflag) ; 
&procOptions ; # 最初の方のオプションを処理 
&ReadingFirstFile ; # キーのファイルを読む 
&ReadingNextFiles ; # 与えられたファイルリストの2番目以降を読む
&PrintingOutput ; # 最後に結果を出力する。
exit(0) ; 

sub procOptions { 
    $o{e} //= defined $o{v} ? "00" : "00"  ;
    $o{k} //= 1 ; $o{k} -- ; 
    $o{v} -- if defined $o{v} ; 
} 

# 主要パーツ
sub ReadingFirstFile { 
    <> if $o{'='} ; 
    while ( <> ) { 
        chomp ; 
        push @key , $_ ; 
        last if eof ; 
    }
}

sub ReadingNextFiles {
    $SIG{INT} = sub { $intflag = 1 } ;
    $pole = 0 ;
    for ( @ARGV ) {
        next if &ProcDesignations($_) ;  
        &ReadEachFile ;
        $pole ++ ; 
        last if $intflag ;
    }
    print STDERR "\n" ;
}

sub PrintingOutput { 
    for ( @key ) {
        my @values =  @{$value{$_}} [0 .. $pole-1] ; 
        print join "\t" , $_ , map { $_ // $o{e}  } @values ; 
        print "\t" , (sum grep{s/,(\d)/$1/g;1} grep{$_} @values ) // 0 if $o{m} ; 
        print "\n" ; 
     }
     if ( $o{m} ) { 
        my @sums ; 
        for my $i ( 0 .. $pole -1 ) {
            push @sums , sum grep{s/,(\d)/$1/g;1} grep{$_}   map { $value{$_}[$i] } @key ; 
        }
        push @sums, ( sum @sums ) // 0 ; # 全体合計も付加。
        print join "\t" , '' , map { $_ // 0 } @sums ; 
        print "\n" ;
     }
}

# 主要パーツ内から呼び出される処理 
sub ProcDesignations ($) { 
   # 引数中に -k か -v が出現した場合、及びその直後の処理
    state $dChar ;  
    if ( $dChar ) { $o{ $dChar } = $_[0] -1 ; $dChar = "" ; return 1 } 
    if ( $_[0] eq "-k" || $_[0] eq "-v" ) { $dChar = substr($_[0],1,1) ; return 1 } 
    if ( $_[0] =~ /^\-([kv])/ ) { $o{ $1 } = $' -1 ; return 1 } ;  
    if ( $_[0] eq "-z" ) { $o{z}=1 ; return 1 } 
    if ( $_[0] eq "-Z" ) { $o{z}='' ; return 1 } 
    0 ; 
}

sub ReadEachFile { 
   #ファイルオープンの処理
    my $fh ; 
    open $fh , $o{z} ? "<:gzip" : "<" , $_  or die "File Open Error: $_ " if $_ ne "-" ;
    print STDERR CYAN  $_ // '--'  ,  "\t" ; 
    print STDERR MAGENTA "Warning: -z seems neccessary because file name ends with .gz!\n" if /.gz$/ && ! $o{z} ;
    <$fh> if $o{'='} ; 
    while ( <$fh> ) { 
        chomp ; 
        my @F = split /\t/ , $_ , -1 ; 
        no warnings ; 
        if ( defined $o{v}  ) { 
            $value { $F[ $o{k} ] } [$pole] = $F[ $o{v} ] ;  
        } else { 
            $value { $F[ $o{k} ] } [$pole] += 1 ;  
        }
        last if $intflag ;
    }
    close $fh; 
}

__END__ 

=encoding utf8 

=head1 xxxx.pl File1 File2 File3 ... 

=head2 File1 の中はキーの集合と仮定する

=head2 そして、File2以降の各ファイルについて、そのキーを含むかどうかチェックする。

=head3 その結果をクロス表で示す。

=head2 [オプション]

=head3 -= 全てのファイルについて、1行目はヘッダと見なして、読み飛ばす。

=head3 -k どの列をキーとして参照するか指示する(1始まり) 

=head3 -v どの列を値として参照するかを指示する(1始まり)。もしなければ、キーが各ファイルに存在したかどうかのみ表す。

=head3 -m 周辺和を列と行について付加する。

=head3 -z ファイルは gz圧縮されていると見なす。ただし1番目のファイルにはこのオプションは適用しない。

=head3 -Z ファイル指定の途中で -Z が現れたら それ以降のファイルは gz圧縮と見なさなくなる。

=head3 -e 文字列 ; 該当するものが無いときに、代わりにどういう文字列で表示するかを指示する。

=head2 ※6 オプションについての注意点

=head3 -k と -v については、2番目以降のファイル名の途中に混ざって書いた場合は、その途中で指定列が変わることを意味する。



=cut 

