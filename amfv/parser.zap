

	.FUNCT	PARSER,PTR=P-LEXSTART,WRD,VAL=0,VERB=0,OMERGED,OWINNER,LEN,DIR=0,NW=0,LW=0,CNT=-1,OF-FLAG=0,?TMP1,?TMP2
?PRG1:	INC	'CNT
	GRTR?	CNT,P-ITBLLEN \?ELS5
	JUMP	?REP2
?ELS5:	ZERO?	P-OFLAG \?CND8
	GET	P-ITBL,CNT
	PUT	P-OTBL,CNT,STACK
?CND8:	PUT	P-ITBL,CNT,0
	JUMP	?PRG1
?REP2:	SET	'P-NAM,FALSE-VALUE
	PUT	P-NAMW,0,FALSE-VALUE
	PUT	P-NAMW,1,FALSE-VALUE
	SET	'P-ADJ,FALSE-VALUE
	PUT	P-ADJW,0,FALSE-VALUE
	PUT	P-ADJW,1,FALSE-VALUE
	SET	'OMERGED,P-MERGED
	SET	'OWINNER,WINNER
	SET	'P-MERGED,FALSE-VALUE
	SET	'P-END-ON-PREP,FALSE-VALUE
	PUT	P-PRSO,P-MATCHLEN,0
	PUT	P-PRSI,P-MATCHLEN,0
	PUT	P-BUTS,P-MATCHLEN,0
	ZERO?	QUOTE-FLAG \?CND11
	EQUAL?	WINNER,PLAYER /?CND11
	SET	'WINNER,PLAYER
	LOC	WINNER
	FSET?	STACK,VEHBIT /?CND11
	LOC	WINNER >HERE
?CND11:	ZERO?	RESERVE-PTR /?ELS21
	SET	'PTR,RESERVE-PTR
	CALL	STUFF,P-LEXV,RESERVE-LEXV
	CALL	INBUF-STUFF,P-INBUF,RESERVE-INBUF
	EQUAL?	VERBOSITY,1,2 \?CND23
	EQUAL?	PLAYER,WINNER \?CND23
	CRLF	
?CND23:	SET	'RESERVE-PTR,FALSE-VALUE
	SET	'P-CONT,FALSE-VALUE
	JUMP	?CND19
?ELS21:	ZERO?	P-CONT /?ELS29
	SET	'PTR,P-CONT
	EQUAL?	VERBOSITY,1,2 \?CND31
	EQUAL?	PLAYER,WINNER \?CND31
	CRLF	
?CND31:	SET	'P-CONT,FALSE-VALUE
	JUMP	?CND19
?ELS29:	SET	'WINNER,PLAYER
	SET	'QUOTE-FLAG,FALSE-VALUE
	LOC	WINNER
	FSET?	STACK,VEHBIT /?CND38
	LOC	WINNER >HERE
?CND38:	EQUAL?	VERBOSITY,1,2 \?CND41
	CRLF	
?CND41:	GET	0,8
	BTST	STACK,4 \?CND44
	CALL1	REFRESH-STATUS-LINE
	GET	0,8
	BAND	STACK,-5
	PUT	0,8,STACK
?CND44:	PRINTI	">"
	READ	P-INBUF,P-LEXV
?CND19:	GETB	P-LEXV,P-LEXWORDS >P-LEN
	ZERO?	P-LEN \?ELS51
	PRINTI	"[I beg your pardon?]"
	CRLF	
	RFALSE	
?ELS51:	GET	P-LEXV,PTR
	EQUAL?	STACK,W?OOPS \?ELS55
	ADD	PTR,P-LEXELEN
	GET	P-LEXV,STACK
	EQUAL?	STACK,W?PERIOD,W?COMMA \?CND56
	ADD	PTR,P-LEXELEN >PTR
	DEC	'P-LEN
?CND56:	GRTR?	P-LEN,1 /?ELS61
	PRINTI	"[There was no word after OOPS!]"
	CRLF	
	RFALSE	
?ELS61:	GET	OOPS-TABLE,O-PTR >VAL
	ZERO?	VAL /?ELS65
	GRTR?	P-LEN,2 \?CND66
	PRINTI	"[Warning: only the first word after OOPS is used.]"
	CRLF	
?CND66:	ADD	PTR,P-LEXELEN
	GET	P-LEXV,STACK
	PUT	AGAIN-LEXV,VAL,STACK
	SET	'WINNER,OWINNER
	MUL	PTR,P-LEXELEN
	ADD	STACK,6
	GETB	P-LEXV,STACK >?TMP2
	MUL	PTR,P-LEXELEN
	ADD	STACK,7
	GETB	P-LEXV,STACK >?TMP1
	MUL	VAL,P-LEXELEN
	ADD	STACK,3
	CALL	INBUF-ADD,?TMP2,?TMP1,STACK
	CALL	STUFF,P-LEXV,AGAIN-LEXV
	GETB	P-LEXV,P-LEXWORDS >P-LEN
	GET	OOPS-TABLE,O-START >PTR
	CALL	INBUF-STUFF,P-INBUF,OOPS-INBUF
	JUMP	?CND49
?ELS65:	PUT	OOPS-TABLE,O-END,FALSE-VALUE
	PRINTI	"[OOPS is useful only after the ""I don't know the word..."" response.]"
	CRLF	
	RFALSE	
?ELS55:	PUT	OOPS-TABLE,O-END,FALSE-VALUE
?CND49:	GET	P-LEXV,PTR
	EQUAL?	STACK,W?AGAIN,W?G \?ELS79
	ZERO?	P-OFLAG /?ELS82
	PRINTI	"[It's difficult to repeat fragments.]"
	CRLF	
	RFALSE	
?ELS82:	ZERO?	P-WON \?ELS87
	PRINTI	"[That would just repeat a mistake!]"
	CRLF	
	RFALSE	
?ELS87:	EQUAL?	OWINNER,PLAYER /?ELS91
	CALL2	VISIBLE?,OWINNER
	ZERO?	STACK \?ELS91
	PRINTI	"[You can't see"
	CALL2	ARTICLE,OWINNER
	PRINTI	" anymore.]"
	CRLF	
	CALL1	CLEAR-BUF
	RFALSE	
?ELS91:	GRTR?	P-LEN,1 \?ELS99
	ADD	PTR,P-LEXELEN
	GET	P-LEXV,STACK
	EQUAL?	STACK,W?PERIOD,W?COMMA,W?THEN /?THN103
	ADD	PTR,P-LEXELEN
	GET	P-LEXV,STACK
	EQUAL?	STACK,W?AND \?ELS102
?THN103:	MUL	2,P-LEXELEN
	ADD	PTR,STACK >PTR
	GETB	P-LEXV,P-LEXWORDS
	SUB	STACK,2
	PUTB	P-LEXV,P-LEXWORDS,STACK
	JUMP	?CND80
?ELS102:	PRINTI	"[I couldn't understand that sentence.]"
	CRLF	
	RFALSE	
?ELS99:	ADD	PTR,P-LEXELEN >PTR
	GETB	P-LEXV,P-LEXWORDS
	SUB	STACK,1
	PUTB	P-LEXV,P-LEXWORDS,STACK
?CND80:	GETB	P-LEXV,P-LEXWORDS
	GRTR?	STACK,0 \?ELS113
	CALL	STUFF,RESERVE-LEXV,P-LEXV
	CALL	INBUF-STUFF,RESERVE-INBUF,P-INBUF
	SET	'RESERVE-PTR,PTR
	JUMP	?CND111
?ELS113:	SET	'RESERVE-PTR,FALSE-VALUE
?CND111:	SET	'WINNER,OWINNER
	SET	'P-MERGED,OMERGED
	CALL	INBUF-STUFF,P-INBUF,OOPS-INBUF
	CALL	STUFF,P-LEXV,AGAIN-LEXV
	SET	'CNT,-1
	SET	'DIR,AGAIN-DIR
?PRG116:	IGRTR?	'CNT,P-ITBLLEN \?ELS120
	JUMP	?CND77
?ELS120:	GET	P-OTBL,CNT
	PUT	P-ITBL,CNT,STACK
	JUMP	?PRG116
?ELS79:	CALL	STUFF,AGAIN-LEXV,P-LEXV
	CALL	INBUF-STUFF,OOPS-INBUF,P-INBUF
	PUT	OOPS-TABLE,O-START,PTR
	MUL	4,P-LEN
	PUT	OOPS-TABLE,O-LENGTH,STACK
	GETB	P-LEXV,P-LEXWORDS
	MUL	P-LEXELEN,STACK
	ADD	PTR,STACK
	MUL	2,STACK >LEN
	SUB	LEN,1
	GETB	P-LEXV,STACK >?TMP1
	SUB	LEN,2
	GETB	P-LEXV,STACK
	ADD	?TMP1,STACK
	PUT	OOPS-TABLE,O-END,STACK
	SET	'RESERVE-PTR,FALSE-VALUE
	SET	'LEN,P-LEN
	SET	'P-NCN,0
	SET	'P-GETFLAGS,0
?PRG125:	DEC	'P-LEN
	LESS?	P-LEN,0 \?ELS129
	SET	'QUOTE-FLAG,FALSE-VALUE
	JUMP	?CND77
?ELS129:	GET	P-LEXV,PTR >WRD
	ZERO?	WRD \?THN132
	CALL2	NUMBER?,PTR >WRD
	ZERO?	WRD /?ELS131
?THN132:	EQUAL?	WRD,W?TO \?ELS136
	EQUAL?	VERB,ACT?TELL,ACT?ASK \?ELS136
	PUT	P-ITBL,P-VERB,ACT?TELL
	SET	'WRD,W?QUOTE
	JUMP	?CND134
