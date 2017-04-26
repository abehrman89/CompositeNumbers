TITLE Programming Assignment #4    (Behrman_Project4.asm)

; calculate user-requested number of composite numbers

INCLUDE Irvine32.inc

.data

myName			BYTE	"Name: Alexandra Behrman", 0
myProgram		BYTE	"Title: Programming Assignment #4", 0
goodbye			BYTE	"Thanks for playing! Goodbye.", 0
prompt1			BYTE	"How many composites you would like to see?", 0
prompt2			BYTE	"Enter a number in [1..400]: ", 0
low_err			BYTE	"That number is too low. Try again.", 0
high_err		BYTE	"That number is too high. Try again.", 0
spaces			BYTE	"   ", 0
lineCount		DWORD	0	;tracking number of terms on each line
ten				DWORD	10	;for determining when a new line is needed
testNum			DWORD	4	;number being checked for composite
temp			DWORD	?	;holds testNum during composite checking
compositeCheck	DWORD	2	;used for checking if number is composite
count			DWORD	?	;total number of composites user wants to enter
displayCount	DWORD	0	;number of composites displayed so far


LOWERLIMIT = 1
UPPERLIMIT = 400

.code
main PROC

	call	introduction
	call	getUserData
	call	showComposite
	call	farewell

	exit	; exit to operating system
main ENDP


introduction PROC
	mov		edx, OFFSET myName
	call	WriteString
	call	CrLf
	mov		edx, OFFSET myProgram
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction ENDP


getUserData PROC
	mov		edx, OFFSET prompt1
	call	WriteString
	call	CrLf
	call	validation
	ret
getUserData ENDP


validation PROC
	Top:
		mov		edx, OFFSET prompt2
		call	WriteString
		call	ReadInt

		cmp		eax, LOWERLIMIT
		jl		TooLow
		cmp		eax, UPPERLIMIT
		jg		TooHigh

		mov		count, eax
		ret

	TooLow:									;user entered number < 1
		call	CrLf
		mov		edx, OFFSET low_err
		call	WriteString
		call	CrLf
		jmp		Top

	TooHigh:								;user entered number > 400
		call	CrLf
		mov		edx, OFFSET high_err
		call	WriteString
		call	CrLf
		jmp		Top
validation ENDP


showComposite PROC
	mov		ecx, count						;set loop counter and move to loop in isComposite
	call	CrLf
	call	isComposite
	ret
showComposite ENDP


isComposite PROC
	L1:
	
	top:
		mov		eax, testNum
		mov		temp, eax				
		mov		edx, 0
		mov		ebx, compositeCheck
		div		ebx
		cmp		edx, 0
		je		DisplayComposite			;if remainder = 0, number is a composite, so jump to display

		inc		compositeCheck
		mov		eax, temp
		mov		testNum, eax
		cmp		eax, compositeCheck			;if new compositeCheck (divisor) is lower than testNum, jump back to top
		ja		top

		inc		testNum						;number was not composite so move to next number
		mov		compositeCheck, 2			;to be tested and rest compositeCheck (divisor) to 2
		jmp		top

	NextNum:
		mov		testNum, eax				;set up next number to be tested and loop back to beginning
		inc		testNum
		mov		compositeCheck, 2
		loop	L1	

	DisplayComposite:
		cmp		lineCount, 10				;determine if there are already 10 numbers on the line
		jne		WriteComposite				;if not, display next number
		call	CrLf						;if already 10 numbers, move to next line, reset lineCount, then display next number
		mov		lineCount, 0

	WriteComposite:
		mov		eax, temp
		call	WriteDec
		inc		displayCount				;new composite displayed, so increment displayCount and lineCount
		inc		lineCount
		mov		edx, OFFSET spaces
		call	WriteString

		mov		ebx, count				
		cmp		ebx, displayCount			;compare displayCount to total number of compsites user wanted displayed
		jne		NextNum						;if numbers aren't equal, jump to test next number in loop
isComposite ENDP


farewell PROC
	call	CrLf
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	call	CrLf
	exit
farewell ENDP

END main
