% ==================== %
% :: Diploma Thesis :: %
% ==================== %

% LaTeX class for diploma theses designed for the HIT department at TGM Vienna.
% Thanks to @chro and @mborko for the previous templates!
%
% @author   Markus Reichl <markus@re1.at> 
% @version  2018-03-15
% @url      https://github.com/tgm-hit/diploma-thesis
%
% TODO: Set authors using multiple author commands / command options
% TODO: Add some thesis related info to the page headings


\ProvidesClass{thesis}
% ------------- %
% :: Options :: %
% ------------- %
\newif\ifen\enfalse             % English language
\DeclareOption{en}{\entrue}
\newif\ifcolor\colortrue        % Do not color links
\DeclareOption{nocolor}{\colorfalse}
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
\newif\ifsans\sansfalse         % Use sans serif fonts
\DeclareOption{sans}{\sanstrue}
\newif\ifnocitesort\nocitesortfalse         % Sort cite by appearance language
\DeclareOption{nocitesort}{\nocitesorttrue}
% Pass options
\ProcessOptions \relax
% Load article class
\IfFileExists{crimson.sty}{
    \LoadClass[a4paper,11pt]{book}   % Crimson
}{  \LoadClass[a4paper,10pt]{book}}  % Default

% -------------- %
% :: Packages :: %
% -------------- %
\iffonts
    \ifsans \renewcommand*\familydefault{\sfdefault}
    \else   \IfFileExists{crimson.sty}{\RequirePackage{crimson}}{}\fi
    \IfFileExists{inconsolate.sty}{\RequirePackage{inconsolata}}{}
\fi

\RequirePackage{geometry, a4wide}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{ccicons, csquotes, amssymb, mathtools}

\ifen\RequirePackage[ngerman, english]{babel}
\else\RequirePackage[english, ngerman]{babel}\fi

\RequirePackage{fancyhdr, float, multicol, multirow, titling}
\RequirePackage[marginal, norule, perpage]{footmisc}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{hyperref, pageslts, nameref}
\RequirePackage{outlines, enumitem}
\RequirePackage{booktabs, tabularx}
\RequirePackage{listings}   % Required by totalcount also without minted
\RequirePackage{graphicx, subcaption, pdfpages}
\RequirePackage[font=small]{caption}
\RequirePackage{accsupp}    % [1]
\RequirePackage[acronym, xindy, toc, nohypertypes={acronym,notation}]{glossaries}
\RequirePackage[figure,table,listing]{totalcount}
\RequirePackage{pgffor, xparse}     % Easier creation of commands with arguments

\ifnatbib\RequirePackage{natbib}    % Bibliography
\else\ifnocitesort\RequirePackage[backend=bibtex,sorting=none,style=ieee]{biblatex} %sorting=none makes the cites appear in order of appearence
\else\RequirePackage[backend=bibtex,style=ieee]{biblatex}\fi\fi

% auto input n.d. if no date of creation is given
\renewbibmacro*{date}{%
  \iffieldundef{year}
    {\bibstring{nodate}}
    {\printdate}}

% Package to linebreak a url at every possible  place   
\RequirePackage{xurl}

\ifminted\RequirePackage[newfloat]{minted}  % Listings
\else\RequirePackage{listing}               % Already defined by minted itself
     \RequirePackage{listingsutf8}\fi       % UTF-8 Input support for listings

% ## Skip lines instead of indents after a blank line
\ifparskip\RequirePackage{parskip}\fi

% ---------------
% :: Variables ::
% ---------------
\definecolor{MyLightGray}{RGB}{252,252,252}
\definecolor{MyBlue}{RGB}{5,102,141}
\definecolor{MyGreen}{RGB}{0,168,150}
\definecolor{MyBrown}{RGB}{143,89,3}
\definecolor{MyOrange}{RGB}{213,111,30}

