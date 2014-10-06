(* Idmapd module for Augeas
   Mainly copied from the puppet.aug file by Raphael Pinson <raphink@gmail.com>
 idmapd.conf is a standard INI File.
*)


module Idmapd =
  autoload xfm

(************************************************************************
 * INI File settings
 *
 * idmapd.conf only supports "# as commentary and "=" as separator
 *************************************************************************)
let comment    = IniFile.comment "#" "#"
let sep        = IniFile.sep "=" "="


(************************************************************************
 *                        ENTRY
 * idmapd.conf uses standard INI File entries
 *************************************************************************)
let entry   = IniFile.indented_entry IniFile.entry_re sep comment


(************************************************************************
 *                        RECORD
 * idmapd.conf uses standard INI File records
 *************************************************************************)
let title   = IniFile.indented_title IniFile.record_re
let record  = IniFile.record title entry


(************************************************************************
 *                        LENS & FILTER
 * idmapd.conf uses standard INI File records
 *************************************************************************)
let lns     = IniFile.lns record comment

let filter = (incl "/etc/idmapd.conf")

let xfm = transform lns filter
