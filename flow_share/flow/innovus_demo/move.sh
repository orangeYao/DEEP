
echo "Move to $1"
rmdir $1
mkdir $1
mv sasc/ simple_spi/ spi/ systemcdes/ $1
cp pnr.tcl $1