?ELS136:	EQUAL?	WRD,W?THEN \?ELS140
	GRTR?	P-LEN,0 \?ELS140
	ZERO?	VERB \?ELS140
	ZERO?	QUOTE-FLAG \?ELS140
	PUT	P-ITBL,P-VERB,ACT?TELL
	PUT	P-ITBL,P-VERBN,0
	SET	'WRD,W?QUOTE
	JUMP	?CND134
?ELS140:	EQUAL?	WRD,W?PERIOD \?CND134
	EQUAL?	LW,W?MR,W?DR,W?ST \?CND134
	DEC	'P-NCN
	CALL	CHANGE-LEXV,PTR,LW,TRUE-VALUE
	SET	'WRD,LW
	SET	'LW,0
?CND134:	EQUAL?	WRD,W?THEN,W?PERIOD,W?QUOTE \?ELS149
	EQUAL?	WRD,W?QUOTE \?CND150
	ZERO?	QUOTE-FLAG /?ELS155
	SET	'QUOTE-FLAG,FALSE-VALUE
	JUMP	?CND150
?ELS155:	SET	'QUOTE-FLAG,TRUE-VALUE
?CND150:	ZERO?	P-LEN /?THN159
	ADD	PTR,P-LEXELEN >P-CONT
?THN159:	PUTB	P-LEXV,P-LEXWORDS,P-LEN
	JUMP	?CND77
?ELS149:	CALL	WT?,WRD,PS?DIRECTION,P1?DIRECTION >VAL
	ZERO?	VAL /?ELS162
	EQUAL?	VERB,FALSE-VALUE,ACT?WALK \?ELS162
	EQUAL?	LEN,1 /?THN165
	EQUAL?	LEN,2 \?ELS168
	EQUAL?	VERB,ACT?WALK /?THN165
?ELS168:	ADD	PTR,P-LEXELEN
	GET	P-LEXV,STACK >NW
	EQUAL?	NW,W?THEN,W?PERIOD,W?QUOTE \?ELS170
	LESS?	LEN,2 \?THN165
?ELS170:	ZERO?	QUOTE-FLAG /?ELS172
	EQUAL?	LEN,2 \?ELS172
	EQUAL?	NW,W?QUOTE /?THN165
?ELS172:	GRTR?	LEN,2 \?ELS162
	EQUAL?	NW,W?COMMA,W?AND \?ELS162
?THN165:	SET	'DIR,VAL
	EQUAL?	NW,W?COMMA,W?AND \?CND175
	ADD	PTR,P-LEXELEN
	CALL	CHANGE-LEXV,STACK,W?THEN
?CND175:	GRTR?	LEN,2 /?CND127
	SET	'QUOTE-FLAG,FALSE-VALUE
	JUMP	?CND77
?ELS162:	CALL	WT?,WRD,PS?VERB,P1?VERB >VAL
	ZERO?	VAL /?ELS182
	ZERO?	VERB \?ELS182
	SET	'VERB,VAL
	PUT	P-ITBL,P-VERB,VAL
	PUT	P-ITBL,P-VERBN,P-VTBL
	PUT	P-VTBL,0,WRD
	MUL	PTR,2
	ADD	STACK,2 >CNT
	GETB	P-LEXV,CNT
	PUTB	P-VTBL,2,STACK
	ADD	CNT,1
	GETB	P-LEXV,STACK
	PUTB	P-VTBL,3,STACK
	JUMP	?CND127
?ELS182:	CALL	WT?,WRD,PS?PREPOSITION,0 >VAL
	ZERO?	VAL \?THN187
	EQUAL?	WRD,W?ALL,W?ONE,W?BOTH /?THN191
	CALL	WT?,WRD,PS?ADJECTIVE
	ZERO?	STACK \?THN191
	CALL	WT?,WRD,PS?OBJECT
	ZERO?	STACK /?ELS186
?THN191:	SET	'VAL,0 \?ELS186
?THN187:	GRTR?	P-LEN,1 \?ELS195
	ADD	PTR,P-LEXELEN
	GET	P-LEXV,STACK
	EQUAL?	STACK,W?OF \?ELS195
	ZERO?	VAL \?ELS195
	EQUAL?	WRD,W?ALL,W?ONE,W?A /?ELS195
	EQUAL?	WRD,W?BOTH /?ELS195
	SET	'OF-FLAG,TRUE-VALUE
	JUMP	?CND127
?ELS195:	ZERO?	VAL /?ELS199
	ZERO?	P-LEN /?THN202
	ADD	PTR,2
	GET	P-LEXV,STACK
	EQUAL?	STACK,W?THEN,W?PERIOD \?ELS199
?THN202:	SET	'P-END-ON-PREP,TRUE-VALUE
	LESS?	P-NCN,2 \?CND127
	PUT	P-ITBL,P-PREP1,VAL
	PUT	P-ITBL,P-PREP1N,WRD
	JUMP	?CND127
?ELS199:	EQUAL?	P-NCN,2 \?ELS208
	PRINTI	"[There were too many nouns in that sentence.]"
	CRLF	
	RFALSE	
?ELS208:	INC	'P-NCN
	CALL	CLAUSE,PTR,VAL,WRD >PTR
	ZERO?	PTR /FALSE
	LESS?	PTR,0 \?CND127
	SET	'QUOTE-FLAG,FALSE-VALUE
	JUMP	?CND77
?ELS186:	EQUAL?	WRD,W?OF \?ELS219
	ZERO?	OF-FLAG /?THN223
	ADD	PTR,P-LEXELEN
	GET	P-LEXV,STACK
	EQUAL?	STACK,W?PERIOD,W?THEN \?ELS222
?THN223:	CALL2	CANT-USE,PTR
	RFALSE	
?ELS222:	SET	'OF-FLAG,FALSE-VALUE
	JUMP	?CND127
?ELS219:	CALL	WT?,WRD,PS?BUZZ-WORD
	ZERO?	STACK /?ELS228
	JUMP	?CND127
?ELS228:	EQUAL?	VERB,ACT?TELL \?ELS230
	CALL	WT?,WRD,PS?VERB
	ZERO?	STACK /?ELS230
	PRINTI	"[Please consult your manual for the correct way to talk to characters.]"
	CRLF	
	RFALSE	
?ELS230:	CALL2	CANT-USE,PTR
	RFALSE	
?ELS131:	CALL2	UNKNOWN-WORD,PTR
	RFALSE	
?CND127:	SET	'LW,WRD
	ADD	PTR,P-LEXELEN >PTR
	JUMP	?PRG125
?CND77:	PUT	OOPS-TABLE,O-PTR,FALSE-VALUE
	ZERO?	DIR /?CND239
	SET	'PRSA,V?WALK
	SET	'PRSO,DIR
	SET	'P-OFLAG,FALSE-VALUE
	SET	'P-WALK-DIR,DIR
	SET	'AGAIN-DIR,DIR
	RETURN	TRUE-VALUE
?CND239:	ZERO?	P-OFLAG /?CND243
	CALL1	ORPHAN-MERGE
?CND243:	SET	'P-WALK-DIR,FALSE-VALUE
	SET	'AGAIN-DIR,FALSE-VALUE
	CALL1	SYNTAX-CHECK
	ZERO?	STACK /FALSE
	CALL1	SNARF-OBJECTS
	ZERO?	STACK /FALSE
	CALL1	MANY-CHECK
	ZERO?	STACK /FALSE
	CALL1	TAKE-CHECK
	ZERO?	STACK /FALSE
	RTRUE


	.FUNCT	CHANGE-LEXV,PTR,WRD,BPTR=0,X,Y,Z
	ZERO?	BPTR /?CND1
	SUB	PTR,P-LEXELEN
	MUL	2,STACK
	ADD	2,STACK >X
	GETB	P-LEXV,X >Y
	MUL	2,PTR
	ADD	2,STACK >Z
	PUTB	P-LEXV,Z,Y
	PUTB	AGAIN-LEXV,Z,Y
	ADD	1,X
	GETB	P-LEXV,STACK >Y
	MUL	2,PTR
	ADD	3,STACK >Z
	PUTB	P-LEXV,Z,Y
	PUTB	AGAIN-LEXV,Z,Y
?CND1:	PUT	P-LEXV,PTR,WRD
	PUT	AGAIN-LEXV,PTR,WRD
	RTRUE	


	.FUNCT	STUFF,DEST,SRC,MAX=29,PTR=P-LEXSTART,CTR=1,BPTR
	GETB	SRC,0
	PUTB	DEST,0,STACK
	GETB	SRC,1
	PUTB	DEST,1,STACK
?PRG1:	GET	SRC,PTR
	PUT	DEST,PTR,STACK
	MUL	PTR,2
	ADD	STACK,2 >BPTR
	GETB	SRC,BPTR
	PUTB	DEST,BPTR,STACK
	INC	'BPTR
	GETB	SRC,BPTR
	PUTB	DEST,BPTR,STACK
	ADD	PTR,P-LEXELEN >PTR
	IGRTR?	'CTR,MAX \?PRG1
	RTRUE	


	.FUNCT	INBUF-STUFF,DEST,SRC,CNT=-1
?PRG1:	IGRTR?	'CNT,59 /TRUE
	GETB	SRC,CNT
	PUTB	DEST,CNT,STACK
	JUMP	?PRG1


	.FUNCT	INBUF-ADD,LEN,BEG,SLOT,DBEG,CTR=0,TMP,?TMP1
	GET	OOPS-TABLE,O-END >TMP
	ZERO?	TMP /?ELS3
	SET	'DBEG,TMP
	JUMP	?CND1
?ELS3:	GET	OOPS-TABLE,O-LENGTH >TMP
	GETB	AGAIN-LEXV,TMP >?TMP1
	ADD	TMP,1
	GETB	AGAIN-LEXV,STACK
	ADD	?TMP1,STACK >DBEG
