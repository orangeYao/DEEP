#!/bin/bash

INN_DIR=`pwd`
ROOT_DIR=`cd ../; pwd`

#export RTL_DIR="$ROOT_DIR/../rtl"

export DC_DIR="$ROOT_DIR/dc_demo"
export TECH_DIR="$ROOT_DIR/tech"

LIST_DESIGN=`cat list_design`

export RTL_PATH="$DC_DIR/set_rtl_path.tcl"

FLAG=0
for DESIGN in $LIST_DESIGN
do
    if [ $FLAG -eq 0 ]; then
        if [ $DESIGN == '__START__' ]; then
            FLAG=1
            continue
        else continue;
        fi
    fi

    if [ $DESIGN == '__END__' ]; then break; fi
    RUN_DIR=${INN_DIR}/${DESIGN}
    export DESIGN_DIR="${INN_DIR}/${DESIGN}"

    # Create the working directory
    if [ -d "$RUN_DIR" ]; then
        rm -rf $RUN_DIR
    fi
    mkdir -p $RUN_DIR
    echo "Working dir: $RUN_DIR"

    export MY_DESIGN=$DESIGN
    echo "Working dir: $MY_DESIGN"
    #cd $RUN_DIR && innovus -no_gui -files ../pnr.tcl 
    cd $RUN_DIR && innovus -files ../pnr.tcl 
done

