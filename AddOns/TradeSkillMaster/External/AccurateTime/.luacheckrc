-- load globals
globals = {
	"AccurateTime",
	"CreateFrame",
	"debugprofilestart",
	"debugprofilestop",
	"GetTime",
}

-- no max line length
max_line_length = false
-- show warning codes in output
codes = true
-- ignore warnings
ignore = {
	"311", -- pre-setting locals to nil
	"212/self", -- unused self
}
-- only output files with warnings / errors
quiet = 1
exclude_files = { ".luacheckrc" }