?CND1:	ADD	DBEG,LEN
	PUT	OOPS-TABLE,O-END,STACK
?PRG6:	ADD	DBEG,CTR >?TMP1
	ADD	BEG,CTR
	GETB	P-INBUF,STACK
	PUTB	OOPS-INBUF,?TMP1,STACK
	INC	'CTR
	EQUAL?	CTR,LEN \?PRG6
	PUTB	AGAIN-LEXV,SLOT,DBEG
	SUB	SLOT,1
	PUTB	AGAIN-LEXV,STACK,LEN
	RTRUE	


	.FUNCT	WT?,PTR,BIT,B1=5,OFFS=P-P1OFF,TYP
	GETB	PTR,P-PSOFF >TYP
	BTST	TYP,BIT \FALSE
	GRTR?	B1,4 /TRUE
	BAND	TYP,P-P1BITS >TYP
	EQUAL?	TYP,B1 /?CND13
	INC	'OFFS
?CND13:	GETB	PTR,OFFS
	RSTACK	


	.FUNCT	CLAUSE,PTR,VAL,WRD,OFF,NUM,ANDFLG=0,FIRST??=1,NW,LW=0,?TMP1
	SUB	P-NCN,1
	MUL	STACK,2 >OFF
	ZERO?	VAL /?ELS3
	ADD	P-PREP1,OFF >NUM
	PUT	P-ITBL,NUM,VAL
	ADD	NUM,1
	PUT	P-ITBL,STACK,WRD
	ADD	PTR,P-LEXELEN >PTR
	JUMP	?CND1
?ELS3:	INC	'P-LEN
?CND1:	ZERO?	P-LEN \?CND6
	DEC	'P-NCN
	RETURN	-1
?CND6:	ADD	P-NC1,OFF >NUM
	MUL	PTR,2
	ADD	P-LEXV,STACK
	PUT	P-ITBL,NUM,STACK
	GET	P-LEXV,PTR
	EQUAL?	STACK,W?THE,W?A,W?AN \?CND9
	GET	P-ITBL,NUM
	ADD	STACK,4
	PUT	P-ITBL,NUM,STACK
?CND9:	
?PRG12:	DLESS?	'P-LEN,0 \?CND14
	ADD	NUM,1 >?TMP1
	MUL	PTR,2
	ADD	P-LEXV,STACK
	PUT	P-ITBL,?TMP1,STACK
	RETURN	-1
?CND14:	GET	P-LEXV,PTR >WRD
	ZERO?	WRD \?THN20
	CALL2	NUMBER?,PTR >WRD
	ZERO?	WRD /?ELS19
?THN20:	ZERO?	P-LEN \?ELS24
	SET	'NW,0
	JUMP	?CND22
?ELS24:	ADD	PTR,P-LEXELEN
	GET	P-LEXV,STACK >NW
?CND22:	EQUAL?	WRD,W?PERIOD \?ELS29
	EQUAL?	LW,W?MR,W?DR,W?ST \?ELS29
	SET	'LW,0
	JUMP	?CND17
?ELS29:	EQUAL?	WRD,W?AND,W?COMMA \?ELS33
	SET	'ANDFLG,TRUE-VALUE
	JUMP	?CND17
?ELS33:	EQUAL?	WRD,W?ALL,W?ONE,W?BOTH \?ELS35
	EQUAL?	NW,W?OF \?CND17
	DEC	'P-LEN
	ADD	PTR,P-LEXELEN >PTR
	JUMP	?CND17
?ELS35:	EQUAL?	WRD,W?THEN,W?PERIOD /?THN41
	CALL	WT?,WRD,PS?PREPOSITION
	ZERO?	STACK /?ELS40
	GET	P-ITBL,P-VERB
	ZERO?	STACK /?ELS40
	ZERO?	FIRST?? \?ELS40
?THN41:	INC	'P-LEN
	ADD	NUM,1 >?TMP1
	MUL	PTR,2
	ADD	P-LEXV,STACK
	PUT	P-ITBL,?TMP1,STACK
	SUB	PTR,P-LEXELEN
	RETURN	STACK
?ELS40:	ZERO?	ANDFLG /?ELS46
	GET	P-ITBL,P-VERB
	ZERO?	STACK \?ELS46
	SUB	PTR,4 >PTR
	ADD	PTR,2
	CALL	CHANGE-LEXV,STACK,W?THEN
	ADD	P-LEN,2 >P-LEN
	JUMP	?CND17
?ELS46:	CALL	WT?,WRD,PS?OBJECT
	ZERO?	STACK /?ELS50
	GRTR?	P-LEN,0 \?ELS53
	EQUAL?	NW,W?OF \?ELS53
	EQUAL?	WRD,W?ALL,W?ONE /?ELS53
	JUMP	?CND17
?ELS53:	CALL	WT?,WRD,PS?ADJECTIVE
	ZERO?	STACK /?ELS57
	ZERO?	NW /?ELS57
	CALL	WT?,NW,PS?OBJECT
	ZERO?	STACK /?ELS57
	JUMP	?CND17
?ELS57:	ZERO?	ANDFLG \?ELS61
	EQUAL?	NW,W?BUT,W?EXCEPT /?ELS61
	EQUAL?	NW,W?AND,W?COMMA /?ELS61
	ADD	NUM,1 >?TMP1
	ADD	PTR,2
	MUL	STACK,2
	ADD	P-LEXV,STACK
	PUT	P-ITBL,?TMP1,STACK
	RETURN	PTR
?ELS61:	SET	'ANDFLG,FALSE-VALUE
	JUMP	?CND17
?ELS50:	CALL	WT?,WRD,PS?ADJECTIVE
	ZERO?	STACK \?CND17
	CALL	WT?,WRD,PS?BUZZ-WORD
	ZERO?	STACK /?ELS67
	JUMP	?CND17
?ELS67:	CALL	WT?,WRD,PS?PREPOSITION
	ZERO?	STACK /?ELS71
	JUMP	?CND17
?ELS71:	CALL2	CANT-USE,PTR
	RFALSE	
?ELS19:	CALL2	UNKNOWN-WORD,PTR
	RFALSE	
?CND17:	SET	'LW,WRD
	SET	'FIRST??,FALSE-VALUE
	ADD	PTR,P-LEXELEN >PTR
	JUMP	?PRG12


	.FUNCT	NUMBER?,PTR,CNT,BPTR,CHR,SUM=0,TIM=0,?TMP1
	MUL	PTR,2
	ADD	P-LEXV,STACK
	GETB	STACK,2 >CNT
	MUL	PTR,2
	ADD	P-LEXV,STACK
	GETB	STACK,3 >BPTR
?PRG1:	DLESS?	'CNT,0 \?ELS5
	JUMP	?REP2
?ELS5:	GETB	P-INBUF,BPTR >CHR
	EQUAL?	CHR,58 \?ELS10
	SET	'TIM,SUM
	SET	'SUM,0
	JUMP	?CND8
?ELS10:	GRTR?	SUM,10000 /FALSE
	LESS?	CHR,58 \FALSE
	GRTR?	CHR,47 \FALSE
	MUL	SUM,10 >?TMP1
	SUB	CHR,48
	ADD	?TMP1,STACK >SUM
?CND8:	INC	'BPTR
	JUMP	?PRG1
?REP2:	CALL	CHANGE-LEXV,PTR,W?INTNUM
	GRTR?	SUM,9999 /FALSE
	ZERO?	TIM /?CND19
	GRTR?	TIM,23 /FALSE
	MUL	TIM,60
	ADD	SUM,STACK >SUM
?CND19:	SET	'P-NUMBER,SUM
	RETURN	W?INTNUM


	.FUNCT	ORPHAN-MERGE,CNT=-1,TEMP,VERB,BEG,END,ADJ=0,WRD,?TMP1
	SET	'P-OFLAG,FALSE-VALUE
	GET	P-ITBL,P-VERBN
	GET	STACK,0 >WRD
	CALL	WT?,WRD,PS?VERB,P1?VERB >?TMP1
	GET	P-OTBL,P-VERB
	EQUAL?	?TMP1,STACK /?THN4
	CALL	WT?,WRD,PS?ADJECTIVE
	ZERO?	STACK /?ELS3
?THN4:	SET	'ADJ,TRUE-VALUE
	JUMP	?CND1
?ELS3:	CALL	WT?,WRD,PS?OBJECT
	ZERO?	STACK /?CND1
	ZERO?	P-NCN \?CND1
	PUT	P-ITBL,P-VERB,0
	PUT	P-ITBL,P-VERBN,0
	ADD	P-LEXV,2
	PUT	P-ITBL,P-NC1,STACK
	ADD	P-LEXV,6
	PUT	P-ITBL,P-NC1L,STACK
	SET	'P-NCN,1
?CND1:	GET	P-ITBL,P-VERB >VERB
	ZERO?	VERB /?ELS12
	ZERO?	ADJ \?ELS12
	GET	P-OTBL,P-VERB
	EQUAL?	VERB,STACK \FALSE
?ELS12:	EQUAL?	P-NCN,2 /FALSE
	GET	P-OTBL,P-NC1
	EQUAL?	STACK,1 \?ELS18
	GET	P-ITBL,P-PREP1 >TEMP
	GET	P-OTBL,P-PREP1
	EQUAL?	TEMP,STACK /?THN22
	ZERO?	TEMP \FALSE
?THN22:	ZERO?	ADJ /?ELS26
	ADD	P-LEXV,2
	PUT	P-OTBL,P-NC1,STACK
	GET	P-ITBL,P-NC1L
	ZERO?	STACK \?CND28
	ADD	P-LEXV,6
	PUT	P-ITBL,P-NC1L,STACK
