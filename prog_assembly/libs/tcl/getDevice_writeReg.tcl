#global omsp_conf
global omsp_info

#############################################
global CpuNr
# Initialize to default values
set CpuNr                 0
#############################################


###############################################################################
#                            SOURCE LIBRARIES                                 #
###############################################################################

# Get library path
set current_file [info script]
if {[file type $current_file]=="link"} {
    set current_file [file readlink $current_file]
}
#set lib_path [file dirname $current_file]/lib/tcl-lib
set lib_path [file dirname $current_file]/

# Source library
source $lib_path/dbg_functions.tcl
source $lib_path/dbg_utils.tcl

puts "\nlib_path : $lib_path\n"

###############################################################################
#                            PARAMETER CHECK                                  #
###############################################################################
#proc GetAllowedSpeeds

proc help {} {
    puts "Reads memory locations from openMSP430"
}

# Default values
set omsp_conf(interface)  uart_generic
set omsp_conf(device)     /dev/ttyUSB1 ;#smk /dev/ttyUSB0
set omsp_conf(baudrate)   115200 ;#smk [lindex [GetAllowedSpeeds] 1]
#set omsp_conf(0,cpuaddr)  0
set StartAddr 0x5000
set datalength 4
#set filename "Memory_data.txt"; #saved in the current directory


# Parse arguments
for {set i 0} {$i < $argc} {incr i} {
    switch -exact -- [lindex $argv $i] {
        -device   {set omsp_conf(device)    [lindex $argv [expr $i+1]]; incr i}
        -adaptor  {set omsp_conf(interface) [lindex $argv [expr $i+1]]; incr i}
        -speed    {set omsp_conf(baudrate)  [lindex $argv [expr $i+1]]; incr i}
        -start_address {set StartAddr       [lindex $argv [expr $i+1]]; incr i}
        -input_file_name {set filename     [lindex $argv [expr $i+1]]; incr i}
        -reg_num {set reg_num [lindex $argv [expr $i+1]]; incr i}
        -reg_val {set reg_val [lindex $argv [expr $i+1]]; incr i}
    }
}


# Make sure the selected adptor is valid
if {![string eq $omsp_conf(interface) "uart_generic"] &
    ![string eq $omsp_conf(interface) "i2c_usb-iss"]} {
    puts "\nERROR: Specified adaptor is not valid (should be \"uart_generic\" or \"i2c_usb-iss\")"
    help
    exit 1   
}


# If the selected interface is a UART, make sure the selected speed is an integer
if {[string eq $omsp_conf(interface) "uart_generic"]} {
    if {![string is integer $omsp_conf(baudrate)]} {
        puts "\nERROR: Specified UART communication speed is not an integer"
        help
        exit 1   
    }
} elseif {[string eq $omsp_conf(interface) "i2c_usb-iss"]} {
    if {[lsearch [lindex [GetAllowedSpeeds] 2] $omsp_conf(baudrate)]==-1} {
        puts "\nERROR: Specified I2C communication speed is not valid."
        puts "         Allowed values are:"
        foreach allowedVal [lindex [GetAllowedSpeeds] 2] {
            puts "                              - $allowedVal"
        }
        puts ""
        exit 1   
    }
}


###############################################################################
# Connect to target and stop CPU
###############################################################################
puts            ""
puts -nonewline "Connecting with the openMSP430 ($omsp_conf(device), $omsp_conf(baudrate)\ bps)... "
flush stdout
if {![GetDevice 0]} {
    puts "failed"
    puts "Could not open $omsp_conf(device)"
    puts "Available serial ports are:"
    foreach port [utils::uart_port_list] {
    puts "                             -  $port"
    }
    if {[string eq $omsp_conf(interface) "i2c_usb-iss"]} {
        puts "\nMake sure the specified I2C device address is correct: $omsp_conf(0,cpuaddr)\n"
    }
    exit 1
}
#ExecutePOR_Halt 0
HaltCPU 0
puts "done"
set sizes [GetCPU_ID_SIZE 0]

if {$omsp_info(0,alias)!=""} {
    puts "Connected: target device identified as $omsp_info(0,alias)."
}
puts "Connected: target device has [lindex $sizes 0]B Program Memory and [lindex $sizes 1]B Data Memory"
puts ""



###############################################################################
# Check Register's value and ReleaseDevice 
###############################################################################
set Reg_value [WriteReg 0 $reg_num $reg_val ]
#puts "Register [lindex $reg_num 0]'s vlaue is [lindex $Reg_value 0] "

#ReleaseDevice 0 0xfffe
