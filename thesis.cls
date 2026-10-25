% ==========================================================
% thesis.cls -- thesis class based on memoir
%
% Defaults: 12pt, A4, two-sided, chapters open on the right.
% Any class option is passed on to memoir.
%
% Metadata (set in the preamble):
%   \setthesistitle{...}      \setthesissubtitle{...} (optional)
%   \setdegreename{...}       \setuniversityname{...}
%   \setauthorname{...}       \setsubmissionyear{...}
%   \setfulfilment{...}       (default: "partial fulfilment")
%   \setthesislogo{file}      (omit for a placeholder box)
%
% Commands:
%   \makethesistitle          title page
%   \chapterstar{Title}       unnumbered chapter, listed in the ToC
%
% Bibliography: biblatex/biber, reads references.bib.
% Glossaries:   acronyms and symbols (run makeglossaries).
% Floats:       figures, tables and algorithms are collected by
%               endfloat and printed as appendices at the end.
% ==========================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2026/10/25 Thesis class (memoir-based)]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax

\LoadClass[12pt,a4paper,twoside,openright]{memoir}

% --------------------------
% Core packages
% --------------------------
\RequirePackage{morewrites} % prevents "no room for a new \write" errors
\RequirePackage{etoolbox}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc} % OK on Overleaf; optional under LuaLaTeX
\RequirePackage{lmodern}
\RequirePackage{microtype}
\RequirePackage{csquotes}
\RequirePackage{lipsum}
\RequirePackage{comment}
\RequirePackage{datetime2}

% Maths
\RequirePackage{amsmath,amssymb}
\RequirePackage{amsthm}
\RequirePackage{nicefrac}

% Loaded early on purpose: moving it after the float packages
% slightly changes the layout of the float pages.
\RequirePackage[hidelinks]{hyperref}

% Graphics
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{eso-pic}
\RequirePackage{tikz}
\usetikzlibrary{shapes.geometric, arrows.meta, positioning, fit, calc, backgrounds, decorations.pathreplacing}
\RequirePackage{tcolorbox}
\RequirePackage{pdflscape}

% Tables
\RequirePackage{booktabs}
\RequirePackage{multirow}
\RequirePackage{tabularx}
\RequirePackage{array}

% Algorithms
\RequirePackage{algorithm}
\RequirePackage{algpseudocode}

% --------------------------
% Page layout and style
% --------------------------
\setlrmarginsandblock{20mm}{20mm}{*}
\setulmarginsandblock{20mm}{20mm}{*}
\checkandfixthelayout
\showtrimson

\pagestyle{headings}
\setSpacing{1.5}
\setsecnumdepth{subsection}

% Empty page style for "intentionally blank" pages
\makepagestyle{intentionalblank}
\makeevenhead{intentionalblank}{}{}{}
\makeoddhead{intentionalblank}{}{}{}
\makeevenfoot{intentionalblank}{}{}{}
\makeoddfoot{intentionalblank}{}{}{}

% Mark blank pages between chapters
\renewcommand*{\cleardoublepage}{%
  \clearpage
  \if@twoside
    \ifodd\c@page\else
      \null
      \vspace*{0.15\textheight}
      \begin{center}
        \noindent \textit{This page is intentionally left blank.}
      \end{center}
      \vfill
      \thispagestyle{intentionalblank}%
      \clearpage
    \fi
  \fi
}

% Every chapter starts on a new right-hand page
\let\oldchapter\chapter
\renewcommand{\chapter}{%
  \cleardoublepage
  \oldchapter
}