?CND28:	ZERO?	P-NCN \?CND24
	SET	'P-NCN,1
	JUMP	?CND24
?ELS26:	GET	P-ITBL,P-NC1
	PUT	P-OTBL,P-NC1,STACK
?CND24:	GET	P-ITBL,P-NC1L
	PUT	P-OTBL,P-NC1L,STACK
	JUMP	?CND10
?ELS18:	GET	P-OTBL,P-NC2
	EQUAL?	STACK,1 \?ELS39
	GET	P-ITBL,P-PREP1 >TEMP
	GET	P-OTBL,P-PREP2
	EQUAL?	TEMP,STACK /?THN43
	ZERO?	TEMP \FALSE
?THN43:	ZERO?	ADJ /?CND45
	ADD	P-LEXV,2
	PUT	P-ITBL,P-NC1,STACK
	GET	P-ITBL,P-NC1L
	ZERO?	STACK \?CND45
	ADD	P-LEXV,6
	PUT	P-ITBL,P-NC1L,STACK
?CND45:	GET	P-ITBL,P-NC1
	PUT	P-OTBL,P-NC2,STACK
	GET	P-ITBL,P-NC1L
	PUT	P-OTBL,P-NC2L,STACK
	SET	'P-NCN,2
	JUMP	?CND10
?ELS39:	ZERO?	P-ACLAUSE /?CND10
	EQUAL?	P-NCN,1 /?ELS59
	ZERO?	ADJ \?ELS59
	SET	'P-ACLAUSE,FALSE-VALUE
	RFALSE	
?ELS59:	GET	P-ITBL,P-NC1 >BEG
	ZERO?	ADJ /?CND64
	ADD	P-LEXV,2 >BEG
	SET	'ADJ,FALSE-VALUE
?CND64:	GET	P-ITBL,P-NC1L >END
?PRG68:	GET	BEG,0 >WRD
	EQUAL?	BEG,END \?ELS72
	ZERO?	ADJ /?ELS75
	CALL2	ACLAUSE-WIN,ADJ
	JUMP	?CND57
?ELS75:	SET	'P-ACLAUSE,FALSE-VALUE
	RFALSE	
?ELS72:	ZERO?	ADJ \?ELS80
	GETB	WRD,P-PSOFF
	BTST	STACK,PS?ADJECTIVE /?THN83
	EQUAL?	WRD,W?ALL,W?ONE \?ELS80
?THN83:	SET	'ADJ,WRD
	JUMP	?CND70
?ELS80:	EQUAL?	WRD,W?ONE \?ELS86
	CALL2	ACLAUSE-WIN,ADJ
	JUMP	?CND57
?ELS86:	GETB	WRD,P-PSOFF
	BTST	STACK,PS?OBJECT \?CND70
	EQUAL?	WRD,P-ANAM \?ELS91
	CALL2	ACLAUSE-WIN,ADJ
	JUMP	?CND10
?ELS91:	CALL1	NCLAUSE-WIN
	JUMP	?CND10
?CND70:	ADD	BEG,P-WORDLEN >BEG
	ZERO?	END \?PRG68
	SET	'END,BEG
	SET	'P-NCN,1
	SUB	BEG,4
	PUT	P-ITBL,P-NC1,STACK
	PUT	P-ITBL,P-NC1L,BEG
	JUMP	?PRG68
?CND57:	
?CND10:	GET	P-OVTBL,0
	PUT	P-VTBL,0,STACK
	GETB	P-OVTBL,2
	PUTB	P-VTBL,2,STACK
	GETB	P-OVTBL,3
	PUTB	P-VTBL,3,STACK
	PUT	P-OTBL,P-VERBN,P-VTBL
	PUTB	P-VTBL,2,0
?PRG97:	IGRTR?	'CNT,P-ITBLLEN \?ELS101
	SET	'P-MERGED,TRUE-VALUE
	RTRUE	
?ELS101:	GET	P-OTBL,CNT
	PUT	P-ITBL,CNT,STACK
	JUMP	?PRG97


	.FUNCT	ACLAUSE-WIN,ADJ,?TMP1
	GET	P-OTBL,P-VERB
	PUT	P-ITBL,P-VERB,STACK
	ADD	P-ACLAUSE,1 >?TMP1
	ADD	P-ACLAUSE,1
	CALL	CLAUSE-COPY,P-OTBL,P-OTBL,P-ACLAUSE,?TMP1,P-ACLAUSE,STACK,ADJ
	GET	P-OTBL,P-NC2
	ZERO?	STACK /?ELS2
	SET	'P-NCN,2
?ELS2:	SET	'P-ACLAUSE,FALSE-VALUE
	RTRUE	


	.FUNCT	NCLAUSE-WIN
	ADD	P-ACLAUSE,1
	CALL	CLAUSE-COPY,P-ITBL,P-OTBL,P-NC1,P-NC1L,P-ACLAUSE,STACK
	GET	P-OTBL,P-NC2
	ZERO?	STACK /?ELS2
	SET	'P-NCN,2
?ELS2:	SET	'P-ACLAUSE,FALSE-VALUE
	RTRUE	


	.FUNCT	WORD-PRINT,CNT,BUF
