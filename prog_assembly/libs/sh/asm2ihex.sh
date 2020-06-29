#!/bin/bash
#------------------------------------------------------------------------------
# Copyright (C) 2001 Authors
#
# This source file may be used and distributed without restriction provided
# that this copyright statement is not removed from the file and that any
# derivative work contains the original copyright notice and the associated
# disclaimer.
#
# This source file is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 2.1 of the License, or
# (at your option) any later version.1
#
# This source is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
# License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this source; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
#------------------------------------------------------------------------------
# 
# File Name: asm2ihex.sh
# 
# Author(s):
#             - Olivier Girard,    olgirard@gmail.com
#
#------------------------------------------------------------------------------
# $Rev: 141 $
# $LastChangedBy: olivier.girard $
# $LastChangedDate: 2012-05-05 23:22:06 +0200 (Sat, 05 May 2012) $
#------------------------------------------------------------------------------

asmfile=$1.s43;
verfile=$1.v;
incfile=~/rasp30/prog_assembly/libs/includes/openMSP430_defines.v;
linkfile=~/rasp30/prog_assembly/libs/includes/template.x;
headfile=~/rasp30/prog_assembly/libs/includes/template_defs.asm;
#submitfile=submit.f;

###############################################################################
#                            Parameter Check                                  #
###############################################################################
EXPECTED_ARGS=5
if [ $# -ne $EXPECTED_ARGS ]; then
  echo "ERROR    : wrong number of arguments"
  echo "USAGE    : asm2ihex.sh <test name> <test assembler file> <linker script> <assembler define>  <prog mem size> <data mem size> <peripheral addr space size>"
  echo "Example  : asm2ihex.sh c-jump_jge  ../src/c-jump_jge.s43 ../bin/template.x ../bin/pmem.h 2048            128             512"
  exit 1
fi


###############################################################################
#               Check if definition & assembler files exist                   #
###############################################################################

if [ ! -e $2 ]; then
    echo "Assembler file doesn't exist: $2"
    exit 1
fi



###############################################################################
#               Generate the linker definition file                           #
###############################################################################

PER_SIZE=$5
DMEM_SIZE=$4
PMEM_SIZE=$3
PMEM_BASE=$((0x10000-$PMEM_SIZE))
STACK_INIT=$((PER_SIZE+0x0080))

cp  $linkfile  ./pmem.x
cp  $headfile  ./pmem_defs.asm
sed -i "s/PMEM_BASE/$PMEM_BASE/g"    pmem.x
sed -i "s/PMEM_SIZE/$PMEM_SIZE/g"    pmem.x
sed -i "s/DMEM_SIZE/$DMEM_SIZE/g"    pmem.x
sed -i "s/PER_SIZE/$PER_SIZE/g"      pmem.x
sed -i "s/STACK_INIT/$STACK_INIT/g"  pmem.x

sed -i "s/PER_SIZE/$PER_SIZE/g"      pmem_defs.asm
sed -i "s/PMEM_SIZE/$PMEM_SIZE/g"    pmem_defs.asm


###############################################################################
#                  Compile, link & generate IHEX file                         #
###############################################################################
msp430-as      -alsm         $2     -o $1.o     > $1.l43
msp430-objdump -xdsStr       $1.o              >> $1.l43
msp430-ld      -T ./pmem.x   $1.o   -o $1.elf
#msp430-objcopy -O ihex       $1.elf    $1.ihex
