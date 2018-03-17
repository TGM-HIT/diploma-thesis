\ProvidesClass{thesis}

% # Options
% ## Use minted package
\newif\ifen\enfalse
\DeclareOption{en}{\entrue}

% ## Use default latex fonts
\newif\iffonts\fontstrue
\DeclareOption{nofonts}{\fontsfalse}

% ## Do not print logos on titlepage
\newif\iflogos\logostrue
\DeclareOption{nologos}{\logosfalse}

% ## Use minted package
\newif\ifminted\mintedfalse
\DeclareOption{minted}{\mintedtrue}

% ## Use natbib package
\newif\ifnatbib\natbibfalse
\DeclareOption{natbib}{\bibtrue\natbibtrue}

% ## Skip line instead of indent after blank line
\newif\ifparskip\parskipfalse
\DeclareOption{parskip}{\parskiptrue}

% ## Do not color hyperlinks
\newif\ifcolor\colortrue
\DeclareOption{nocolor}{\colorfalse}

% # Pass options
\ProcessOptions \relax
% ## Load article class
\IfFileExists{crimson.sty}{
    \LoadClass[a4paper,11pt]{book}   % Crimson
}{  \LoadClass[a4paper,10pt]{book}}  % Default

% # Packages
\iffonts\IfFileExists{crimson.sty}{\RequirePackage{crimson}}{}  % Fonts
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

\ifnatbib\RequirePackage{natbib}    % Choose backend
\else\RequirePackage[backend=bibtex]{biblatex}\fi

% ## Colors
\definecolor{MyLightGray}{RGB}{252,252,252}
\definecolor{MyBlue}{RGB}{5,102,141}
\definecolor{MyGreen}{RGB}{0,168,150}
\definecolor{MyBrown}{RGB}{143,89,3}
\definecolor{MyOrange}{RGB}{213,111,30}

% ## Require and configure minted or listings
\ifminted
    \RequirePackage[newfloat]{minted}
    \floatplacement{listing}{H} % Override default listing float
    \usemintedstyle{tango}      % autumn, rainbow_dash, tango, trac
    \setminted{ fontsize=\small,
                linenos=true,
                breakanywhere=true,
                breaklines=true,
                framesep=2mm,
                tabsize=4}

    % ## [1] Avoid copying line numbers on listings
    \renewcommand\theFancyVerbLine{
        \BeginAccSupp{method=escape,ActualText={}}
        {\rmfamily\tiny\arabic{FancyVerbLine}}
        \EndAccSupp{}
    }
    \SetupFloatingEnvironment{listing}{listname=Auflistungsverzeichnis,name=Auflistung}
\else
    \RequirePackage{listing}                % Already defined by minted itself
    \RequirePackage{listingsutf8}           % UTF-8 Input support for listings
    \IfFileExists{lst.tex}{\input{lst}}{}   % Load lstlistings config if exists
\fi

% ## Skip lines instead of indents after a blank line
\ifparskip\RequirePackage[parfill]{parskip}\fi