?PRG1:	DLESS?	'CNT,0 /TRUE
	GETB	P-INBUF,BUF
	PRINTC	STACK
	INC	'BUF
	JUMP	?PRG1


	.FUNCT	UNKNOWN-WORD,PTR,BUF,?TMP1
	PUT	OOPS-TABLE,O-PTR,PTR
	PRINTI	"[I don't know the word """
	MUL	PTR,2 >BUF
	ADD	P-LEXV,BUF
	GETB	STACK,2 >?TMP1
	ADD	P-LEXV,BUF
	GETB	STACK,3
	CALL	WORD-PRINT,?TMP1,STACK
	PRINTI	""".]"
	CRLF	
	SET	'QUOTE-FLAG,FALSE-VALUE
	RETURN	QUOTE-FLAG


	.FUNCT	CANT-USE,PTR,BUF,?TMP1
	PRINTI	"[You used the word """
	MUL	PTR,2 >BUF
	ADD	P-LEXV,BUF
	GETB	STACK,2 >?TMP1
	ADD	P-LEXV,BUF
	GETB	STACK,3
	CALL	WORD-PRINT,?TMP1,STACK
	PRINTI	""" in a way that I don't understand.]"
	CRLF	
	SET	'QUOTE-FLAG,FALSE-VALUE
	SET	'P-OFLAG,FALSE-VALUE
	RETURN	P-OFLAG


	.FUNCT	SYNTAX-CHECK,SYN,LEN,NUM,OBJ,DRIVE1=0,DRIVE2=0,PREP,VERB,TMP,?TMP2,?TMP1
	GET	P-ITBL,P-VERB >VERB
	ZERO?	VERB \?CND1
	PRINTI	"[There was no verb in that sentence!]"
	CRLF	
	RFALSE	
?CND1:	SUB	255,VERB
	GET	VERBS,STACK >SYN
	GETB	SYN,0 >LEN
	ADD	1,SYN >SYN
?PRG6:	GETB	SYN,P-SBITS
	BAND	STACK,P-SONUMS >NUM
	GRTR?	P-NCN,NUM \?ELS10
	JUMP	?CND8
?ELS10:	LESS?	NUM,1 /?ELS12
	ZERO?	P-NCN \?ELS12
	GET	P-ITBL,P-PREP1 >PREP
	ZERO?	PREP /?THN15
	GETB	SYN,P-SPREP1
	EQUAL?	PREP,STACK \?ELS12
?THN15:	SET	'DRIVE1,SYN
	JUMP	?CND8
?ELS12:	GETB	SYN,P-SPREP1 >?TMP1
	GET	P-ITBL,P-PREP1
	EQUAL?	?TMP1,STACK \?CND8
	EQUAL?	NUM,2 \?ELS21
	EQUAL?	P-NCN,1 \?ELS21
	SET	'DRIVE2,SYN
	JUMP	?CND8
?ELS21:	GETB	SYN,P-SPREP2 >?TMP1
	GET	P-ITBL,P-PREP2
	EQUAL?	?TMP1,STACK \?CND8
	CALL2	SYNTAX-FOUND,SYN
	RTRUE	
?CND8:	DLESS?	'LEN,1 \?ELS28
	ZERO?	DRIVE1 \?REP7
	ZERO?	DRIVE2 /?ELS31
	JUMP	?REP7
?ELS31:	PRINT	RECOGNIZE
	CRLF	
	RFALSE	
?ELS28:	ADD	SYN,P-SYNLEN >SYN
	JUMP	?PRG6
?REP7:	ZERO?	DRIVE1 /?ELS44
	GETB	DRIVE1,P-SFWIM1 >?TMP2
	GETB	DRIVE1,P-SLOC1 >?TMP1
	GETB	DRIVE1,P-SPREP1
	CALL	GWIM,?TMP2,?TMP1,STACK >OBJ
	ZERO?	OBJ /?ELS44
	PUT	P-PRSO,P-MATCHLEN,1
	PUT	P-PRSO,1,OBJ
	CALL2	SYNTAX-FOUND,DRIVE1
	RSTACK	
?ELS44:	ZERO?	DRIVE2 /?ELS48
	GETB	DRIVE2,P-SFWIM2 >?TMP2
	GETB	DRIVE2,P-SLOC2 >?TMP1
	GETB	DRIVE2,P-SPREP2
	CALL	GWIM,?TMP2,?TMP1,STACK >OBJ
	ZERO?	OBJ /?ELS48
	PUT	P-PRSI,P-MATCHLEN,1
	PUT	P-PRSI,1,OBJ
	CALL2	SYNTAX-FOUND,DRIVE2
	RSTACK	
?ELS48:	EQUAL?	VERB,ACT?FIND \?ELS52
	PRINTI	"[I can't answer that question.]"
	CRLF	
	RFALSE	
?ELS52:	CALL2	CHANGE-CLOTHES?,VERB
	ZERO?	STACK /?ELS56
	CALL1	V-YELL
	RFALSE	
?ELS56:	EQUAL?	WINNER,PLAYER \?ELS61
	CALL	ORPHAN,DRIVE1,DRIVE2
	PRINTI	"[Wh"
	JUMP	?CND59
?ELS61:	PRINTI	"[Your command was not complete. Next time, type wh"
?CND59:	EQUAL?	VERB,ACT?WALK \?ELS70
	PRINTI	"ere"
	JUMP	?CND68
?ELS70:	ZERO?	DRIVE1 /?ELS78
	GETB	DRIVE1,P-SFWIM1
	EQUAL?	STACK,ACTORBIT /?THN75
?ELS78:	ZERO?	DRIVE2 /?ELS74
	GETB	DRIVE2,P-SFWIM2
	EQUAL?	STACK,ACTORBIT \?ELS74
?THN75:	PRINTI	"om"
	JUMP	?CND68
?ELS74:	PRINTI	"at"
?CND68:	EQUAL?	WINNER,PLAYER \?ELS89
	PRINTI	" do you want to "
	JUMP	?CND87
?ELS89:	PRINTI	" you want"
	CALL2	ARTICLE,WINNER
	PRINTI	" to "
?CND87:	CALL1	VERB-PRINT
	ZERO?	DRIVE2 /?CND98
	CALL	CLAUSE-PRINT,P-NC1,P-NC1L
?CND98:	SET	'P-END-ON-PREP,FALSE-VALUE
	ZERO?	DRIVE1 /?ELS106
	GETB	DRIVE1,P-SPREP1
	JUMP	?CND102
?ELS106:	GETB	DRIVE2,P-SPREP2
?CND102:	CALL2	PREP-PRINT,STACK
	EQUAL?	WINNER,PLAYER \?ELS112
	SET	'P-OFLAG,TRUE-VALUE
	PRINTI	"?]"
	CRLF	
	RFALSE	
?ELS112:	SET	'P-OFLAG,FALSE-VALUE
	PRINTI	".]"
	CRLF	
	RFALSE	


	.FUNCT	CHANGE-CLOTHES?,VERB,TMP
	EQUAL?	VERB,ACT?SET \FALSE
	GET	P-ITBL,P-NC1 >TMP
	ZERO?	TMP /FALSE
	GET	TMP,0
	EQUAL?	STACK,W?CLOTHES,W?CLOTHING /TRUE
	GET	TMP,0
	EQUAL?	STACK,W?MY \FALSE
	GET	TMP,2
	EQUAL?	STACK,W?CLOTHES,W?CLOTHING \FALSE
	RTRUE	


	.FUNCT	VERB-PRINT,TMP,?TMP1
	GET	P-ITBL,P-VERBN >TMP
	ZERO?	TMP \?ELS5
	PRINTI	"tell"
	RTRUE	
?ELS5:	GETB	P-VTBL,2
	ZERO?	STACK \?ELS9
	GET	TMP,0
	PRINTB	STACK
	RTRUE	
?ELS9:	GETB	TMP,2 >?TMP1
	GETB	TMP,3
	CALL	WORD-PRINT,?TMP1,STACK
	PUTB	P-VTBL,2,0
	RTRUE	


	.FUNCT	ORPHAN,D1,D2,CNT=-1
	ZERO?	P-MERGED \?CND1
	PUT	P-OCLAUSE,P-MATCHLEN,0
?CND1:	GET	P-VTBL,0
	PUT	P-OVTBL,0,STACK
	GETB	P-VTBL,2
	PUTB	P-OVTBL,2,STACK
	GETB	P-VTBL,3
	PUTB	P-OVTBL,3,STACK
?PRG4:	IGRTR?	'CNT,P-ITBLLEN \?ELS8
	JUMP	?REP5
?ELS8:	GET	P-ITBL,CNT
	PUT	P-OTBL,CNT,STACK
	JUMP	?PRG4
?REP5:	EQUAL?	P-NCN,2 \?CND11
	CALL	CLAUSE-COPY,P-ITBL,P-OTBL,P-NC2,P-NC2L,P-NC2,P-NC2L
?CND11:	LESS?	P-NCN,1 /?CND14
	CALL	CLAUSE-COPY,P-ITBL,P-OTBL,P-NC1,P-NC1L,P-NC1,P-NC1L
?CND14:	ZERO?	D1 /?ELS21
	GETB	D1,P-SPREP1
	PUT	P-OTBL,P-PREP1,STACK
	PUT	P-OTBL,P-NC1,1
	RTRUE	
?ELS21:	ZERO?	D2 /FALSE
	GETB	D2,P-SPREP2
	PUT	P-OTBL,P-PREP2,STACK
	PUT	P-OTBL,P-NC2,1
	RTRUE	


	.FUNCT	CLAUSE-PRINT,BPTR,EPTR,THE?=1,?TMP1
	GET	P-ITBL,BPTR >?TMP1
	GET	P-ITBL,EPTR
	CALL	BUFFER-PRINT,?TMP1,STACK,THE?
	RSTACK	


	.FUNCT	BUFFER-PRINT,BEG,END,CP,NOSP=0,WRD,FIRST??=1,PN=0,?TMP1
?PRG1:	EQUAL?	BEG,END /TRUE
	ZERO?	NOSP /?ELS10
	SET	'NOSP,FALSE-VALUE
	JUMP	?CND8
?ELS10:	PRINTI	" "
?CND8:	GET	BEG,0 >WRD
	EQUAL?	WRD,W?PERIOD \?ELS18
	SET	'NOSP,TRUE-VALUE
	JUMP	?CND3
?ELS18:	EQUAL?	WRD,W?ME \?ELS20
	PRINTD	ME
	SET	'PN,TRUE-VALUE
	JUMP	?CND3
?ELS20:	EQUAL?	WRD,W?MY \?ELS22
	PRINTI	"your"
	SET	'PN,TRUE-VALUE
	JUMP	?CND3
?ELS22:	CALL2	NAME?,WRD
	ZERO?	STACK /?ELS24
	CALL2	CAPITALIZE,BEG
	SET	'PN,TRUE-VALUE
	JUMP	?CND3
?ELS24:	ZERO?	FIRST?? /?CND27
	ZERO?	PN \?CND27
	ZERO?	CP /?CND27
	PRINTI	"the "
?CND27:	ZERO?	P-OFLAG \?THN37
	ZERO?	P-MERGED /?ELS36
?THN37:	PRINTB	WRD
	JUMP	?CND34
?ELS36:	EQUAL?	WRD,W?IT \?ELS40
	CALL2	ACCESSIBLE?,P-IT-OBJECT
	ZERO?	STACK /?ELS40
	PRINTD	P-IT-OBJECT
	JUMP	?CND34
?ELS40:	GETB	BEG,2 >?TMP1
	GETB	BEG,3
	CALL	WORD-PRINT,?TMP1,STACK
?CND34:	SET	'FIRST??,FALSE-VALUE
?CND3:	ADD	BEG,P-WORDLEN >BEG
	JUMP	?PRG1


	.FUNCT	NAME?,WRD
	EQUAL?	WRD,W?OZ,W?WIZARD,W?CLAVE /TRUE
	EQUAL?	WRD,W?PERELMAN,W?ABE,W?ABRAHAM /TRUE
	EQUAL?	WRD,W?MITCHELL,W?RAV,W?JILL /TRUE
	EQUAL?	WRD,W?VERA,W?GOLD,W?ELEANOR /TRUE
	EQUAL?	WRD,W?FORTZMAN,W?MR,W?DR /TRUE
	EQUAL?	WRD,W?ROCKVIL,W?EMILY,W?WARREN /TRUE
	EQUAL?	WRD,W?ASEEJH,W?RANDU,W?ALYSON /TRUE
	EQUAL?	WRD,W?PRICE,W?HALLEY,W?FRANCISCO /TRUE
	EQUAL?	WRD,W?ERNEST,W?GRIMWOLD,W?ESTHER /TRUE
	EQUAL?	WRD,W?OMNI,W?FABB,W?OMNI-FABB /TRUE
	EQUAL?	WRD,W?RICHARD,W?RYDER,W?MITCH /TRUE
	EQUAL?	WRD,W?FYLA,W?FRITA \FALSE
	RTRUE	


	.FUNCT	CAPITALIZE,PTR,?TMP1
	ZERO?	P-OFLAG \?THN6
	ZERO?	P-MERGED /?ELS5
?THN6:	GET	PTR,0
	PRINTB	STACK
	RTRUE	
?ELS5:	GETB	PTR,3
	GETB	P-INBUF,STACK
	SUB	STACK,32
	PRINTC	STACK
	GETB	PTR,2
	SUB	STACK,1 >?TMP1
	GETB	PTR,3
	ADD	STACK,1
	CALL	WORD-PRINT,?TMP1,STACK
	RSTACK	


	.FUNCT	PREP-PRINT,PREP,WRD
	ZERO?	PREP /FALSE
	PRINTI	" "
	CALL2	PREP-FIND,PREP >WRD
	PRINTB	WRD
	RTRUE	


	.FUNCT	CLAUSE-COPY,SRC,DEST,SRCBEG,SRCEND,DESTBEG,DESTEND,INSRT=0,BEG,END
	GET	SRC,SRCBEG >BEG
	GET	SRC,SRCEND >END
	GET	P-OCLAUSE,P-MATCHLEN
	MUL	STACK,P-LEXELEN
	ADD	STACK,2
	ADD	P-OCLAUSE,STACK
	PUT	DEST,DESTBEG,STACK
?PRG1:	EQUAL?	BEG,END \?ELS5
	GET	P-OCLAUSE,P-MATCHLEN
	MUL	STACK,P-LEXELEN
	ADD	STACK,2
	ADD	P-OCLAUSE,STACK
	PUT	DEST,DESTEND,STACK
	RTRUE	
?ELS5:	ZERO?	INSRT /?CND8
	GET	BEG,0
	EQUAL?	P-ANAM,STACK \?CND8
	CALL2	CLAUSE-ADD,INSRT
?CND8:	GET	BEG,0
	CALL2	CLAUSE-ADD,STACK
?CND3:	ADD	BEG,P-WORDLEN >BEG
	JUMP	?PRG1


	.FUNCT	CLAUSE-ADD,WRD,PTR
	GET	P-OCLAUSE,P-MATCHLEN
	ADD	STACK,2 >PTR
	SUB	PTR,1
	PUT	P-OCLAUSE,STACK,WRD
	PUT	P-OCLAUSE,PTR,0
	PUT	P-OCLAUSE,P-MATCHLEN,PTR
	RTRUE	


	.FUNCT	PREP-FIND,PREP,CNT=0,SIZE
	GET	PREPOSITIONS,0
	MUL	STACK,2 >SIZE
?PRG1:	IGRTR?	'CNT,SIZE /FALSE
	GET	PREPOSITIONS,CNT
	EQUAL?	STACK,PREP \?PRG1
	SUB	CNT,1
	GET	PREPOSITIONS,STACK
	RETURN	STACK


	.FUNCT	SYNTAX-FOUND,SYN
	SET	'P-SYNTAX,SYN
	GETB	SYN,P-SACTION >PRSA
	RETURN	PRSA


	.FUNCT	GWIM,GBIT,LBIT,PREP,OBJ
	EQUAL?	GBIT,KLUDGEBIT \?CND1
	RETURN	ROOMS
?CND1:	SET	'P-GWIMBIT,GBIT
	SET	'P-SLOCBITS,LBIT
	PUT	P-MERGE,P-MATCHLEN,0
	CALL	GET-OBJECT,P-MERGE,FALSE-VALUE
	ZERO?	STACK /?ELS8
	SET	'P-GWIMBIT,0
	GET	P-MERGE,P-MATCHLEN
	EQUAL?	STACK,1 \FALSE
	GET	P-MERGE,1 >OBJ
	PRINTI	"["
	ZERO?	PREP /?CND16
	ZERO?	P-END-ON-PREP \?CND16
	CALL2	PREP-FIND,PREP >PREP
	GET	P-ITBL,P-VERB
	EQUAL?	STACK,ACT?SIT \?ELS23
	EQUAL?	PREP,W?ON \?ELS23
	EQUAL?	OBJ,DINETTE-SET \?ELS23
	PRINTB	W?AT
	JUMP	?CND21
?ELS23:	GET	P-ITBL,P-VERB
	EQUAL?	STACK,ACT?SIT \?ELS27
	EQUAL?	PREP,W?ON \?ELS27
	EQUAL?	OBJ,STADIUM-STANDS \?ELS27
	PRINTB	W?IN
	JUMP	?CND21
?ELS27:	PRINTB	PREP
?CND21:	EQUAL?	PREP,W?OUT \?CND32
	PRINTI	" of"
?CND32:	FSET?	OBJ,NARTICLEBIT /?ELS39
	PRINTI	" the "
	JUMP	?CND16
?ELS39:	PRINTI	" "
?CND16:	CALL2	DPRINT,OBJ
	PRINTI	"]"
	CRLF	
	RETURN	OBJ
?ELS8:	SET	'P-GWIMBIT,0
	RFALSE	


	.FUNCT	SNARF-OBJECTS,PTR
	GET	P-ITBL,P-NC1 >PTR
	ZERO?	PTR /?CND1
	SET	'P-PHR,0
	GETB	P-SYNTAX,P-SLOC1 >P-SLOCBITS
	GET	P-ITBL,P-NC1L
	CALL	SNARFEM,PTR,STACK,P-PRSO
	ZERO?	STACK /FALSE
	GET	P-BUTS,P-MATCHLEN
	ZERO?	STACK /?CND1
	CALL2	BUT-MERGE,P-PRSO >P-PRSO
?CND1:	GET	P-ITBL,P-NC2 >PTR
	ZERO?	PTR /TRUE
	SET	'P-PHR,1
	GETB	P-SYNTAX,P-SLOC2 >P-SLOCBITS
	GET	P-ITBL,P-NC2L
	CALL	SNARFEM,PTR,STACK,P-PRSI
	ZERO?	STACK /FALSE
	GET	P-BUTS,P-MATCHLEN
	ZERO?	STACK /TRUE
	GET	P-PRSI,P-MATCHLEN
	EQUAL?	STACK,1 \?ELS18
	CALL2	BUT-MERGE,P-PRSO >P-PRSO
	RTRUE	
?ELS18:	CALL2	BUT-MERGE,P-PRSI >P-PRSI
	RTRUE	


	.FUNCT	BUT-MERGE,TBL,LEN,BUTLEN,CNT=1,MATCHES=0,OBJ,NTBL,?TMP1,?TMP2
	GET	TBL,P-MATCHLEN >LEN
	PUT	P-MERGE,P-MATCHLEN,0
?PRG1:	DLESS?	'LEN,0 \?ELS5
	JUMP	?REP2
?ELS5:	ZERO?	P-BUTS /?ELS7
	GET	TBL,CNT >OBJ
	ADD	P-BUTS,2 >?TMP1
	GET	P-BUTS,0
	INTBL?	OBJ,?TMP1,STACK \?ELS7
	JUMP	?CND3
?ELS7:	ADD	MATCHES,1
	PUT	P-MERGE,STACK,OBJ
	INC	'MATCHES
?CND3:	INC	'CNT
	JUMP	?PRG1
?REP2:	PUT	P-MERGE,P-MATCHLEN,MATCHES
	SET	'NTBL,P-MERGE
	SET	'P-MERGE,TBL
	RETURN	NTBL


	.FUNCT	SNARFEM,PTR,EPTR,TBL,BUT=0,LEN,TMP,WRD,NW,ONEOBJ,WAS-ALL=0
	SET	'P-AND,FALSE-VALUE
	EQUAL?	P-GETFLAGS,P-ALL \?CND1
	SET	'WAS-ALL,TRUE-VALUE
?CND1:	SET	'P-GETFLAGS,0
	PUT	P-BUTS,P-MATCHLEN,0
	PUT	TBL,P-MATCHLEN,0
	GET	PTR,0 >WRD
?PRG4:	EQUAL?	PTR,EPTR \?ELS8
	ZERO?	BUT /?ORP12
	PUSH	BUT
	JUMP	?THN9
?ORP12:	PUSH	TBL
?THN9:	CALL2	GET-OBJECT,STACK >TMP
	ZERO?	WAS-ALL /?CND13
	SET	'P-GETFLAGS,P-ALL
?CND13:	RETURN	TMP
?ELS8:	GET	PTR,P-LEXELEN >NW
	EQUAL?	WRD,W?ALL,W?BOTH \?ELS21
	SET	'P-GETFLAGS,P-ALL
	EQUAL?	NW,W?OF \?CND19
	ADD	PTR,P-WORDLEN >PTR
	JUMP	?CND19
?ELS21:	EQUAL?	WRD,W?BUT,W?EXCEPT \?ELS26
	ZERO?	BUT /?ORP32
	PUSH	BUT
	JUMP	?THN29
?ORP32:	PUSH	TBL
?THN29:	CALL2	GET-OBJECT,STACK
	ZERO?	STACK /FALSE
	SET	'BUT,P-BUTS
	PUT	BUT,P-MATCHLEN,0
	JUMP	?CND6
?ELS26:	EQUAL?	WRD,W?A,W?ONE \?ELS34
	ZERO?	P-ADJ \?ELS37
	SET	'P-GETFLAGS,P-ONE
	EQUAL?	NW,W?OF \?CND6
	ADD	PTR,P-WORDLEN >PTR
	JUMP	?CND6
?ELS37:	SET	'P-NAM,ONEOBJ
	ZERO?	BUT /?ORP48
	PUSH	BUT
	JUMP	?THN45
?ORP48:	PUSH	TBL
?THN45:	CALL2	GET-OBJECT,STACK
	ZERO?	STACK /FALSE
	ZERO?	NW /TRUE
	JUMP	?CND6
?ELS34:	EQUAL?	WRD,W?AND,W?COMMA \?ELS52
	EQUAL?	NW,W?AND,W?COMMA /?ELS52
	SET	'P-AND,TRUE-VALUE
	ZERO?	BUT /?ORP60
	PUSH	BUT
	JUMP	?THN57
?ORP60:	PUSH	TBL
?THN57:	CALL2	GET-OBJECT,STACK
	ZERO?	STACK \?CND19
	RFALSE	
?ELS52:	CALL	WT?,WRD,PS?BUZZ-WORD
	ZERO?	STACK /?ELS62
	JUMP	?CND6
?ELS62:	EQUAL?	WRD,W?AND,W?COMMA \?ELS64
	JUMP	?CND6
?ELS64:	EQUAL?	WRD,W?OF \?ELS66
	ZERO?	P-GETFLAGS \?CND19
	SET	'P-GETFLAGS,P-INHIBIT
	JUMP	?CND19
?ELS66:	CALL	WT?,WRD,PS?ADJECTIVE
	ZERO?	STACK /?ELS71
	CALL2	ADJ-CHECK,WRD
	ZERO?	STACK /?ELS71
	EQUAL?	NW,W?OF /?ELS71
	SET	'P-ADJ,WRD
	JUMP	?CND6
?ELS71:	CALL	WT?,WRD,PS?OBJECT
	ZERO?	STACK /?CND6
	SET	'P-NAM,WRD
	SET	'ONEOBJ,WRD
?CND19:	
?CND6:	EQUAL?	PTR,EPTR /?PRG4
	ADD	PTR,P-WORDLEN >PTR
	SET	'WRD,NW
	JUMP	?PRG4


	.FUNCT	ADJ-CHECK,WRD
	ZERO?	P-ADJ /TRUE
	EQUAL?	WRD,W?HVAC,W?JANITORIA,W?RED /TRUE
	EQUAL?	WRD,W?MORNING,W?EVENING,W?BROWN \FALSE
	RTRUE


	.FUNCT	NOUN-MISSING
	EQUAL?	P-NAM,W?ALL,W?BOTH \?ELS5
	PRINT	REFERRING
	CRLF	
	RTRUE	
?ELS5:	PRINTR	"[There seems to be a noun missing in that sentence.]"


	.FUNCT	GET-OBJECT,TBL,VRB=1,BITS,LEN,XBITS,TLEN,GCHECK=0,OLEN=0,OBJ
	SET	'XBITS,P-SLOCBITS
	GET	TBL,P-MATCHLEN >TLEN
	BTST	P-GETFLAGS,P-INHIBIT /TRUE
	ZERO?	P-NAM \?CND4
	ZERO?	P-ADJ /?CND4
	CALL	WT?,P-ADJ,PS?OBJECT
	ZERO?	STACK /?CND4
	SET	'P-NAM,P-ADJ
	SET	'P-ADJ,FALSE-VALUE
?CND4:	ZERO?	P-NAM \?CND9
	ZERO?	P-ADJ \?CND9
	EQUAL?	P-GETFLAGS,P-ALL /?CND9
	ZERO?	P-GWIMBIT \?CND9
	ZERO?	VRB /FALSE
	CALL1	NOUN-MISSING
	RFALSE	
?CND9:	EQUAL?	P-GETFLAGS,P-ALL \?THN21
	ZERO?	P-SLOCBITS \?CND18
?THN21:	SET	'P-SLOCBITS,-1
?CND18:	
?PRG23:	ZERO?	GCHECK /?ELS27
	CALL2	GLOBAL-CHECK,TBL
	JUMP	?CND25
?ELS27:	FCLEAR	PLAYER,TRANSBIT
	CALL	DO-SL,HERE,SOG,SIR,TBL
	FSET	PLAYER,TRANSBIT
	CALL	DO-SL,PLAYER,SH,SC,TBL
?CND25:	GET	TBL,P-MATCHLEN
	SUB	STACK,TLEN >LEN
	BTST	P-GETFLAGS,P-ALL \?ELS33
	JUMP	?CND31
?ELS33:	BTST	P-GETFLAGS,P-ONE \?ELS37
	ZERO?	LEN /?ELS37
	EQUAL?	LEN,1 /?CND40
	RANDOM	LEN
	GET	TBL,STACK
	PUT	TBL,1,STACK
	PRINTI	"[How about the "
	GET	TBL,1
	PRINTD	STACK
	PRINTI	"?]"
	CRLF	
?CND40:	PUT	TBL,P-MATCHLEN,1
	JUMP	?CND31
?ELS37:	GRTR?	LEN,1 /?THN49
	ZERO?	LEN \?ELS48
	EQUAL?	P-SLOCBITS,-1 /?ELS48
?THN49:	EQUAL?	P-SLOCBITS,-1 \?ELS55
	SET	'P-SLOCBITS,XBITS
	SET	'OLEN,LEN
	GET	TBL,P-MATCHLEN
	SUB	STACK,LEN
	PUT	TBL,P-MATCHLEN,STACK
	JUMP	?PRG23
?ELS55:	PUT	P-NAMW,P-PHR,P-NAM
	PUT	P-ADJW,P-PHR,P-ADJ
	ZERO?	LEN \?CND58
	SET	'LEN,OLEN
?CND58:	ZERO?	P-NAM /?ELS63
	ADD	TLEN,1
	GET	TBL,STACK >OBJ
	ZERO?	OBJ /?ELS63
	GETP	OBJ,P?GENERIC
	CALL	STACK >OBJ
	ZERO?	OBJ /?ELS63
	EQUAL?	OBJ,NOT-HERE-OBJECT /FALSE
	PUT	TBL,1,OBJ
	PUT	TBL,P-MATCHLEN,1
	SET	'P-NAM,FALSE-VALUE
	SET	'P-ADJ,FALSE-VALUE
	RTRUE	
?ELS63:	ZERO?	VRB /?ELS70
	EQUAL?	WINNER,PLAYER /?ELS70
	CALL	WHICH-PRINT,TLEN,LEN,TBL
	RFALSE	
?ELS70:	ZERO?	VRB /?ELS74
	ZERO?	P-NAM /?ELS74
	CALL	WHICH-PRINT,TLEN,LEN,TBL
	EQUAL?	TBL,P-PRSO \?ELS81
	PUSH	P-NC1
	JUMP	?CND77
?ELS81:	PUSH	P-NC2
?CND77:	SET	'P-ACLAUSE,STACK
	SET	'P-AADJ,P-ADJ
	SET	'P-ANAM,P-NAM
	CALL	ORPHAN,FALSE-VALUE,FALSE-VALUE
	SET	'P-OFLAG,TRUE-VALUE
	JUMP	?CND61
?ELS74:	ZERO?	VRB /?CND61
	CALL1	NOUN-MISSING
?CND61:	SET	'P-NAM,FALSE-VALUE
	SET	'P-ADJ,FALSE-VALUE
	RFALSE	
?ELS48:	ZERO?	LEN \?ELS88
	ZERO?	GCHECK /?ELS88
	PUT	P-NAMW,P-PHR,P-NAM
	PUT	P-ADJW,P-PHR,P-ADJ
	ZERO?	VRB /?CND91
	SET	'P-SLOCBITS,XBITS
	CALL	OBJ-FOUND,NOT-HERE-OBJECT,TBL
	SET	'P-XNAM,P-NAM
	SET	'P-XADJ,P-ADJ
	SET	'P-NAM,FALSE-VALUE
	SET	'P-ADJ,FALSE-VALUE
	RTRUE	
?CND91:	SET	'P-NAM,FALSE-VALUE
	SET	'P-ADJ,FALSE-VALUE
	RFALSE	
?ELS88:	ZERO?	LEN \?CND31
	SET	'GCHECK,TRUE-VALUE
	JUMP	?PRG23
?CND31:	SET	'P-SLOCBITS,XBITS
	PUT	P-NAMW,P-PHR,P-NAM
	PUT	P-ADJW,P-PHR,P-ADJ
	SET	'P-NAM,FALSE-VALUE
	SET	'P-ADJ,FALSE-VALUE
	RTRUE	


	.FUNCT	MOBY-FIND,TBL,OBJ=1,LEN,FOO,NAM,ADJ
	SET	'NAM,P-NAM
	SET	'ADJ,P-ADJ
	SET	'P-NAM,P-XNAM
	SET	'P-ADJ,P-XADJ
	PUT	TBL,P-MATCHLEN,0
?PRG3:	IN?	OBJ,ROOMS /?CND5
	CALL2	THIS-IT?,OBJ >FOO
	ZERO?	FOO /?CND5
	CALL	OBJ-FOUND,OBJ,TBL >FOO
?CND5:	IGRTR?	'OBJ,MUSEUM-ENTRANCE \?PRG3
	GET	TBL,P-MATCHLEN >LEN
	EQUAL?	LEN,1 \?CND13
	GET	TBL,1 >P-MOBY-FOUND
?CND13:	SET	'P-NAM,NAM
	SET	'P-ADJ,ADJ
	RETURN	LEN


	.FUNCT	WHICH-PRINT,TLEN,LEN,TBL,OBJ,RLEN
	ZERO?	LEN \?CND1
	PRINT	REFERRING
	CRLF	
	RTRUE	
?CND1:	SET	'RLEN,LEN
	EQUAL?	WINNER,PLAYER /?ELS8
	PRINTI	"""I don't understand "
	EQUAL?	P-NAM,W?MODE \?ELS13
	PRINTI	"which mode you mean"
	JUMP	?CND6
