
#marco instructions to print an int
.macro print_int()
.data
	#set $a0 to the integer to print
.text
	
	li	$v0, 1
	
	syscall
.end_macro

#################################################
#macro instruction to print a char
.macro print_char()
.data
	#set $a0 to the integer to print
.text
	li	$v0, 11
	
	syscall
.end_macro


#################################################
#macro instruction to print a string
.macro print_str(%x)
.data
	str:	.asciiz	%x
.text
	li	$v0, 4
	la	$a0, str
	syscall
.end_macro

#################################################

#macro instruction to print a string
.macro print_str_reg()
.data
#	str:	.asciiz	%x
#set $a0 to contents to print
.text
	li	$v0, 4
#	la	$a0, str
	syscall
.end_macro

#################################################

#macro instruction to open file
.macro	open_file()

.data


.text
		li	$v0,	13 
		la	$a0, filename
		li	$a1,	0
		li	$a2,	0
		syscall
		move 	$s1,	$v0 
		
.end_macro

#################################################

#macro 	instruction to close file

.macro	read_file()

.data
end:	.asciiz	"\0"
.text
#		la	$t0,end
		lbu	$t1,end
		li	$v0,	14
		move	$a0,	$s1
		la	$a1,	read
		li	$a2,	1024
		syscall
		sb	$t1,read($v0)
			
.end_macro

#################################################

#macro 	instruction to close file

.macro	close_file()

.data

.text
		li	$v0,	16
		move	$a0,	$s1
		
		syscall
.end_macro

#################################################

#macro for allocating memory

.macro	allocate_mem(%num)
.data
	space:	.word	%num
.text	
	li	$v0, 9
	lw	$a0, space
	syscall
.end_macro


#################################################

#macro for allocating memory

.macro	remove_end_of_string()
.data
	
.text	
		 li $s0,0        # Set index to 0
		
remove:
    		lb $a3,filename($s0)    # Load character at index
   		addi $s0,$s0,1      # Increment index
    		bnez $a3,remove     # Loop until the end of string is reached
   		subiu $s0,$s0,2     # If above not true, Backtrack index to '\n'
   		sb $0, filename($s0)    # Add the terminating character in its place
.end_macro


.macro	getsize()

.text
		li	$v0, 0
		la	$t1, ($a0)
loopsize:	lb	$t2, ($t1)
		beqz	$t2, returnsize
		addi	$v0,$v0,1
		addi	$t1,$t1,1
		j	loopsize
returnsize:	#ends progrm
.end_macro

.macro	reset()
.text
	li	$t1,0
	move	$t2, $s2
loop:	sb	$0,uncompressed($t1)
	addi	$t1,$t1,1
	bne	$t1,$t2,loop

.end_macro
