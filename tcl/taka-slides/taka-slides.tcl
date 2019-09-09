#!/usr/bin/tclsh

proc getWithoutFirstCh {string} {
	return [string trim [string range $string 1 [string length $string]]]
}

lassign $argv sourceFile

set inp [open $sourceFile]
set source [read $inp]
close $inp

set data {}
set prevBlank false

# Text normalization
foreach line [split $source \n] {
	set line [string trim $line]

	if {[string length $line] == 0} {
		if {[llength $data] == 0 || $prevBlank} {
			continue
		} else {
			lappend data $line
			set prevBlank true
		}
	} else {
		if {[string first \# $line] != 0} {
			lappend data $line
		}
		set prevBlank false
	}
}

# Text processing
set slides {}
set slide {}
set prevList false
foreach line $data {
	if {[string first \- $line] == 0} {
		if {!$prevList} {
			set prevList true
			lappend slide <ul>
		}

		set item [getWithoutFirstCh $line]
		lappend slide "<li>$item</li/>"
		continue
	}

	if {$prevList} {
		set prevList false
		lappend slide </ul>
	}

	if {[string length $line] == 0} {
		lappend slides [join $slide \n]
		set slide {}
	}

	if {[string first \@ $line] == 0} {
		set url [getWithoutFirstCh $line]
		lappend slide "<img src=\"$url\" />"
		continue
	}

	if {[string first \\ $line] == 0} {
		set rest [getWithoutFirstCh $line]
		lappend slide $rest
		continue
	}

	lappend slide $line
}
lappend slides [join $slide \n]


puts [append html <p>\n [join $slides \n</p>\n<p>] \n</p>]