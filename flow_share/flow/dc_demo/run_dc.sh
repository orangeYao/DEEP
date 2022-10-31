#!/bin/bash


####ROOT_DIR=`cd ../; pwd`
####DC_DIR="."
#RTL_DIR="/home/eezhiyao/Designs/rtl"

RTL_DIR="/home/eezhiyao/Benchmarks/SmallDesigns/rtl/"
DC_DIR=`pwd`
TECH_DIR="../../tech" ### in ./b14

LIST_DESIGN=`cat list_design`

FLAG=0
RUNTIME=0

for DESIGN in $LIST_DESIGN
do
	if [ $FLAG -eq 0 ]; then
		if [ "$DESIGN" == '__START__' ]; then 
			FLAG=1 
			continue
		else continue;
		fi
	fi

	if [ "$DESIGN" == '__END__' ]; then break; fi

	DIR=${DC_DIR}/${DESIGN}
	mkdir $DIR; cd $DIR
	echo "Starting"
	stamp_begin=`date +%s`;
	dc_shell -x "
		echo [date]; 
		set bench_root $RTL_DIR;
		set design     $DESIGN;
        	source ../set_rtl_path.tcl;
		source $TECH_DIR/tech_syn.tcl
		echo [date]; 
		source -e -v ../dc.tcl;
		" 
		#source $TECH_DIR/tech.tcl
	stamp_end=`date +%s`;
	((RUNTIME += stamp_end - stamp_begin));
done

echo ""
echo "Runtime: ${RUNTIME} seconds"
echo ""
