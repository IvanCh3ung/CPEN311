
proc puts_and_post_message { x } {
  puts $x
  post_message $x
}

proc timid_ignore { clock_name { max_delay  30.0 } { min_delay  -10 } } {
	 set clock_count_debug_var 0;

	 foreach_in_collection clockB  [remove_from_collection [get_clocks {*}] $clock_name] {
			   set clock_count_debug_var [expr {$clock_count_debug_var + 1}]
			   set_max_delay -from  $clock_name -to $clockB $max_delay
			   set_max_delay -from $clockB -to  $clock_name $max_delay
			   set_min_delay -from  $clock_name -to $clockB $min_delay
			   set_min_delay -from $clockB -to  $clock_name $min_delay
			  }
		      puts_and_post_message "=========================================================================="		
			  puts_and_post_message "timid_ignore of $clock_name  max_delay = $max_delay min_delay = $min_delay : Arranged $clock_count_debug_var clocks"
			  puts_and_post_message "=========================================================================="
		      puts_and_post_message "=========================================================================="		
			  puts_and_post_message "timid_ignore of $clock_name  max_delay = $max_delay min_delay = $min_delay : Arranged $clock_count_debug_var clocks"
			  puts_and_post_message "=========================================================================="
		
}

proc print_collection { col } {
if {[catch { 
   foreach_in_collection c $col  {
     puts_and_post_message "   [get_clock_info -name $c]";   
   }
   } ] } {
	   if {[catch {
	   puts_and_post_message "[query_collection $col -all -report_format]"
	   } ] } {
		  puts_and_post_message "   $col"
	   }
   }
}

proc timid_asynchronous { clock_name clockB { max_delay  30.0 } { min_delay  -10 } } {
	 	  set_max_delay -from  $clock_name -to $clockB $max_delay
		  set_max_delay -from $clockB -to  $clock_name $max_delay
		  set_min_delay -from  $clock_name -to $clockB $min_delay
		  set_min_delay -from $clockB -to  $clock_name $min_delay
		  puts_and_post_message "=========================================================================="
			puts_and_post_message "timid_asynchronous $clock_name from/to $clockB, max_delay = $max_delay min_delay = $min_delay which means:"
			print_collection $clock_name
			puts_and_post_message "from/to: "			
			print_collection $clockB
			puts_and_post_message "=========================================================================="			
}

proc timid_asynchronous_group { clock_list { max_delay  30.0 } { min_delay  -10 } } {
         for {set i 0 } { $i < [llength $clock_list] } { incr i } {		 
		  for {set j [expr $i + 1] } { $j < [llength $clock_list] } { incr j }  {
		      timid_asynchronous [lindex $clock_list $i] [lindex $clock_list $j] $max_delay $min_delay;
		 }
   }
}

proc timid_false_path { from_grp to_grp { max_delay  40.0 }} {
    set_max_delay -from  $from_grp -to $to_grp $max_delay
	 
    puts_and_post_message "=========================================================================="
    puts_and_post_message "timid_false_path from $from_grp to $to_grp, max_delay = $max_delay"
    puts_and_post_message "=========================================================================="			
}

proc timid_minmax_false_path { from_grp to_grp { max_delay  40.0 }  { min_delay  -15 } } {
    set_max_delay -from  $from_grp -to $to_grp $max_delay
    set_min_delay -from  $from_grp -to $to_grp $min_delay
	 
    puts_and_post_message "=================================================================================================="
    puts_and_post_message "timid_minmax_false_path from $from_grp to $to_grp, max_delay = $max_delay  min_delay = $min_delay"
    puts_and_post_message "=================================================================================================="			
}

proc timid_tofrom_false_path { grp_a grp_b { max_delay  40.0 }} {
    set_max_delay -from  $grp_a -to $grp_b $max_delay
	 set_max_delay -from  $grp_b -to $grp_a $max_delay

    puts_and_post_message "=========================================================================="
    puts_and_post_message "timid_tofrom_false_path $grp_a from/to $grp_b, max_delay = $max_delay"
    puts_and_post_message "=========================================================================="			
}
proc timid_minmax_tofrom_false_path { grp_a grp_b { max_delay  40.0 }  { min_delay  -15 }} {
     set_max_delay -from  $grp_a -to $grp_b $max_delay
	 set_max_delay -from  $grp_b -to $grp_a $max_delay
     set_min_delay -from  $grp_a -to $grp_b $min_delay
	 set_min_delay -from  $grp_b -to $grp_a $min_delay

    puts_and_post_message "======================================================================================================"
    puts_and_post_message "timid_minmax_tofrom_false_path $grp_a from/to $grp_b, max_delay = $max_delay  min_delay = $min_delay"
    puts_and_post_message "========================================================================================================"			
}



proc timid_minmax_to_false_path { grp_a grp_b { max_delay  40.0 }  { min_delay  -15 }} {
     set_max_delay -from  $grp_a -to $grp_b $max_delay
	 set_min_delay -from  $grp_a -to $grp_b $min_delay
	 
    puts_and_post_message "======================================================================================================"
    puts_and_post_message "timid_minmax_to_false_path from $grp_a to $grp_b, max_delay = $max_delay  min_delay = $min_delay"
    puts_and_post_message "========================================================================================================"			
}




proc set_minmax_io_delay { pin_name { max_delay  40.0 }  { min_delay  -15 }} {
     set_max_delay -to    [get_ports $pin_name] $max_delay
     set_max_delay -from  [get_ports $pin_name] $max_delay
     set_min_delay -to    [get_ports $pin_name] $min_delay
     set_min_delay -from  [get_ports $pin_name] $min_delay

    puts_and_post_message "set_minmax_io_delay pin $pin_name max_delay = $max_delay  min_delay = $min_delay"
}
