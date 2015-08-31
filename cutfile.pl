#!/usr/bin/perl -w
#usage: ./cutfile.pl dir(origin)
$dirname = $ARGV[0];

`mkdir -p data`;
opendir ( DIR, $dirname ) || die "Error in opening dir $dirname\n";
while( ($filename = readdir(DIR))){
	$command ="cut -f 1-5 $ARGV[0]$filename | sed '/^#/d' | sed 's/REF/".$filename."_REF/g' | sed 's/ALT/".$filename."_ALT/g' > data/$filename";
  if($filename !~ /^\.+/) { `$command`; }
}
closedir(DIR);
