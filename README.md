Feature : 
  - A bunch of hacking toolset to handle/analysis/manipulate tabular data files from 
    the viewpoint of data analysers, complementing the deficiencies of existing softwares
    such as Excel, R, SQL, python pandas and so on.
  - Your data analysis project may speed up as fast as 20 times! 
  - Command Line Usage is necessary. No need to know Perl, though almost all the program is written in Perl. (If something happens, Perl knowledge is helpful.)

Deeper concept explanations (still partly) : 

1. The presentation at IEEE BigData 2016, Washington DC, 2016-12-05 : 
  http://www.slideshare.net/shimonotoshiyuki/a-hacking-toolset-for-big-tabular-files-3
  
2. The presentation at CIGS, Tokyo, 2016-08-19 (in Japanese) :  
  http://www.slideshare.net/shimonotoshiyuki/ss-65145461

<img src="http://image.slidesharecdn.com/washingtondcb20161214-161118124629/95/a-hacking-toolset-for-big-tabular-files-3-9-638.jpg?cb=1481318116" width=250> 
<img src="http://image.slidesharecdn.com/washingtondcb20161214-161118124629/95/a-hacking-toolset-for-big-tabular-files-3-12-638.jpg?cb=1481318116" width=250> 
<img src="http://image.slidesharecdn.com/washingtondcb20161214-161118124629/95/a-hacking-toolset-for-big-tabular-files-3-20-638.jpg?cb=1481318116" width=250> 

Sofware name : 
  - "bin4tsv" ; my original internal code name, considering the rule of CPAN library naming rule. 
  - "Kabutomushi"  ; my colleagues call so. 
  - Still not fixed, though. 



Installation : 
  1. Requires Perl 5 installation beforehand. 5.1 is minimum, 5.14 or more is desirable. 
  2. The simplest way to use my software is just copy and paste each of the programs of my software. 
  3. Full installation is downloding the whole and adding the PATH of each of directory where the 
       program files of my software exists. But this may require faliarity of basic command line using knowledge.
  4. Some of the programs I created requires additional installation of necessary libraries from CPAN. 
       (The error message would show that the additional installation is necessary when you use the program.)

Bugs : 
  * Please report to me if you find some essential bugs. 
  * At this moment, multiple checking is recommendable. 
  * Not-hiding potential-bug policy is employed for my software at this moment. 
  
 
Developing memorandum : 
 - You can easily invoke help manual easily by 'command --help' or 'commad --help opt', but everything is yet in Japanese.
    (I am thinking to implement the function of invoking English manual by reading the environment variable or "command --help EN') 
 - Common options switches desining though the whole program is important. Refining more is neccessary. Recently I have added -@ option to show the ongoing status in the interval of 1e5 or 1e6 lines. 
 - As many many of my friends say "complete publishing is important to improve your software", but I like to claim that I need to sophistication of my policy of building my software is still necessary beforehand.  Please be patient. It may take more a few months. 
 
  - If you can help develop my software, I welcome. If you have business idea, I like to listen your idea. Essentaial advice is always welcome.
  
- All is written in Perl. It is fast enough for the purpose of analysis on the big table data files on your HDD/SSD because the reading time is the bottleneck. And Perl is fast enough among other programming languages. Transporting to other language such as C, C++, Go, Python would occur after many steps later.
