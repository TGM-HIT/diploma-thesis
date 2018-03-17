% ====================
% :: Diploma Thesis ::
% ====================
%
% LaTeX class for diploma theses at the Information Technology department at TGM Vienna.
%
% @author   Markus Reichl <markus@re1.at> 
% @version  2018-03-15
% @url      https://github.com/tgm-hit/diploma-thesis
%
% TODO: Set authors using multiple author commands / command options
% TODO: Add some thesis related info to the page headings


\ProvidesClass{thesis}
% -------------
% :: Options ::
% -------------
\newif\ifen\enfalse             % English language
\DeclareOption{en}{\entrue}
\newif\iffonts\fontstrue        % Default latex fonts
\DeclareOption{nofonts}{\fontsfalse}
\newif\iflogos\logostrue        % Do not print logos on titlepage
\DeclareOption{nologos}{\logosfalse}
\newif\ifminted\mintedfalse     % Minted
\DeclareOption{minted}{\mintedtrue}
\newif\ifnatbib\natbibfalse     % NatBib
\DeclareOption{natbib}{\bibtrue\natbibtrue}
\newif\ifparskip\parskipfalse   % Lineskip instead of indent after blank line
\DeclareOption{parskip}{\parskiptrue}
\newif\ifcolor\colortrue        % Do not color links
\DeclareOption{nocolor}{\colorfalse}
% Pass options
\ProcessOptions \relax
% Load article class
\IfFileExists{crimson.sty}{
    \LoadClass[a4paper,11pt]{book}   % Crimson
}{  \LoadClass[a4paper,10pt]{book}}  % Default

% --------------
% :: Packages ::
% --------------
\iffonts\IfFileExists{crimson.sty}{\RequirePackage{crimson}}{}
        \IfFileExists{crimson.sty}{\RequirePackage{inconsolata}}{}\fi

\RequirePackage{a4wide}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{ccicons, csquotes, amssymb, mathtools}

\ifen\RequirePackage[ngerman, english]{babel}
\else\RequirePackage[english, ngerman]{babel}\fi

\RequirePackage{fancyhdr, float, multicol, multirow, titling}
\RequirePackage[marginal, norule, perpage]{footmisc}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{hyperref, url, pageslts, nameref}
\RequirePackage{outlines, enumitem}
\RequirePackage{booktabs, tabularx}
\RequirePackage{listings}   % Required by totalcount also without minted
\RequirePackage{graphicx, subcaption}
\RequirePackage[font=small]{caption}
\RequirePackage{accsupp}    % [1]
\RequirePackage[acronym, xindy, toc, nohypertypes={acronym,notation}]{glossaries}
\RequirePackage[figure,table,listing]{totalcount}

\ifnatbib\RequirePackage{natbib}    % Bibliography
\else\RequirePackage[backend=bibtex]{biblatex}\fi

\ifminted\RequirePackage[newfloat]{minted}  % Listings
\else\RequirePackage{listing}               % Already defined by minted itself
     \RequirePackage{listingsutf8}\fi       % UTF-8 Input support for listings

% ## Skip lines instead of indents after a blank line
\ifparskip\RequirePackage[parfill]{parskip}\fi

% ---------------
% :: Variables ::
% ---------------
\definecolor{MyLightGray}{RGB}{252,252,252}
\definecolor{MyBlue}{RGB}{5,102,141}
\definecolor{MyGreen}{RGB}{0,168,150}
\definecolor{MyBrown}{RGB}{143,89,3}
\definecolor{MyOrange}{RGB}{213,111,30}