\newcommand\@mysubtitle{}
\newcommand\mysubtitle[1]{\renewcommand\@mysubtitle{#1}}
\newcommand\@myschool{Technologisches Gewerbemuseum}
\newcommand\myschool[1]{\renewcommand\@myschool{#1}}
\newcommand\@mydepartment{Höhere Technische Lehranstalt für Informationstechnologie}
\newcommand\mydepartment[1]{\renewcommand\@mydepartment{#1}}
\newcommand\@mydivision{}
\newcommand\mydivision[1]{\renewcommand\@mydivision{#1}}
\newcommand\@myteacher{}
\newcommand\myteacher[1]{\renewcommand\@myteacher{#1}}
\newcommand\@myyear{2017/2018}
\newcommand\myyear[1]{\renewcommand\@myyear{#1}}
\newcommand\@currentauthor{}
\newcommand\setauthor[1]{\renewcommand\@currentauthor{#1}}
\newcommand\resetauthor{\renewcommand\@currentauthor{\theauthors}}

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
    % Change listings name in for german language
    \ifen\else\SetupFloatingEnvironment{listing}{
        listname=Auflistungsverzeichnis,name=Auflistung
    }\fi
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
\fancyfoot[L]{\small \if\relax\@currentauthor\relax\theauthors\else\@currentauthor\fi}
\fancyfoot[R]{\small \thepage~/~{\lastpageref*{VeryLastPage}}}
\makeatother

\renewcommand{\footrulewidth}{\headrulewidth}

% Add glossary / bibliography entries if they exist
\IfFileExists{glossaries.tex}{\input{glossaries}\makeglossaries}{}
\IfFileExists{bibliography.bib}{\addbibresource{bibliography}}{}

% Make empty book pages lose their headers and footers
% http://mirror.kumi.systems/ctan/macros/latex/contrib/fancyhdr/fancyhdr.pdf
\makeatletter
\def\cleardoublepage{
    \clearpage\if@twoside\ifodd\c@page\else
        \thispagestyle{empty}\hbox{}\newpage
        \if@twocolumn\hbox{}\newpage\fi
    \fi\fi
}
\makeatother

% :: Hacks ::
\raggedbottom               % Stop book documentclass from fucking with paragraph spacing..
\setcounter{secnumdepth}{3} % Make \subsubsections have numbers too
\def\arraystretch{1.5}      % Adjust table cell spacing
\floatplacement{table}{H}   % Adjust default table float
\floatplacement{figure}{H}  % Adjust default figure float

\renewcommand\thefootnote{\Roman{footnote}} % Roman footnotes
\newcolumntype{Y}{p{.5\textwidth}}  % cell with 50% of text width for TabularX

% ------------
% :: Macros ::
% ------------

% :: Authors ::
% Save authors and author names to variables
\def\authors{}
\def\theauthors{}
% Check for any author
\newif\ifauthor\authorfalse
% Renew the \author command, usage is now \author{name}{class}{subject}
\renewcommand\author[3]{
    \edef\authors{\authors #1;#2;#3*}
    \edef\theauthors{\theauthors\ifauthor,~\fi#1}
    \authortrue
}
% Provide commands for author display on the titlepage
\NewDocumentCommand\printauthor{mmm}{
    \IfNoValueTF{#2}{}{     % TODO: Remove quickcheck #2 with xparse
        \parbox[l]{\textwidth}{#3}\vspace{.25em}
        \makebox[.4\textwidth][l]{#1\hfill#2}~\\\\
    }
}
\NewDocumentCommand\splitauthor{>{\SplitArgument{2}{;}}m}{\printauthor#1}
\NewDocumentCommand\splitauthors{>{\SplitList{*}}m}{\ProcessList{#1}{\splitauthor}}
\NewDocumentCommand\makeauthors{}{\expandafter\splitauthors\expandafter{\authors}}

% :: Title ::
\makeatletter
\renewcommand\maketitle{
    ~\\     % Line fix
    \begin{minipage}{3cm}
        \iflogos\IfFileExists{images/logo-left.png}{
            \includegraphics[width=3cm]{images/logo-left.png}}{}\fi
    \end{minipage}
    \hfill
    \begin{minipage}{.58\textwidth}
        ~\\\centering
        \if\relax\@myschool\relax\else      {\Large\@myschool}\fi
        \if\relax\@mydepartment\relax\else  ~\\\vspace{.5em}{\@mydepartment}    \fi
        \if\relax\@mydivision\relax\else
            ~\\{Schwerpunkt~\@mydivision}\fi
    \end{minipage}
    \hfill
    \begin{minipage}{3cm}
    \iflogos\IfFileExists{images/logo-right.png}{
            \includegraphics[width=3cm]{images/logo-right.png}}{}\fi
    \end{minipage}

    \begin{center}\rule{\textwidth}{.1mm}\end{center}

    \vfill  % Fill space between title header and project logo and headings
    \begin{center}
        \IfFileExists{images/logo.png}{
            \includegraphics[height=3cm]{images/logo.png}
            \vskip 2em}{}   % Space between logo and headings if logo exists
        {\Large\textbf{
            \ifen Diploma Thesis \else Diplomarbeit \fi
        }}~\\\vspace{2em}
        {\Huge\textbf\thetitle}~\\\vspace{1.5em}
        \if\relax\@mysubtitle\relax\else{\Large\@mysubtitle}\fi
    \end{center}
    \vfill  % Fill space between headings and authors

    ~\\\makeauthors{}~\\    % Create list of authors
    \makebox[\textwidth][l]{\if\relax\@myteacher\relax\else \textbf{Betreuer:}~\@myteacher\fi}
    \makebox[\textwidth][l]{\if\relax\@myyear\relax\else Ausgeführt im Schuljahr~\@myyear\fi}
    \begin{center}\rule{\textwidth}{.1mm}\end{center}
    \makebox[\textwidth][l]{Abgabevermerk:}
    \makebox[\textwidth][l]{\@date\hfill Übernommen von: \hspace{3cm}}
}\makeatother

% :: Statutory declaration ::
\newcommand\makedeclaration{
    \ifen   % Prints english version
        \chapter*{Statutory declaration}
        I declare that I have authored this thesis independently, that I have not used other than the declared sources and that I have explicitly marked all material which has been quoted either literally or by content from the used sources. I also used the following generative AI tools [e.g. ChatGPT, Grammarly Go, Midjourney] for the following purpose: [Please state area of application here].
    \else
        \chapter*{Eidesstattliche Erklärung}
        Ich erkläre an Eides statt, dass ich die vorliegende Arbeit selbstständig verfasst, andere als die angegebenen Quellen/Hilfsmittel nicht benutzt und die den benutzten Quellen wörtlich und inhaltlich entnommenen Stellen als solche kenntlich gemacht habe.  Für die Erstellung der Arbeit habe ich auch folgende Hilfsmittel generativer KI-Tools [z. B. ChatGPT, Grammarly Go, Midjourney] zu folgendem Zweck verwendet: [Bitte hier Einsatzgebiet anführen.].
    \fi   % Print german version
    \vspace{3em}~\\
    \ifauthor\foreach \n in \theauthors{
        \makebox[.4\textwidth][c]{\rule{.3\textwidth}{.1mm}}
        \makebox[.6\textwidth][c]{\rule{.5\textwidth}{.1mm}}\vspace{.25em}~\\
        \makebox[.4\textwidth][c]{\small \ifen{Location, Date}\else{Ort, Datum}\fi}
        \makebox[.6\textwidth][c]{\small\n}\vspace{1em}\vspace{1em}~\\
    }\fi
}


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
        % Nomenklatur nach https://www.htl.at/htlat/diplom-und-abschlussarbeiten/diplomarbeiten
        \chapter*{Kurzfassung}
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
    % Adjust geometry for the first page
    \newgeometry{left=1in, right=1in, top=.75in, bottom=.75in}
    \pagestyle{empty}       % Do not show headers for the first few pages
    \pagenumbering{arabic}  % Required by pageslts
    \maketitle              % Titlepage
    \restoregeometry        % Restore geometry to default settings
    \makedeclaration        % Statutory declaration
}

% :: End Document ::
% Add common commands at the end of the document
\AtEndDocument{
    \printglossaries    % List used glossary entries

    \ifnatbib\bibliography{bibliography} % List bibliography entries with natbib
    \else   \ifen\printbibliography[heading=bibintoc]
            \else\printbibliography[heading=bibintoc, title=Literaturverzeichnis]\fi\fi
    
    \iftotalfigures\listoffigures\fi    % Figures
    \iftotaltables\listoftables\fi      % Tables
    \iftotallistings\listoflistings\fi  % Listings

    \IfFileExists{chapters/anhang.tex}{\include{chapters/anhang}}{}
}
