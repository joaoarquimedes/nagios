<?php
############################
#
# Log Report
#
############################
$ds_name[1] = "Log Report";
$opt[1] = "--alt-y-grid -l 0 --vertical-label \"Number\" --title \"Catalina Log Report\"";
$def[1]  = rrd::def("var1", $RRDFILE[1], $DS[1], "AVERAGE"); # Total Error
$def[1] .= rrd::def("var2", $RRDFILE[2], $DS[2], "AVERAGE"); # Total Warning
$def[1] .= rrd::def("var3", $RRDFILE[3], $DS[3], "AVERAGE"); # Total Info
$def[1] .= rrd::def("var4", $RRDFILE[4], $DS[4], "AVERAGE"); # Total Grave
# Error
$def[1] .= rrd::area("var1", "#e54830", "Error \\t") ;
$def[1] .= rrd::gprint("var1", "LAST", "%.0lf $UNIT[1] \\n");
# Warning
$def[1] .= rrd::area("var2", "#e8c16d", "Warnging \\t") ;
$def[1] .= rrd::gprint("var2", "LAST", "%.0lf $UNIT[2] \\n");
# Info
$def[1] .= rrd::area("var3", "#6dc9e8", "Info \\t\\t") ;
$def[1] .= rrd::gprint("var3", "LAST", "%.0lf $UNIT[3] \\n");
# Grave
$def[1] .= rrd::area("var4", "#e8e86d", "Grave \\t") ;
$def[1] .= rrd::gprint("var4", "LAST", "%.0lf $UNIT[4] \\n");


############################
#
# Log Deploying
#
############################
$ds_name[2] = "Log Deploying";
$opt[2] = "--alt-y-grid -l 0 --vertical-label \"Number\" --title \"Catalina Log Deploying Report\"";
$def[2]  = rrd::def("var1", $RRDFILE[5], $DS[5], "AVERAGE"); # Deploying
$def[2] .= rrd::def("var2", $RRDFILE[6], $DS[6], "AVERAGE"); # Deploying Error
$def[2] .= rrd::def("var3", $RRDFILE[7], $DS[7], "AVERAGE"); # Application Startup Failed
# Deploying
$def[2] .= rrd::area("var1", "#7cd66d", "Deploying \\t\\t\\t\\t") ;
$def[2] .= rrd::gprint("var1", "LAST", "%.0lf $UNIT[5] \\n");
# Deploying Error
$def[2] .= rrd::area("var2", "#ce482d", "Deploying Error \\t\\t\\t") ;
$def[2] .= rrd::gprint("var2", "LAST", "%.0lf $UNIT[6] \\n");
# Application Startup Failed
$def[2] .= rrd::area("var3", "#d8b85f", "Application Startup Failed \\t") ;
$def[2] .= rrd::gprint("var3", "LAST", "%.0lf $UNIT[7] \\n");


############################
#
# Server Startup
#
############################
$ds_name[3] = "Log Server Startup";
$opt[3] = "--alt-y-grid -l 0 --vertical-label \"Number\" --title \"Catalina Log Server Startup\"";
$def[3]  = rrd::def("var1", $RRDFILE[8], $DS[8], "AVERAGE"); # Server Startup
$def[3] .= rrd::def("var2", $RRDFILE[9], $DS[9], "AVERAGE"); # Server Stop
# Server Startup
$def[3] .= rrd::area("var1", "#7cd66d", "Server Startup \\t") ;
$def[3] .= rrd::gprint("var1", "LAST", "%.0lf $UNIT[8] \\n");
# Server Stop
$def[3] .= rrd::area("var2", "#ce482d", "Server Stop \\t") ;
$def[3] .= rrd::gprint("var2", "LAST", "%.0lf $UNIT[9] \\n");


############################
#
# Log Size
#
############################
$ds_name[4] = "Log Size";
$opt[4]  = "--alt-y-grid -l 0 --vertical-label \"Size\" --title \"Catalina Log Size\"";
$def[4]  = rrd::def("var1", $RRDFILE[10], $DS[10], "AVERAGE"); # Log Size
$def[4] .= rrd::area("var1", "#cfd0d1", "Log Size \\t") ;
$def[4] .= rrd::gprint("var1", "LAST", "%3.4lg %s$UNIT[10] \\n");
$def[4] .= rrd::line1( "var1", "#7e7e7f" );
?>
