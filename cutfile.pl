#!/usr/bin/perl -w
#usage: ./cutfile.pl dir(origin)
$dirname = $ARGV[0];

`mkdir -p data`;
opendir ( DIR, $dirname ) || die "Error in opening dir $dirname\n";
while( ($filename = readdir(DIR))){
	if($filename=~/.*.vcf/){ $outfile = substr($filename, 0, -4); }
	else{ $outfile = $filename; }
	$command ="cut -f 1-5 $ARGV[0]$filename | sed '/^#/d' | sed 's/REF/".$outfile."_REF/g' | sed 's/ALT/".$outfile."_ALT/g' > data/$outfile";
  if($filename !~ /^\.+/) { `$command`; }
}
closedir(DIR);
