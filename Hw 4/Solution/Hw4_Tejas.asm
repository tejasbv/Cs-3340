.include "read_and_writeMacro.asm"

.data
filename:	.asciiz	"input.txt"
read:		.asciiz		


.text
main: 
	 	#open the file
	li 	$v0, 13
	la	$a0, filename
	li	$a1, 0
	li	$a2, 0
	syscall
	move	$s0, $v0
#################################################
	
	#read from file
	li	$v0, 14
	move	$a0,$s0
	la	$a1, read
	li	$a2, 80
	syscall
##################################################

	#exit if $v0 is less that or equal to zero
	ble	$v0, $0, exit
	
##################################################
	
	la	$a0, read
	addi	$a0,$a0,20
	
	
	li	$v0,4
	la	$a0, read
	syscall
	
exit:	li	$v0,10
	syscall
	
	
