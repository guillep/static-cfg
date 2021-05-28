Class {
	#name : #SCFTikzPictureBenchmarkGenerator,
	#superclass : #Object,
	#instVars : [
		'benchNameMapping'
	],
	#category : #StaticCFPaper
}

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figureFour [

	"self new figureFour"

	| files |
	files := self outputDirectory children select: [ :each | 
		         each basename beginsWith: 'bench' ].
	self generateLargeFigure: files
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figureGameBenchmarkRuntimeCharacterisation [

	"self new figureGameBenchmarkRuntimeCharacterisation"

	self
		generateCharacterizationFigureFor:
			#( 'benchMandelbrot' 'benchPiDigits' 'benchFannkuchRedux'
			   'benchSpectralNorm' 'benchMeteor' 'benchChameleons'
			   'benchThreadRing' 'benchReverseComplement'
			   'benchRegexDNA' )
		named: 'gamebench-characterisation.tex'
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figureGameSuite [

	"self new figureGameSuite"

	self
		generateLargeFigure:
			#( 'benchMandelbrot.tex' 'benchPiDigits.tex' 'benchFannkuchRedux.tex'
			   'benchSpectralNorm.tex' 'benchMeteor.tex' 'benchChameleons.tex'
			   'benchThreadRing.tex' 'benchReverseComplement.tex'
			   'benchRegexDNA.tex' )
		named: 'GameSuite'
		caption: 'Game Suite Benchmarks in milliseconds (b=Baseline, p=\ph, sl=\pe).' anchor: 'table:game'
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figureGenericMicro [

	"self new figureGenericMicro"

	self
		generateLargeFigure:
			#( 'benchSendWithManyArguments.tex'
			   'benchIntLoop.tex' 'benchFloatLoop.tex' 'benchStone.tex'
			   'benchInstVarAccess.tex' 'benchClassVarBinding.tex'
			   'benchArrayAccess.tex' 'benchSend.tex' )
		named: 'GenericMicrobench'
		caption: 'Generic Micro Benchmarks in milliseconds (b=Baseline, p=\ph, sl=\pe).' anchor: 'table:generic'
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figureGenericMicroBenchmarkRuntimeCharacterisation [

	"self new figureGenericMicroBenchmarkRuntimeCharacterisation"

	self
		generateCharacterizationFigureFor:
			#( 'benchSendWithManyArguments'
			   'benchIntLoop' 'benchFloatLoop' 'benchStone'
			   'benchInstVarAccess' 'benchClassVarBinding'
			   'benchArrayAccess' 'benchSend'  )
		named: 'genericmicro-characterisation.tex'
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figureMicroBenchmarkRuntimeCharacterisation [

	"self new figureMicroBenchmarkRuntimeCharacterisation"

	self
		generateCharacterizationFigureFor:
			#( 'benchSequenceOfFalseConditionalBranches'
			   'benchSequenceOfFalseConditionalWithCompensation'
			   'benchVeryLargeFactorial' 'benchLargeFactorial'
			   'benchSequenceOfTrueConditionalWithCompensation'
			   'benchSequenceOfFalseFallthroughs'
			   'benchSequenceOfTrueConditionalBranches'
			   'benchSmallFactorial' )
		named: 'microbench-characterisation.tex'
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figureMicroBenchmarks [

	"self new figuresMicroBenchmarks"

	self
		generateLargeFigure:
			#( 'benchSequenceOfFalseConditionalBranches.tex'
			   'benchSequenceOfFalseConditionalWithCompensation.tex'
			   'benchVeryLargeFactorial.tex' 'benchLargeFactorial.tex'
			   'benchSequenceOfTrueConditionalWithCompensation.tex'
			   'benchSequenceOfFalseFallthroughs.tex'
			   'benchSequenceOfTrueConditionalBranches.tex'
			   'benchSmallFactorial.tex' )
		named: 'ControlFlowMicrobench'
		caption: 'Micro Benchmars in milliseconds (b=Baseline, p=\ph, sl=\pe).' anchor: 'table:micro'
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figureProgramBenchmarkRuntimeCharacterisation [

	"self new figureProgramBenchmarkRuntimeCharacterisation"

	self
		generateCharacterizationFigureFor:
			#( 'benchCompiler' 'benchDeltaBlue' 'benchRichards' )
		named: 'program-characterisation.tex'
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figurePrograms [

	"self new figurePrograms"

	self
		generateLargeFigure:
		#( 'benchCompiler.tex' 'benchDeltaBlue.tex' 'benchRichards.tex' )
		named: 'Programs'
		caption: 'Program Benchmarks in milliseconds (b=Baseline, p=\ph, sl=\pe).' anchor: 'table:program'
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> figureRuntimeCharacterisation [

	"self new figureRuntimeCharacterisation"
	self figureMicroBenchmarkRuntimeCharacterisation.
	self figureGenericMicroBenchmarkRuntimeCharacterisation.
	self figureGameBenchmarkRuntimeCharacterisation.
	self figureProgramBenchmarkRuntimeCharacterisation.
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> fourFigure [
	"self new fourFigure"
	
	self figureGameSuite.
	self figureGenericMicro.
	self figurePrograms.
	self figureMicroBenchmarks.
]

{ #category : #wisker }
SCFTikzPictureBenchmarkGenerator >> generate [

	"SCFTikzPictureBenchmarkGenerator new generate"

	| sortedGroup |
	(self groupedBenchmarkResultFiles select: [ :group | group size = 3 ])
			do: [ :group | 
				sortedGroup := group sorted: [ :a :b | a basename < b basename ].
				self generateOneBench: group ]
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> generateCharacterizationFigureFor: list named: name [

	"self new figureRuntimeCharacterisation"

	| files |
	files := list collect: [ :e |
		self resultsDirectory children detect: [ :f | f basename endsWith: (e, '-baseline.json') ].
	].

	self generateRuntimeCharacterisation: files named: name
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> generateLargeFigure: files [

	(self outputDirectory / 'largeFigure.tex') ensureDelete.
	self outputDirectory / 'largeFigure.tex' writeStreamDo: [ :str | 
		str nextPutAll: '\begin{figure}[!h]'.

		files withIndexDo: [ :f :i | 
			str nextPutAll: '\begin{minipage}{.20\textwidth}'.
			str cr.
			str nextPutAll:
				'\input{' , self outputDirectory basename asString , '/'
				, f basename , '}'.
			str cr.
			str nextPutAll: '\end{minipage}'.
			str cr
			"i \\ 4 = 0 ifTrue: [ str nextPutAll: '\\' , String cr ] " ].

		str nextPutAll: '\caption{TikZ from GeoGebra}
\end{figure}' ]
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> generateLargeFigure: files named: aString [

	(self outputDirectory / aString , 'tex') ensureDelete.
	self outputDirectory / aString , 'tex' writeStreamDo: [ :str | 
		str nextPutAll: '\begin{figure}[!h]'.

		files withIndexDo: [ :f :i | 
			str nextPutAll: '\begin{minipage}{.20\textwidth}'.
			str cr.
			str nextPutAll:
				'\input{' , self outputDirectory basename asString , '/'
				, f asFileReference basename , '}'.
			str cr.
			str nextPutAll: '\end{minipage}'.
			str cr
			"i \\ 4 = 0 ifTrue: [ str nextPutAll: '\\' , String cr ] " ].

		str nextPutAll: '\caption{TikZ from GeoGebra}
\end{figure}' ]
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> generateLargeFigure: files named: aString caption: captionString anchor: ancre [

	(self outputDirectory / aString , 'tex') ensureDelete.
	self outputDirectory / aString , 'tex' writeStreamDo: [ :str | 
		str nextPutAll: '\begin{figure}[!h]'.

		files withIndexDo: [ :f :i | 
			str nextPutAll: '\begin{minipage}{.20\textwidth}'.
			str cr.
			str nextPutAll:
				'\input{' , self outputDirectory basename asString , '/'
				, f asFileReference basename , '}'.
			str cr.
			str nextPutAll: '\end{minipage}'.
			str cr
			"i \\ 4 = 0 ifTrue: [ str nextPutAll: '\\' , String cr ] " ].

		str nextPutAll: '\caption{', captionString, ' Lower is better.\label{', ancre,'}}
\end{figure}' ]
]

{ #category : #wisker }
SCFTikzPictureBenchmarkGenerator >> generateOneBench: group [

	| sortedGroup baseline pettishansen pushdown benchName |
	sortedGroup := group sorted: [ :a :b | a basename < b basename ].
	baseline := sortedGroup first.
	pettishansen := sortedGroup third.
	pushdown := sortedGroup second.

	benchName := (baseline basename substrings: '>>#') second copyUpTo:
		             $-.
	(self outputDirectory / benchName , 'tex') ensureDelete.

	self outputDirectory / benchName , 'tex' writeStreamDo: [ :str | 
		baseline := STON fromStream: baseline readStream.
		pettishansen := STON fromStream: pettishansen readStream.
		pushdown := STON fromStream: pushdown readStream.

		str nextPutAll:
			(self preambleWisk: (benchNameMapping at: benchName ifAbsent: [benchName allButFirst: 'bench' size])).
		self outputResultsFor: baseline inStream: str.
		self outputResultsFor: pettishansen inStream: str.
		self outputResultsFor: pushdown inStream: str.
		str nextPutAll: self postambleWisk ]
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> generateRuntimeCharacterisation: files [

	(self outputDirectory / 'runtime-characterisation.tex')
		ensureDelete;
		writeStreamDo: [ :str | 
			str nextPutAll: '\begin{figure*}[!h]
			  \begin{tikzpicture}
			  \begin{axis}[
			     title={Test stacked},
			    xbar stacked,
			    bar width=10mm,
			    yticklabels={'.
			
			files do: [ :f |
				str nextPutAll: '{'.
				str nextPutAll: (((f basename substrings: '>>#') second allButFirst: 'bench' size)
					copyUpTo: $-) asString.
				str nextPutAll: '}'] separatedBy: [ str nextPutAll: ','. ].
			
			str nextPutAll:'},
			    ytick=data,
			   xtick={0,25, 50 ,75,100},
			  legend style={
    legend columns=4,
        at={(xticklabel cs:0.5)},
        anchor=north,
        draw=none
    },
			   width=.8\textwidth,
			   bar width=3mm,
			   xmin=0,
    xmax=100,
    area legend,
    y=8mm,
    enlarge y limits={abs=0.625},
			  ]
			  %Runtime
			'.
			str nextPutAll: '\addplot [fill=blue] coordinates {'; cr.
			files withIndexDo: [ :f :i | | ston totalRuntime totalGC |
				str nextPutAll: '('.
				ston := STON fromStream: f readStream.
				totalRuntime := (ston at: 'measurements') sum.
				totalGC := (ston at: 'full-gc-time') + (ston at: 'incremental-gc-time').
				str nextPutAll: ((totalRuntime - totalGC - (ston at: 'compilation-time')) / totalRuntime * 100) asFloat asString.

				str nextPutAll: ','.
				str nextPutAll: i asString.
				str
					nextPutAll: ')';
					cr].
			str nextPutAll: '};

			%GC'; cr.
			str nextPutAll: '\addplot [fill=red] coordinates {'; cr.
			files withIndexDo: [ :f :i | | ston totalGC totalRuntime |
				str nextPutAll: '('.
				
				ston := STON fromStream: f readStream.
				totalRuntime := (ston at: 'measurements') sum.
				totalGC := (ston at: 'full-gc-time') + (ston at: 'incremental-gc-time').
				str nextPutAll: (totalGC / totalRuntime * 100) asFloat asString.
				
				str nextPutAll: ','.
				str nextPutAll: i asString.
				str
					nextPutAll: ')';
					cr].
			str nextPutAll: '};
			%Compilation'; cr.
			
			str nextPutAll: '\addplot [fill=green] coordinates {'; cr.
			files withIndexDo: [ :f :i | | ston totalRuntime |
				str nextPutAll: '('.
				
				ston := STON fromStream: f readStream.
				totalRuntime := (ston at: 'measurements') sum.
				str nextPutAll: ((ston at: 'compilation-time') / totalRuntime * 100) asFloat asString.
				
				str nextPutAll: ','.
				str nextPutAll: i asString.
				str
					nextPutAll: ')';
					cr].
			str nextPutAll: '};'; cr.

			str nextPutAll: '\legend{Runtime,GC,Compilation}
  \end{axis}
  \end{tikzpicture}
	\caption{'.
	str nextPutAll: 'caption'.
	str nextPutAll: ' Lower is better.\label{'.
	str nextPutAll: 'anchor'.
	str nextPutAll: '}}
\end{figure*}' ]
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> generateRuntimeCharacterisation: files named: name [

	(self outputDirectory / name)
		ensureDelete;
		writeStreamDo: [ :str | 
			str nextPutAll: '\begin{figure*}[!h]
			  \begin{tikzpicture}
			  \begin{axis}[
			    xbar stacked,
			    bar width=10mm,
			    yticklabels={'.
			
			files do: [ :f | | maybename |
				maybename := ((f basename substrings: '>>#') second)
					copyUpTo: $-.
				str nextPutAll: '{'.
				str nextPutAll: (benchNameMapping at: maybename ifAbsent: [ maybename allButFirst: 'bench' size ]) asString.
				str nextPutAll: '}'] separatedBy: [ str nextPutAll: ','. ].
			
			str nextPutAll:'},
			    ytick=data,
			   xtick={0,25, 50 ,75,100},
			  legend style={
    legend columns=4,
        at={(xticklabel cs:0.5)},
        anchor=north,
        draw=none
    },
			   width=.8\textwidth,
			   bar width=3mm,
			   xmin=0,
    xmax=100,
    area legend,
    y=8mm,
    enlarge y limits={abs=0.625},
			  ]
			  %Runtime
			'.
			str nextPutAll: '\addplot [fill=blue] coordinates {'; cr.
			files withIndexDo: [ :f :i | | ston totalRuntime totalGC |
				str nextPutAll: '('.
				ston := STON fromStream: f readStream.
				totalRuntime := (ston at: 'measurements') sum.
				totalGC := (ston at: 'full-gc-time') + (ston at: 'incremental-gc-time').
				str nextPutAll: ((totalRuntime - totalGC - (ston at: 'compilation-time')) / totalRuntime * 100) asFloat asString.

				str nextPutAll: ','.
				str nextPutAll: i asString.
				str
					nextPutAll: ')';
					cr].
			str nextPutAll: '};

			%GC'; cr.
			str nextPutAll: '\addplot [fill=red] coordinates {'; cr.
			files withIndexDo: [ :f :i | | ston totalGC totalRuntime |
				str nextPutAll: '('.
				
				ston := STON fromStream: f readStream.
				totalRuntime := (ston at: 'measurements') sum.
				totalGC := (ston at: 'full-gc-time') + (ston at: 'incremental-gc-time').
				str nextPutAll: (totalGC / totalRuntime * 100) asFloat asString.
				
				str nextPutAll: ','.
				str nextPutAll: i asString.
				str
					nextPutAll: ')';
					cr].
			str nextPutAll: '};
			%Compilation'; cr.
			
			str nextPutAll: '\addplot [fill=green] coordinates {'; cr.
			files withIndexDo: [ :f :i | | ston totalRuntime |
				str nextPutAll: '('.
				
				ston := STON fromStream: f readStream.
				totalRuntime := (ston at: 'measurements') sum.
				str nextPutAll: ((ston at: 'compilation-time') / totalRuntime * 100) asFloat asString.
				
				str nextPutAll: ','.
				str nextPutAll: i asString.
				str
					nextPutAll: ')';
					cr].
			str nextPutAll: '};'; cr.

			str nextPutAll: '\legend{Runtime,GC,Compilation}
  \end{axis}
  \end{tikzpicture}
	\caption{'.
	str nextPutAll: 'caption'.
	str nextPutAll: ' Lower is better.\label{'.
	str nextPutAll: 'anchor'.
	str nextPutAll: '}}
\end{figure*}' ]
]

{ #category : #accessing }
SCFTikzPictureBenchmarkGenerator >> groupedBenchmarkResultFiles [
	
	^ self resultsDirectory children groupedBy: [ :fileReference |
		fileReference basename copyUpTo: $- ]
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> initialize [

	super initialize.
	benchNameMapping := Dictionary new.
	benchNameMapping at: 'benchMandelbrot' put: 'Mandel'.
	benchNameMapping at: 'benchSendWithManyArguments' put: 'ManyArgs'.
	benchNameMapping
		at: 'benchSequenceOfFalseConditionalBranches'
		put: 'FalseCondition'.
	benchNameMapping
		at: 'benchSequenceOfFalseConditionalWithCompensation'
		put: 'FalseConditionC'.
	benchNameMapping at: 'benchFannkuchRedux' put: 'Fannkuch'.
	benchNameMapping at: 'benchVeryLargeFactorial' put: 'VLargeFactorial'.
	benchNameMapping at: 'benchSpectralNorm' put: 'SpectralNorm'.
	benchNameMapping at: 'benchInstVarAccess' put: 'InstVar'.
	benchNameMapping
		at: 'benchSequenceOfTrueConditionalWithCompensation'
		put: 'TrueConditionC'.
	benchNameMapping
		at: 'benchSequenceOfFalseFallthroughs'
		put: 'FalseConditionF'.
	benchNameMapping
		at: 'benchSequenceOfTrueConditionalBranches'
		put: 'TrueConditional'
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> listOfFigures [

	"self new listOfFigures"

	^ (self outputDirectory children select: [ :each | 
		   each basename beginsWith: 'bench' ]) collect: [ :each | 
		  each basename ]
]

{ #category : #accessing }
SCFTikzPictureBenchmarkGenerator >> outputDirectory [

	^ '/Users/guille/Documents/papers/2021-implicit-control-flow-heuristics/figures'
		  asFileReference
]

{ #category : #generate }
SCFTikzPictureBenchmarkGenerator >> outputResultsFor: aCollection inStream: aWriteStream [

	aWriteStream
		nextPutAll: '\addplot
table[row sep=\\,y index=0] {
data\\';
		cr.
	((aCollection at: 'measurements') allButFirst: 2)
		"remov the warmup" do: [ :e | 
		aWriteStream nextPutAll: e asString.
		aWriteStream nextPutAll: '\\'.
		aWriteStream cr ].
	aWriteStream nextPutAll: '};'.
	aWriteStream cr
]

{ #category : #wisker }
SCFTikzPictureBenchmarkGenerator >> postambleWisk [

	^ '
\end{axis}
\end{tikzpicture}'
]

{ #category : #wisker }
SCFTikzPictureBenchmarkGenerator >> preambleWisk: name [

	^ '\begin{tikzpicture}
\begin{axis}[
   title=',name,',
  boxplot/draw direction=y,
  height=4cm,
  boxplot={
      %
      % Idea: 
      %  place the 
      %  group 1 at 0,2 + 0,4 + 0,6 + 0,8
      %  group 2 at 1,2 + 1,4 + 1,6 + 1,8
      %  group 3 at 2,2 + 2,4 + 2,6 + 2,8
      %  group 3 at 3,2 + 3,4 + 3,6 + 3,8
      %  
      % in a formular:
      draw position={1/5 + floor(\plotnumofactualtype/3) + 1/5*mod(\plotnumofactualtype,3)},
      %
      % that means the box extend must be at most 0.2 :
      box extend=0.15,
  },
  % ... it also means that 1 unit in x controls the width:
  x=3cm,
  % ... and it means that we should describe intervals:
  %xtick={0,1,2,...,50},
   xticklabels={%
        \footnotesize{b},
        $pe$, \tiny{b},
        \tiny{ph},
        \tiny{sl}
        },
   cycle list={{red},{blue},{green}},
]
'
]

{ #category : #accessing }
SCFTikzPictureBenchmarkGenerator >> resultsDirectory [
	
	^ '/Users/guille/Documents/papers/2021-implicit-control-flow-heuristics/benchmarks/results' asFileReference
]