?ELS13:	PRINTI	"if you mean "
	JUMP	?CND6
?ELS8:	PRINTI	"[Which"
	ZERO?	P-OFLAG \?THN27
	ZERO?	P-MERGED \?THN27
	ZERO?	P-AND /?ELS26
?THN27:	PRINTI	" "
	PRINTB	P-NAM
	JUMP	?CND24
?ELS26:	EQUAL?	TBL,P-PRSO \?ELS32
	CALL	CLAUSE-PRINT,P-NC1,P-NC1L,FALSE-VALUE
	JUMP	?CND24
?ELS32:	CALL	CLAUSE-PRINT,P-NC2,P-NC2L,FALSE-VALUE
?CND24:	PRINTI	" do you mean"
	EQUAL?	P-NAM,W?MODE /?CND6
	PRINTI	", "
?CND6:	EQUAL?	P-NAM,W?MODE /?CND42
?PRG45:	INC	'TLEN
	GET	TBL,TLEN >OBJ
	FSET?	OBJ,NARTICLEBIT /?CND47
	PRINTI	"the "
?CND47:	CALL2	DPRINT,OBJ
	EQUAL?	LEN,2 \?ELS56
	EQUAL?	RLEN,2 /?CND57
	PRINTI	","
?CND57:	PRINTI	" or "
	JUMP	?CND54
