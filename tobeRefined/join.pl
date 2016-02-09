#!/usr/bin/perl
use 5.010; use strict; use warnings; 
use Getopt::Std; getopts "ajf:y=",\my%o;
#
# 0-1. オプションの処理
#
$o{f}=1 if ! defined $o{f} ;  # 左から1番目の列をキーとすることをデフォルトとする。
$o{f} -- ; 

my $pflag = defined $o{y} ? 2 :defined $o{j} ? 1 : 0 ; # 処理内容を指定するフラグ変数。

#
# 0-2.  処理方法の選択
#
my %Q ; 

# 基本的な処理
my $proc_basic = sub { 
  if( exists $Q{ $_[0] } ) { 
    print $Q{$_[0]} , "\n"   # キーが被参照に存在するときは必ず出力
  } 
  elsif ( $o{a} ) {
    print "\n"  # キーが被参照に存在しない場合、-a 指定の時に限り空行を出力
  }
} ;

# -j が指定された時の処理
my $proc_join = sub { 
  if( exists $Q{ $_[0] } ) { 
    print $_[1] ,"\t" , $Q{$_[0]} , "\n" ; 
    # 各行は、最右列以外のキーファイルの内容と、キーに対応する被参照の行の内容が並ぶ。
  } 
  elsif ( $o{a} ) {
    print "\n"  # キーが被参照に存在しない場合、-a 指定の時に限り空行を出力
  }
} ; 

# -y が指定された時の処理
my $proc_exists = sub { 
  print exists( $Q{ $_[0] } ) ? 1:0 , "\t" , $_[0] ,"\n" ; # 単に1または0をキーと共に出力する。
} ;  


# 上記のうち、どれを出力するかを、$pflag により決定する。
my $proc = ( $proc_basic, $proc_join, $proc_exists )[ $pflag ] ; # ここで処理方法が決まる。

#
# 1. 被参照ファイルの読取り
#

open my $RFH, '<' , shift @ARGV or die $!; 

# 1.1 被参照キー,被参照値のファイルにヘッダ行の処理をする場合の処理
my $header ; 
if( $o{'='} ){  
  $header = <$RFH> ;
  chomp $header ; 
}

# 1.2 メインの処理
while( <$RFH> ){ 
  chomp; 
  $Q { (split/\t/,$_,-1)[ $o{f} ] } = $_ ; # キーごとに被参照値を保管
}  
close $RFH ; 
undef $RFH ;  

#
# 2. 入力キーを一行ずつ読取って、逐次出力する。
#

# 2.1 オプションで-= が指定された時の、最初に出力する行についての処理

if( $o{'='} ){ 
  if ($o{y}) { 
    $_ = <> ; 
    chomp ; 
    #print "0/1\t" . $header . "\n" ; 
    print "0/1\t" . $_ . "\n" ; 
  }
  elsif ( $o{j} ) {
    $_ = <>  ; 
    my @F = split /\t/,$_,-1;
    pop @F ; 
    @F = ('') if scalar @F == 0 ; 
    print join ("\t", @F, $header ) , "\n" ; 
  }
  else { 
    print $header, "\n" ;
  }
}

# 2.2 でメインの処理
my %K ; 
while( <> ) { 
    chomp ;
    my @F =split /\t/,$_,-1;
    my $key = pop @F ;      # 入力キーは各行の最後(最右)の列である。あえてそう定義する。
    $proc -> ( $key, join "\t",@F ) ;  ## !! ここで @Fが空であった時の振る舞いをよく考えよう。
}

=pod

=encoding utf8

=head1 [コマンド]

(1) join.pl  refFile keyFile

(2) join.pl  refFile  <  keyFile

(3) cat keyFile | join.pl refFile 

     keyFile : 各行が入力キー
     refFile : 各行が被参照キーと被参照値
    上記の(1)(2)(3)でどれも動作は同じである。

=head1 

=head1 [概要]

keyFileの各行をキーと見なして順に読取り、キーに対応する行をrefFileの行を参照して、出力。

=head1 [オプション]

-=        
  refFile の1行目をヘッダとみなす。出力のヘッダに入力のヘッダが出現する効果がある。
  (keyFile の1行目がヘッダとした時の動作は考慮していない。sed 2d などで対応せよ。)

-f num 
  ; numで指定されたrefFileの列がキーと見なされる。デフォルトは 1 (最左列)。

-a 
  入力キーと同じ被参照キーが無いときは空文字列の行を出力する。

-y 
  入力キーがrefFileのキー列に含まれていた/いないを、0/1で表す。0/1 と キー名 のみ出力。

-j 
  各行にキー列がKeyFile最右列にあると見なす。
  出力の各行は、KeyFileの順に、左側がKeyListの最右以外の列、そして、右側が refFileの該当行となる。
  (uniq -c などによる、左列が度数で右側がキーの、KeyList を想定している。) 

=head1

=head1

=head1 [解説]


cat keyFile | join.pl refFile のコマンドにより、
各キーに対応してその順に参照された被参照ファイルの
行の内容が表示される。

-a の指定により、対応するものが見つからない場合は
空行が出力される。

-j の指定により、キーファイルはキー以外にも結合したい内容が
あると見なし、キーファイルの最右列だけをキーと見なす。
通常は、下記のように並ぶ。

  "キーファイルの非キー列 キー列 被参照ファイルのキー列以外"


=head1 [開発情報]
 -= と -j を同時に指定された時にヘッダ行が適切に表示されるように
 プログラムはまだ十分なテストをしていないので、十分な検証が必要。





=cut

# . 2015.09.30