\newcommand\@mysubtitle{}       % Subtitle
\newcommand\mysubtitle[1]{\renewcommand\@mysubtitle{#1}}
\newcommand\@myschool{Technologisches Gewerbemuseum}
\newcommand\myschool[1]{\renewcommand\@myschool{#1}}
\newcommand\@mydepartment{Höhere Technische Lehranstalt für Informationstechnologie}
\newcommand\mydepartment[1]{\renewcommand\@mydepartment{#1}}
\newcommand\@mydivision{}       % Systemtechnik / Medientechnik
\newcommand\mydivision[1]{\renewcommand\@mydivision{#1}}
\newcommand\@myteacher{}        % Betreuende Lehrkraft
\newcommand\myteacher[1]{\renewcommand\@myteacher{#1}}
\newcommand\@currentauthor{}    % Use \and for multiple authors
\newcommand\setauthor[1]{\renewcommand\@currentauthor{#1}}

% -------------------
% :: Configuration ::
% -------------------

% :: Listings ::
\ifminted
    \floatplacement{listing}{H} % Override default listing float
    \usemintedstyle{tango}      % autumn, rainbow_dash, tango, trac
    \setminted{ fontsize=\small,
                linenos=true,
                breakanywhere=true,
                breaklines=true,
                framesep=2mm,
                tabsize=4}

    % [1] Avoid copying line numbers on listings
    \renewcommand\theFancyVerbLine{
        \BeginAccSupp{method=escape,ActualText={}}
        {\rmfamily\tiny\arabic{FancyVerbLine}}
        \EndAccSupp{}
    }
    \SetupFloatingEnvironment{listing}{listname=Auflistungsverzeichnis,name=Auflistung}
\else   % Lstlistings
    \IfFileExists{.lst.tex}{\input{.lst}}{}   % Load config if exists
\fi

% :: Hyperlinks ::
\ifcolor\hypersetup{breaklinks=true, colorlinks=true,   % Color hyperlinks
                    linkcolor=MyBlue, urlcolor=MyBlue, citecolor=MyBlue}
\else\hypersetup{breaklinks=true, colorlinks=false,     % Do not color hyperlinks
                    linkcolor=Black, urlcolor=Black, citecolor=Black}\fi

% :: Headers ::
\pagestyle{fancy}\fancyhf{}

\makeatletter
\fancyhead[L]{\small \thetitle}
\fancyhead[R]{\small \nouppercase{\leftmark}}
\fancyfoot[L]{\small \if\relax\@currentauthor\relax\theauthor\else\@currentauthor\fi}
\fancyfoot[R]{\small \thepage~/~{\lastpageref*{VeryLastPage}}}
\makeatother

\renewcommand{\footrulewidth}{\headrulewidth}

% Add glossary / bibliography entries if they exist
\IfFileExists{glossaries.tex}{\input{glossaries}\makeglossaries}{}
\IfFileExists{bibliography.bib}{\addbibresource{bibliography}}{}

% :: Hacks ::
\raggedbottom               % Stop book documentclass from fucking with paragraph spacing..
\setcounter{secnumdepth}{3} % Make \subsubsections have numbers too
\def\arraystretch{1.5}      % Adjust table cell spacing
\floatplacement{table}{H}   % Adjust default table float
\floatplacement{figure}{H}  % Adjust default figure float

\renewcommand\thefootnote{\Roman{footnote}} % Roman footnotes
\newcolumntype{Y}{p{.5\textwidth}}  % cell with 50% of text width for TabularX

% ------------
% :: Makros ::
% ------------

% :: Title ::
\makeatletter
\renewcommand\maketitle{
    \iflogos~\\
        \IfFileExists{images/logo-left.png}{\includegraphics[height=2cm]{images/logo-left.png}}{}
        \hfill
        \IfFileExists{images/logo-right.png}{\includegraphics[height=2cm]{images/logo-right.png}}{}
    \fi
    
    \vskip 2.5cm    % Space between logos and school related information

    \begin{center}
        \if\relax\@myschool\relax\else      {\LARGE\@myschool}      ~\\\vspace{1em}\fi
        \if\relax\@mydepartment\relax\else  {\large\@mydepartment}  ~\\\vspace{0.5em}\fi
        \if\relax\@mydivision\relax\else    {\large\@mydivision}    \fi

        \vfill  % Fill space between title header and project logo and headings

        \IfFileExists{images/logo.png}{
            \includegraphics[height=2.5cm]{images/logo.png}
            \vskip 2em    % Space between logo and headings if logo exists
        }{}
        
        {\Huge\textbf\thetitle}                                     ~\\\vspace{1.5em}
        \if\relax\@mysubtitle\relax\else    {\LARGE\@mysubtitle}    \fi

        \vfill  % Fill space between headings and authors
        
        \theauthor                                                      ~\\\vspace{2em}
        \if\relax\@myteacher\relax\else \textbf{Betreuer:} \@myteacher  ~\\\vspace{2em}\fi
        \@date
    \end{center}
}\makeatother

% :: Statutory declaration ::
\makeatletter
\newcommand\makedeclaration{
    \ifen
        \chapter*{Statutory declaration}
        I declare that I have authored this thesis independently, that I have not used other than the declared sources / resources, and that I have explicitly marked all material which has been quoted either literally or by content from the used sources.
    \else
        \chapter*{Eidesstattliche Erklärung}
        Ich erkläre an Eides statt, dass ich die vorliegende Arbeit selbstständig verfasst, andere als die angegebenen Quellen/Hilfsmittel nicht benutzt, und die den benutzten Quellen wörtlich und inhaltlich entnommenen Stellen als solche kenntlich gemacht habe.
    \fi
}
\makeatother


% :: Basic centered figure ::
%  - usage: \makefig{path}{width}{caption}{label}
% TODO: Use options instead of parameters
\newcommand\makefig[4]{
    \begin{figure}[H]
        \centering
        \includegraphics[#2]{#1}
        \ifx\relax#3\relax\else\caption{#3}\fi
        \ifx\relax#4\relax\else\label{#4}\fi
    \end{figure}
}

% :: Math variable declaration
%  - usage: \vardef{variable}{definition}
\newenvironment{vardef}{
	\center\small  % Make variables centered and small
	\begin{tabular}{l l l}
}{\end{tabular} \normalsize \endcenter}
% Add variables to the vardef environment
\newcommand\addvardef[2]{{#1}&\dots&{#2}\\}

% :: Abstract ::
\newenvironment{abstract}[1][]{
    \ifthenelse{\equal{#1}{english}}{
        \selectlanguage{english}
        \chapter*{Abstract}
    }{  % German abstract by default
        \selectlanguage{ngerman}
        \chapter*{Zusammenfassung}
    }
}{  \ifen\selectlanguage{english}\else\selectlanguage{ngerman}\fi}


% :: Code environments ::
% Extra % is used as a linefix for the code interpreter
\ifminted   % Minted goes here
    \newcommand\setcode[1]{\setminted{#1}}  % Code settings
    \newenvironment{code}[2][]{             % Code environment
        \VerbatimEnvironment%
        \begin{minted}[#1]{#2}%
    }{  \end{minted}}

    \newcommand\codein{\mintinline}         % Inline code (alias)
    \newcommand\codeinline{\codein}         % Alias for @kevsoft

    \newcommand\inputcode{\inputminted}     % Input code (alias)

    \newcommand\codeline[3][]{\mint[#1]{#2}\relax#3\relax}  % Single line of code
\else       % Listings goes here
    \newcommand\setcode[1]{\lstset{#1}}                         % Code settings
    \lstnewenvironment{code}[2][]{\lstset{language={#2},#1}}{}  % Code environment

    \newcommand\codein[3][]{\lstinline[language=#2,#1]\relax#3\relax}   % Inline code
    \newcommand\codeinline{\codein}                                     % Alias for @kevsoft
    \newcommand\inputcode[3][]{\lstinputlisting[language=#2,#1]{\detokenize{#3}}}   % Input code

    \newcommand\codeline[3][]{\begin{flushleft}
        \lstinline[language=#2,#1]\relax#3\relax            % Single line of code
    \end{flushleft}}
\fi

% :: Begin Document ::
% Add common commands at the beginning of the document
% TODO: Add options for title and declaration
\AtBeginDocument{
    \pagestyle{empty}
    \pagenumbering{arabic}  % Required by pageslts
    \maketitle              % Titlepage
    \makedeclaration        % Statutory declaration
}

% :: End Document ::
% Add common commands at the end of the document
\AtEndDocument{
    \printglossaries    % List used glossary entries

    \ifnatbib\bibliography{bibliography} % List bibliography entries with natbib
    \else\printbibliography[heading=bibintoc, title={Literaturverzeichnis}]\fi
    
    \iftotalfigures\listoffigures\fi    % Figures
    \iftotaltables\listoftables\fi      % Tables
    \iftotallistings\listoflistings\fi  % Listings
}