?ELS56:	GRTR?	LEN,2 \?CND54
	PRINTI	", "
?CND54:	DLESS?	'LEN,1 \?PRG45
?CND42:	EQUAL?	WINNER,PLAYER /?ELS75
	PRINTR	"."""
?ELS75:	PRINTR	"?]"


	.FUNCT	GLOBAL-CHECK,TBL,LEN,RMG,RMGL,CNT=0,OBJ,OBITS,FOO
	GET	TBL,P-MATCHLEN >LEN
	SET	'OBITS,P-SLOCBITS
	GETPT	HERE,P?GLOBAL >RMG
	ZERO?	RMG /?CND1
	PTSIZE	RMG
	DIV	STACK,2
	SUB	STACK,1 >RMGL
?PRG4:	GET	RMG,CNT >OBJ
	CALL2	THIS-IT?,OBJ
	ZERO?	STACK /?CND6
	CALL	OBJ-FOUND,OBJ,TBL
?CND6:	IGRTR?	'CNT,RMGL \?PRG4
?CND1:	GET	TBL,P-MATCHLEN
	EQUAL?	STACK,LEN \FALSE
	SET	'P-SLOCBITS,-1
	CALL	DO-SL,GLOBAL-OBJECTS,1,1,TBL
	SET	'P-SLOCBITS,OBITS
	RETURN	P-SLOCBITS


	.FUNCT	DO-SL,OBJ,BIT1,BIT2,TBL,MOBY-FLAG=0,BTS
	ADD	BIT1,BIT2
	BTST	P-SLOCBITS,STACK \?ELS5
	CALL	SEARCH-LIST,OBJ,TBL,P-SRCALL,MOBY-FLAG
	RSTACK	
