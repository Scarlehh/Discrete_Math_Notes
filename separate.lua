#!/usr/bin/lua

if (arg[1] == nil) then
	print("No file specified")
end

local lines = {}
for line in io.lines(arg[1]) do
	table.insert(lines, line)
end

local sectionRegex = "\\section{.+}"
local endOfFile = "\\end{document}"

local currSection = {
	id = 0;
	name = "";
	tex = "";
}

local sections = {}

function makeSubfile(section)
	local filename = string.format("%02d", section.id) .. "-" .. string.gsub(currSection.name, " ", "_")
	table.insert(sections, filename)
	local sectionFile = io.open("sections/"..filename..".tex", "w")
	sectionFile:write(currSection.tex)
	sectionFile:close()
end

for i, line in next, lines do
	if (line:match(sectionRegex)) then
		if (currSection.id > 0) then
			currSection.tex = currSection.tex .. "\n\\end{document}"
			makeSubfile(currSection)
		end
		currSection.id = currSection.id + 1
		currSection.name = line:match("{.+}"):gsub("{", ""):gsub("}", "")
		currSection.tex = [[\documentclass[../main.tex]
		
		\begin{document}
		]]
	elseif (line:match(endOfFile)) then
		currSection.tex = currSection.tex .. "\n\\end{document}"
		makeSubfile(currSection)
	else
		currSection.tex = currSection.tex .. line .. "\n"
	end
end

-- Creating the main file.
local mainTex = [[
\documentclass[10pt]{article}
\usepackage{caption}
\usepackage{multirow}
\usepackage{amsfonts}
\usepackage{amsmath}
\usepackage{amssymb}

\usepackage{tikz}
\usepackage{tkz-euclide}
\usetikzlibrary{shapes, backgrounds, calc}
\usetkzobj{all}

\usepackage{subfiles}

\usepackage{hyperref}
\hypersetup{
	colorlinks = true
}

\begin{document}
	\tableofcontents
	\pagebreak

]]

for _, section in next, sections do
	mainTex = mainTex .. "\\subfile{sections/" .. section .. "}\n"
end
mainTex = mainTex .. "\\end{document"

local filename = "main.tex"
local mainFile = io.open(filename, "w+")
mainFile:write(mainTex)
mainFile:close()