% Unnumbered chapter that still appears in the ToC
\newcommand{\chapterstar}[1]{%
  \cleardoublepage
  \chapter*{#1}%
  \addcontentsline{toc}{chapter}{#1}%
}

% --------------------------
% Lists of figures, tables and algorithms
% --------------------------
\renewcommand{\cftfigurepresnum}{Figure~}
\renewcommand{\cftfigureaftersnum}{:\enspace}
\settowidth{\cftfigurenumwidth}{Figure~99:\enspace}

\renewcommand{\cfttablepresnum}{Table~}
\renewcommand{\cfttableaftersnum}{:\enspace}
\settowidth{\cfttablenumwidth}{Table~99:\enspace}

% Recreate the List of Algorithms using memoir's list mechanism
\let\listofalgorithms\relax
\newlistof{listofalgorithms}{loa}{\listalgorithmname}
\newlistentry{algorithm}{loa}{0}

\renewcommand{\cftalgorithmpresnum}{Algorithm~}
\renewcommand{\cftalgorithmaftersnum}{:\enspace}
\settowidth{\cftalgorithmnumwidth}{Algorithm~99:\enspace}

% --------------------------
% Appendix naming
% --------------------------
\renewcommand{\appendixname}{Appendix}
\renewcommand{\appendixpagename}{Appendices}
\renewcommand{\appendixtocname}{Appendices}

% --------------------------
% Floats at the end (endfloat)
% --------------------------
\RequirePackage[nomarkers,nolists]{endfloat}
\DeclareDelayedFloat{algorithm}{algorithms}

% One float per page
\renewcommand{\efloatseparator}{\clearpage}

% Each float type becomes an appendix chapter
\AtBeginFigures{%
  \cleardoublepage
  \appendix
  \refstepcounter{chapter}
  \chapter*{Appendix \thechapter: Figures}
  \addcontentsline{toc}{chapter}{Appendix \thechapter: Figures}
}

\AtBeginTables{%
  \cleardoublepage
  \refstepcounter{chapter}
  \chapter*{Appendix \thechapter: Tables}
  \addcontentsline{toc}{chapter}{Appendix \thechapter: Tables}
}

\AtBeginAlgorithms{%
  \cleardoublepage
  \refstepcounter{chapter}
  \chapter*{Appendix \thechapter: Algorithms}
  \addcontentsline{toc}{chapter}{Appendix \thechapter: Algorithms}
}

% Float pages are filled from the top
\setlength{\@fptop}{0pt}
\setlength{\@fpbot}{0pt plus 1fil}

% Colophon, printed on the last page after the delayed floats.
% Redefine \thesiscolophon in the preamble to change the text.
\newcommand{\thesiscolophon}{%
  This thesis was typeset using \LaTeX\ with a custom \texttt{thesis}
  class based on the \texttt{memoir} document class. The document was
  prepared in 12pt type on A4 paper, using the Latin Modern type family,
  with typographic refinement provided by \texttt{microtype}. Figures,
  tables, algorithms, glossaries, references, and cross-references were
  prepared within a reproducible \LaTeX\ workflow. Technical illustrations
  were produced using \texttt{TikZ}; references were managed using
  \texttt{biblatex} with the \texttt{biber} backend; and delayed floats
  were collected using the \texttt{endfloat} package.%
}

\apptocmd{\processdelayedfloats}{%
  \clearpage
  \thispagestyle{empty}
  \vspace*{\fill}
    \footnotesize
    \noindent\rule{4cm}{0.4pt} \\[0.3cm]
    \noindent \thesiscolophon
    \vfill
    \noindent\rule{4cm}{0.4pt} \\[0.3cm]
    \noindent Prepared at \UniversityName, Hamilton, New Zealand, \SubmissionYear.
}{}{}

% --------------------------
% Glossaries: acronyms + symbols
% --------------------------
\RequirePackage[acronym]{glossaries-extra}
\setabbreviationstyle[acronym]{long-short}

\newglossary{symbols}{sym}{sbl}{List of Symbols}
\makeglossaries

% --------------------------
% Index
% --------------------------
\RequirePackage{makeidx}
\makeindex

% --------------------------
% Bibliography (biblatex)
% --------------------------
\RequirePackage[
  backend=biber,
  bibstyle=ieee,
  citestyle=numeric-comp,
  sorting=nyt,
  sortcites=true,
  doi=true,
  url=true,
  isbn=false
]{biblatex}

\AtBeginBibliography{%
  \small
  \setlength{\bibitemsep}{0.3\baselineskip}
  \setlength{\bibhang}{1.5em}
  \linespread{1}\selectfont
}

\addbibresource{references.bib}

% --------------------------
% Theorem-like environments (numbered within chapter)
% --------------------------
\newtheorem{proposition}{Proposition}[chapter]
\newtheorem{claim}[proposition]{Claim}
\newtheorem{corollary}[proposition]{Corollary}

% Definition style (upright text)
\theoremstyle{definition}
\newtheorem{definition}[proposition]{Definition}
\newtheorem{assumption}[proposition]{Assumption}
\newtheorem{criterion}[proposition]{Criterion}
\newtheorem{principle}[proposition]{Principle}
\newtheorem{result}[proposition]{Result}
\newtheorem{finding}[proposition]{Finding}
\newtheorem{evidence}[proposition]{Evidence}
\newtheorem{case}[proposition]{Case}

% Remark style
\theoremstyle{remark}
\newtheorem{remark}[proposition]{Remark}
\newtheorem{observation}[proposition]{Observation}

% Proof-like blocks with custom names
\newenvironment{justification}[1][Justification]{%
  \begin{proof}[\bfseries #1]%
}{%
  \end{proof}%
}

\newenvironment{argument}[1][Argument]{%
  \begin{proof}[\bfseries #1]%
}{%
  \end{proof}%
}

% --------------------------
% Thesis metadata
% --------------------------
\newcommand{\ThesisTitle}{}
\newcommand{\ThesisSubtitle}{}
\newcommand{\DegreeName}{}
\newcommand{\UniversityName}{}
\newcommand{\AuthorName}{}
\newcommand{\SubmissionYear}{}
\newcommand{\Fulfilment}{partial fulfilment}
\newcommand{\ThesisLogo}{}

\newcommand{\setthesistitle}[1]{\renewcommand{\ThesisTitle}{#1}}
\newcommand{\setthesissubtitle}[1]{\renewcommand{\ThesisSubtitle}{#1}}
\newcommand{\setdegreename}[1]{\renewcommand{\DegreeName}{#1}}
\newcommand{\setuniversityname}[1]{\renewcommand{\UniversityName}{#1}}
\newcommand{\setauthorname}[1]{\renewcommand{\AuthorName}{#1}}
\newcommand{\setsubmissionyear}[1]{\renewcommand{\SubmissionYear}{#1}}
\newcommand{\setfulfilment}[1]{\renewcommand{\Fulfilment}{#1}}
\newcommand{\setthesislogo}[1]{\renewcommand{\ThesisLogo}{#1}}

% Logo on the title page; a dashed placeholder box if no logo is set
\newcommand{\thesislogo}{%
  \ifdefempty{\ThesisLogo}{%
    \begin{tikzpicture}
      \draw[dashed] (0,0) rectangle (0.26\textwidth,0.2\textwidth);
      \node at (0.13\textwidth,0.1\textwidth) {\textsc{Logo}};
    \end{tikzpicture}%
  }{%
    \includegraphics[width=0.26\textwidth]{\ThesisLogo}%
  }%
}

% --------------------------
% Title page
% --------------------------
\newcommand{\makethesistitle}{%
  \thispagestyle{empty}
  \begingroup
  \setlength{\parindent}{0pt}

  \vspace*{12mm}

  \begin{center}
    {\Large\bfseries \ThesisTitle\par}
    \ifdefempty{\ThesisSubtitle}{}{%
      \vspace{4mm}
      {\large \ThesisSubtitle\par}%
    }

    \vspace{16mm}

    A thesis\\
    submitted in \Fulfilment\\
    of the requirements for the degree of\\[4mm]
    {\large\bfseries \DegreeName}\\[10mm]
    at\\[4mm]
    {\large\bfseries \UniversityName}\\[10mm]
    by\\[4mm]
    {\large\bfseries \AuthorName}

    \vfill

    \thesislogo\\[10mm]
    {\large \SubmissionYear}
  \end{center}

  \endgroup
  \clearpage
}

\endinput
