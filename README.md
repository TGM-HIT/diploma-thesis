## A Latex Thesis Template

### Commands

Option | Result
------ | ------
`\selectlanguage{english}` | Set language to english
`\selectlanguage{ngerman}` | Set language to german

### Options

Options are added to the `\documentclass` command usually found in `main.tex`.
```latex
\documentclass[<option1>,<option2>,...]{thesis}
```

Option | Result
------ | ------
`en` | Set main document langauge to english
`minted` | Add and configure minted package
`natbib` | Change bibtex backend to natbib
`nocolor` | Do not color hyperlinks
`nofonts` | Change font to default
`nologos` | Disable logos on titlepage
`oneside` | Do not use multiple pages for chapters
`parskip` | Skip a line instead of indenting the next one after blank line
`sans` | Use sans-serif font
`nocitesort` | Don't sort citations alphabetically

### Variables

Variables are set as commands with their parameter being the variable value.
```tex
\myvariable{value}
```

Command | Content
------- | -------
`myschool` | Name of school or institution
`mydepartment` | Name of department
`mydivision` | Name of division
`myteacher` | Teacher responsible for the thesis
`myyear` | Year of graduation in format yyyy/yy
