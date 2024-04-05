grammar L;
@ header {

import java.util.HashMap;
}
@ members {
HashMap memory = new HashMap();
}
prog 					:	stat+;
stat 					:	calculation {System.out.println($calculation.value);}
					
					;

calculation returns [float value]	:	e= expr {$value = $e.value;}
					|	PLUS (e= expr {$value = $e.value;})? (e= expr {$value += $e.value;})*
					|	MINUS	(e= expr {$value = $e.value;})? (e= expr {$value -= $e.value;})* 
					|	MULT	(e= expr {$value = $e.value;})? (e= expr {$value *= $e.value;})* 
					|	DIV	(e= expr {$value = $e.value;})? (e= expr {$value /= $e.value;})* 
					|	SQRT    (e= expr{$value = (float)Math.sqrt($e.value); })
					|	SIN     (e= expr {$value = (float)Math.sin($e.value);})
					|	COS     (e= expr{$value = (float)Math.cos($e.value); })
					|	TAN	(e= expr{$value = (float)Math.tan($e.value); })
					|   	WORD4     (e=expr {$value = $e.value;} )NEWLINE* 
            					{System.out.println($WORD4.text + ' ' +  $e.value);}
      					|   	WORD1 ID WORD2 a=calculation 
						{ memory.put($ID.text, new Double($a.value));}
           				        WORD3 NEWLINE*  b= calculation {$value = $b.value;} 
       					;
					
expr returns [float value]		:	FLOAT {$value = Float.parseFloat($FLOAT.text);}
					|	ID {
						 Float v = (Float)memory.get($ID.text);
     						 if ( v!=null ) $value = v.floatValue();
       						 else System.err.println("undefined variable "+$ID.text);}
					|	LPAREN calculation RPAREN {$value = $calculation.value;}
					;
SIN 					:   	'sin';
COS 					:  	 'cos';
TAN					:	'tan';
SQRT					: 	'sqrt' ;
LPAREN					: 	'(';
RPAREN					: 	')';
WORD1					:	'let';
WORD2 					:	'be';
WORD3				        :	'in';
ID 					:	('a'..'z'|'A'..'Z')+;
PLUS 					: 	'+' ;
MINUS					: 	'-';
MULT					:	'*' ;
DIV					:	'/' ;
QUOTATION				:	 '"';
ASSIGN					:       '=';
WORD4                			:       QUOTATION (ID|' '|','|'^'|FLOAT|PLUS|SIN|COS|ASSIGN|LPAREN|RPAREN)+ QUOTATION;
FLOAT 					:   	('0'..'9')+ '.' ('0'..'9')* EXPONENT?|'.' ('0'..'9')+ EXPONENT?|('0'..'9')+ EXPONENT|'0'..'9'+;
fragment 
EXPONENT 				: 	('e'|'E') ('+'|'-')? ('0'..'9')+ ;
NEWLINE 				:	'\r'?'\n';
WS 					:	(' '|'\t'|'\n'|'\r')+ {skip();};

