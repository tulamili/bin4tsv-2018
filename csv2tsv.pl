#!/usr/bin/perl
# 2015-09-28 hand coded by TS.
use 5.010 ;
use strict ; use warnings ; 
use Getopt::Std ; getopts "wWq", \my %o ;
use Text::CSV_XS ; 
#use utf8 ;
binmode STDIN, ":encoding(utf8)" if ! $o{w} ; ##
binmode STDIN, ":encoding(cp932)" if $o{w} ;
binmode STDOUT,":encoding(utf8)";
warn "Only accepts from STDIN.. (To avoid this message use -q option.) \n" if ! $o{q} ;
          
$/ ="\r\n" if $o{W} ;
my $csv = Text::CSV_XS->new ( { binary => 1});

while ( my $x = $csv->getline( *STDIN ) ) { 
  print join "\t", @$x ;  
  print "\n" ;
}
$csv->eof; 

=pod

=encoding utf8


=head1 
  csv2tsv.pl 
   
=head1 

=head1 [概要]
  CSV 形式のファイルを TSV形式 に変換する。

=head1

=head1 [注意点]

  内部ではText::CSV_XS のライブラリに依存している。
  途中改行に対応していない可能性に注意。(要改良)
  "絵文字" に対応していないことに注意。(要改良)

=head1 [出力]

 UTF-8 形式となる。
 改行は \n である。


=head1 [オプション]

   -w 入力の文字コードを cp932  (シフトJIS) と見なす。
   -W 入力の改行コードを \r\n と見なす。

=cut