% # Variables
\newcommand\@mysubtitle{}           % Untertitel
\newcommand\mysubtitle[1]{\renewcommand\@mysubtitle{#1}}

\newcommand\@myschool{Technologisches Gewerbemuseum}
\newcommand\myschool[1]{\renewcommand\@myschool{#1}}

\newcommand\@mydepartment{Höhere Technische Lehranstalt für Informationstechnologie}
\newcommand\mydepartment[1]{\renewcommand\@mydepartment{#1}}

\newcommand\@mydivision{}           % Systemtechnik / Medientechnik
\newcommand\mydivision[1]{\renewcommand\@mydivision{#1}}

\newcommand\@myteacher{}            % Michel Borko
\newcommand\myteacher[1]{\renewcommand\@myteacher{#1}}

\newcommand\@currentauthor{}        % Use \and for multiple authors
\newcommand\setauthor[1]{\renewcommand\@currentauthor{#1}}


% # Package configuration
\raggedbottom	            % Stop book documentclass from fucking with paragraph spacing..
\setcounter{secnumdepth}{3} % Make \subsubsections have numbers too

\newcolumntype{Y}{p{.5\textwidth}}  % TabularX

\floatplacement{table}{H}   % Override default table float
\floatplacement{figure}{H}  % Override default figure float

% Hyperlinks
\ifcolor\hypersetup{breaklinks=true, colorlinks=true,   % Color hyperlinks
                    linkcolor=MyBlue, urlcolor=MyBlue, citecolor=MyBlue}
\else\hypersetup{breaklinks=true, colorlinks=false,     % Do not color hyperlinks
                    linkcolor=Black, urlcolor=Black, citecolor=Black}
\fi

% ## Footnotes
\def\arraystretch{1.5}
\renewcommand\thefootnote{\Roman{footnote}}

% ## Header
\pagestyle{fancy}\fancyhf{}

\makeatletter
\fancyhead[L]{\small \thetitle}
\fancyhead[R]{\small \nouppercase{\leftmark}}
\fancyfoot[L]{\small \if\relax\@currentauthor\relax\theauthor\else\@currentauthor\fi}
\fancyfoot[R]{\small \thepage~/~{\lastpageref*{VeryLastPage}}}
\makeatother

\renewcommand{\footrulewidth}{\headrulewidth}

% ## Add glossary / bibliography entries if they exist
\IfFileExists{glossaries.tex}{\input{glossaries}\makeglossaries}{}
\IfFileExists{bibliography.bib}{\addbibresource{bibliography}}{}

% # Makros
% ## Title
\makeatletter
\renewcommand\maketitle{
    \iflogos~\\         % Print logos
        \IfFileExists{images/logo-left.png}{\includegraphics[height=2cm]{images/logo-left.png}}{}
        \hfill
        \IfFileExists{images/logo-right.png}{\includegraphics[height=2cm]{images/logo-right.png}}{}
    \fi
    
    \vskip 2.5cm      % Minimum margin

    \begin{center}
        \if\relax\@myschool\relax\else  {\LARGE\@myschool}
            ~\\\vspace{1em}\fi
        \if\relax\@mydepartment\relax\else  {\large\@mydepartment}
            ~\\\vspace{0.5em}\fi
        \if\relax\@mydivision\relax\else  {\large\@mydivision}\fi

        \vskip 3cm    % Minimum margin

        \IfFileExists{images/logo.png}{
            \includegraphics[height=2.5cm]{images/logo.png}
            \vskip 2em    % Minimum margin
        }{}        
        
        {\Huge\textbf\thetitle}                                     ~\\\vspace{1.5em}
        \if\relax\@mysubtitle\relax\else    {\LARGE\@mysubtitle}    \fi

        \vskip 3cm     % Minimum margin
        
        \theauthor                                                      ~\\\vspace{2em}
        \if\relax\@myteacher\relax\else \textbf{Betreuer:} \@myteacher  ~\\\vspace{2em}\fi
        \@date
    \end{center}

    \vskip 1cm      % Minimum margin
}\makeatother

% ## Statutory declaration
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


% ## Basic centered figure
% \makefig{path}{width}{caption}{label}
\newcommand\makefig[4]{
    \begin{figure}[H]
        \centering
        \includegraphics[#2]{#1}
        \ifx\relax#3\relax
        \else\caption{#3}\fi
        \ifx\relax#4\relax
        \else\label{#4}\fi
    \end{figure}
}

% ## Math variable declaration
\newenvironment{vardef}{
	\center \small
	\begin{tabular}{l l l}
}{\end{tabular} \normalsize \endcenter}
\newcommand\addvardef[2]{
    {#1} & \dots & {#2}\\
}


% ## Environments
\newenvironment{abstract}[1][]{
    \ifthenelse{\equal{#1}{english}}{
        \selectlanguage{english}
        \chapter*{Abstract}
    }{  % German abstract by default
        \selectlanguage{ngerman}
        \chapter*{Zusammenfassung}
    }
}{  \ifen\selectlanguage{english}\else\selectlanguage{ngerman}\fi}


% ## Code environments
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

% ## Add common commands at the beginning of the document
\AtBeginDocument{
    \pagestyle{empty}
    \pagenumbering{arabic}              % Required by pageslts
    \maketitle                          % Titlepage
    \makedeclaration                    % Statutory declaration
}

% ## Add common commands at the end of the document
\AtEndDocument{
    % \glsaddall        % Also list unused glossary entries
    \printglossaries    % List used glossary entries

    \ifnatbib\bibliography{bibliography} % List bibliography entries with natbib
    \else\printbibliography[heading=bibintoc, title={Literaturverzeichnis}]\fi
    
    \iftotalfigures\listoffigures\fi    % Figures
    \iftotaltables\listoftables\fi      % Tables
    \iftotallistings\listoflistings\fi  % Listings
}
