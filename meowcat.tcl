#!/usr/bin/env tclsh
# meowcat.tcl
# Copyright (C) 2019 Tim K/RoverAMD <timprogrammer@rambler.ru>
#
# Permission to use, copy, modify, and/or distribute this softwa-
# re for any purpose with or without fee is hereby granted.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUEN-
# TIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
# DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE
# USE OR PERFORMANCE OF THIS SOFTWARE.

proc quickread {fn} {
    if {$fn == {-}} {
        return [read stdin]
    } else {
        set desc [open $fn r]
        set ctnt [read $desc]
        close $desc
        return $ctnt
    }
}

proc offsetputs {offset what} {
    for {set index 0} {$index < $offset} {incr index} {
        puts -nonewline { }
    }
    puts "$what"
}

proc drawCatHead {offset uwu} {
    offsetputs $offset "|\\        /|"
    offsetputs $offset "| \\      / |"
    offsetputs $offset "|  \\    /  |"
    offsetputs $offset "|   \\  /   |"
    offsetputs $offset "|    \\/    |"
    offsetputs $offset "|  __  __  |"
    offsetputs $offset "| |  ||  | |"
    if {! $uwu} {
        offsetputs $offset "| | .||. | |"
    } else {
        offsetputs $offset "| |/\\||/\\| |"
    }
    offsetputs $offset "| |__||__| |"
    offsetputs $offset "|    _     |"
    offsetputs $offset "|          |"
    offsetputs $offset "|   \\/\\/   |"
    offsetputs $offset "|__________|"
    offsetputs $offset "___|   |____"
    #offsetputs [expr {$offset - 1}] "_|__________|_"
}

proc drawCatBody {offset height} {
    #offsetputs $offset " |        | "
    set minus [expr {$offset -1}]
    offsetputs $minus "| | _____ |\\ \\"
    set spaces [list { }]
    for {set index 0} {$index < $height} {incr index} {
        offsetputs $minus "| | |   | |[join $spaces {}]\\ \\"
        lappend spaces { }
    }
    offsetputs $minus "|_| |___| |[join $spaces {}]\\_\\"
    offsetputs $offset " |       |"
    offsetputs $offset " |  / |  |"
    for {set index 0} {$index < $height} {incr index} {
        offsetputs $offset " |  | |  |"
    }
    offsetputs $offset "_|  | |  |_"
    #offsetputs $minus "|    | |   |"
    offsetputs $minus "|____| |___|"
    
}

proc repeat {iterator count} {
    set result {}
    for {set index 0} {$index < $count} {incr index} {
        lappend result $iterator
    }
    return [join $result {}]
}

proc drawSpeechBubble {offset textcontents} {
    offsetputs $offset "   ______________________"
    offsetputs $offset "  |                      |"
    for {set index 0} {$index < [string length $textcontents]} {incr index 19} {
        set str [string trim [string range $textcontents $index [expr {$index + 19}]]]
        offsetputs $offset "  | $str[repeat { } [expr {21 - [string length $str]}]]|"
    }
    offsetputs $offset "  |_   __________________|"
    offsetputs $offset "    | /"
    offsetputs $offset "    |_|"
}

if {$::argc < 1 || [lsearch -exact $::argv "-help"] >= 0} {
    puts stderr "Usage: [info script] \[-u|-h<rows>|-f<chars>\] FILENAME"
    exit 1
}

set files {}
set uwu 0
set height 6
set offset 5
foreach itm $::argv {
    if {[string length $itm] >= 2 && [string index $itm 0] == {-}} {
        set arg [string index $itm 1]
        if {$arg == {u}} {
            set uwu 1
        } elseif {$arg == {h}} {
            set height [string range $itm 2 end]
        } elseif {$arg == {f}} {
            set offset [string range $itm 2 end]
        }
    } elseif {[file exists $itm]} {
        lappend files $itm
    } elseif {$itm == {-} && [lsearch -exact $files {-}] < 0} {
        lappend files "-"
    }
}

if {[llength $files] < 1} {
    lappend files "-"
}

if {! [string is integer $offset]} {
    set offset 5
}
if {! [string is integer $height]} {
    set height 6
}

set result {}
foreach fn $files {
    set ctnt [quickread $fn]
    lappend result $ctnt
}

drawSpeechBubble $offset [join $result {,}]
drawCatHead $offset $uwu
drawCatBody $offset $height
exit 0
