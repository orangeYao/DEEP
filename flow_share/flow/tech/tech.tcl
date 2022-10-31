
set LIBRARY_DIR /home/eezhiyao/Libs/NanGate/Nan45Flow/NangateOpenCellLibrary_PDKv1_3_v2010_12

set DB_DIR $LIBRARY_DIR/db
set LIB_DIR $LIBRARY_DIR/Front_End/Liberty/CCS
set LEF_DIR $LIBRARY_DIR/Back_End/lef
set CAP_DIR $LIBRARY_DIR

set all_dbs [list $DB_DIR/fast.db \
                  $DB_DIR/slow.db \
                  $DB_DIR/typical.db]

set all_libs [list $LIB_DIR/NangateOpenCellLibrary_typical_ccs.lib ]

set lef_files [list $LEF_DIR/NangateOpenCellLibrary.lef \
                    $LEF_DIR/NangateOpenCellLibrary.tech.lef ]

#set qx_tech_file "$QRC_DIR/qrcTechFile_typ03_scaled4xV06"
set cap_tbl_file "$CAP_DIR/NCSU_FreePDK_45nm.capTbl"