?ELS5:	BTST	P-SLOCBITS,BIT1 \?ELS12
	CALL	SEARCH-LIST,OBJ,TBL,P-SRCTOP,MOBY-FLAG
	RSTACK	
?ELS12:	BTST	P-SLOCBITS,BIT2 \TRUE
	CALL	SEARCH-LIST,OBJ,TBL,P-SRCBOT,MOBY-FLAG
	RSTACK	


	.FUNCT	SEARCH-LIST,OBJ,TBL,LVL,MOBY-FLAG=0,FLS,NOBJ
	FIRST?	OBJ >OBJ \FALSE
?PRG6:	EQUAL?	LVL,P-SRCBOT /?CND8
	GETPT	OBJ,P?SYNONYM
	ZERO?	STACK /?CND8
	CALL2	THIS-IT?,OBJ
	ZERO?	STACK /?CND8
	CALL	OBJ-FOUND,OBJ,TBL
?CND8:	EQUAL?	LVL,P-SRCTOP \?THN18
	FSET?	OBJ,SEARCHBIT /?THN18
	FSET?	OBJ,SURFACEBIT \?CND13
?THN18:	FIRST?	OBJ >NOBJ \?CND13
	FSET?	OBJ,OPENBIT /?THN23
	FSET?	OBJ,TRANSBIT /?THN23
	ZERO?	MOBY-FLAG /?CND13
?THN23:	FSET?	OBJ,SURFACEBIT \?ELS29
	PUSH	P-SRCALL
	JUMP	?CND25
?ELS29:	FSET?	OBJ,SEARCHBIT \?ELS31
	PUSH	P-SRCALL
	JUMP	?CND25
?ELS31:	PUSH	P-SRCTOP
?CND25:	CALL	SEARCH-LIST,OBJ,TBL,STACK,MOBY-FLAG >FLS
?CND13:	NEXT?	OBJ >OBJ /?PRG6
	RTRUE	


	.FUNCT	OBJ-FOUND,OBJ,TBL,PTR
	GET	TBL,P-MATCHLEN
	ADD	1,STACK >PTR
	PUT	TBL,PTR,OBJ
	PUT	TBL,P-MATCHLEN,PTR
	RTRUE	


	.FUNCT	TAKE-CHECK
	GETB	P-SYNTAX,P-SLOC1
	CALL	ITAKE-CHECK,P-PRSO,STACK
	ZERO?	STACK /FALSE
	GETB	P-SYNTAX,P-SLOC2
	CALL	ITAKE-CHECK,P-PRSI,STACK
	RSTACK	


	.FUNCT	ITAKE-CHECK,TBL,IBITS,PTR,OBJ,TAKEN
	GET	TBL,P-MATCHLEN >PTR
	ZERO?	PTR /TRUE
	BTST	IBITS,SHAVE /?THN8
	BTST	IBITS,STAKE \TRUE
?THN8:	
?PRG10:	DLESS?	'PTR,0 /TRUE
	ADD	PTR,1
	GET	TBL,STACK >OBJ
	EQUAL?	OBJ,IT \?CND17
	CALL2	ACCESSIBLE?,P-IT-OBJECT
	ZERO?	STACK \?ELS22
	PRINT	REFERRING
	CRLF	
	RFALSE	
?ELS22:	SET	'OBJ,P-IT-OBJECT
?CND17:	CALL2	HELD?,OBJ
	ZERO?	STACK \?PRG10
	EQUAL?	OBJ,HANDS,HEAD,CLOTHES /?PRG10
	EQUAL?	PRSA,V?SGIVE \?ELS33
	EQUAL?	WINNER,SPEAR-CARRIER /?PRG10
?ELS33:	EQUAL?	OBJ,GUN \?ELS35
	EQUAL?	WINNER,SABOTEURS,NATIONAL-GUARDSMAN /?PRG10
?ELS35:	EQUAL?	OBJ,SHOWER,BATHROOM-OBJECT,RECORD-BUFFER \?ELS29
	EQUAL?	PRSA,V?SGIVE,V?GIVE \?ELS29
	JUMP	?PRG10
?ELS29:	SET	'PRSO,OBJ
	FSET?	OBJ,TRYTAKEBIT \?ELS42
	SET	'TAKEN,TRUE-VALUE
	JUMP	?CND40
?ELS42:	EQUAL?	WINNER,PLAYER /?ELS44
	SET	'TAKEN,FALSE-VALUE
	JUMP	?CND40
?ELS44:	BTST	IBITS,STAKE \?ELS46
	CALL2	ITAKE,FALSE-VALUE
	EQUAL?	STACK,TRUE-VALUE \?ELS46
	SET	'TAKEN,FALSE-VALUE
	JUMP	?CND40
?ELS46:	SET	'TAKEN,TRUE-VALUE
?CND40:	ZERO?	TAKEN /?ELS53
	BTST	IBITS,SHAVE \?ELS53
	GET	TBL,P-MATCHLEN
	LESS?	1,STACK \?ELS58
	PRINT	NOT-HOLDING
	PRINTI	" all those things!"
	CRLF	
	RFALSE	
?ELS58:	EQUAL?	OBJ,NOT-HERE-OBJECT \?CND56
	PRINTI	"[You can't see that here!]"
	CRLF	
	RFALSE	
?CND56:	EQUAL?	WINNER,PLAYER \?ELS67
	PRINT	NOT-HOLDING
	JUMP	?CND65
?ELS67:	PRINTI	"It doesn't look as if"
	CALL	ARTICLE,WINNER,TRUE-VALUE
	CALL2	PLURAL,WINNER
	PRINTI	" holding"
?CND65:	CALL	ARTICLE,OBJ,TRUE-VALUE
	SET	'P-IT-OBJECT,OBJ
	PRINTI	"."
	CRLF	
	RFALSE	
?ELS53:	ZERO?	TAKEN \?PRG10
	EQUAL?	WINNER,PLAYER \?PRG10
	PRINTI	"[taking"
	CALL	ARTICLE,OBJ,TRUE-VALUE
	PRINTI	" first]"
	CRLF	
	JUMP	?PRG10


	.FUNCT	MANY-CHECK,LOSS=0,TMP,?TMP1
	GET	P-PRSO,P-MATCHLEN
	GRTR?	STACK,1 \?ELS3
	GETB	P-SYNTAX,P-SLOC1
	BTST	STACK,SMANY /?ELS3
	SET	'LOSS,1
	JUMP	?CND1
?ELS3:	GET	P-PRSI,P-MATCHLEN
	GRTR?	STACK,1 \?CND1
	GETB	P-SYNTAX,P-SLOC2
	BTST	STACK,SMANY /?CND1
	SET	'LOSS,2
?CND1:	ZERO?	LOSS /TRUE
	PRINTI	"[You can't use multiple "
	EQUAL?	LOSS,2 \?CND18
	PRINTI	"in"
?CND18:	PRINTI	"direct objects with """
	GET	P-ITBL,P-VERBN >TMP
	ZERO?	TMP \?ELS27
	PRINTI	"tell"
	JUMP	?CND25
?ELS27:	ZERO?	P-OFLAG \?THN32
	ZERO?	P-MERGED /?ELS31
?THN32:	GET	TMP,0
	PRINTB	STACK
	JUMP	?CND25
?ELS31:	GETB	TMP,2 >?TMP1
	GETB	TMP,3
	CALL	WORD-PRINT,?TMP1,STACK
?CND25:	PRINTI	""".]"
	CRLF	
	RFALSE	


	.FUNCT	THIS-IT?,OBJ,SYNS,CNT
	GETPT	OBJ,P?SYNONYM >SYNS
	ZERO?	SYNS /FALSE
	ZERO?	P-NAM /?CND4
	PTSIZE	SYNS
	DIV	STACK,2
	INTBL?	P-NAM,SYNS,STACK \FALSE
?CND4:	ZERO?	P-ADJ /?CND9
	GETPT	OBJ,P?ADJECTIVE >SYNS
	ZERO?	SYNS /FALSE
	PTSIZE	SYNS
	DIV	STACK,2
	INTBL?	P-ADJ,SYNS,STACK \FALSE
?CND9:	ZERO?	P-GWIMBIT /TRUE
	FSET?	OBJ,P-GWIMBIT /TRUE
	RFALSE	

	.ENDI