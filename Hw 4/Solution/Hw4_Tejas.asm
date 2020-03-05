.include "read_and_writeMacro.asm"

.data
filename:	.asciiz	"input.txt"
read:		.asciiz	
array:		.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


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

	#extracting the integers function call
	la	$a0, array
	addi	$a1,$0,20
	la	$a2, read
	jal	extractnum
	
	
	

	
###################################################
	# exit program	
exit:	li	$v0,10
	syscall
###################################################	

extractnum:
	#lb	$t0,1($a2)
	li  	$t3,0
	li	$t6,48
	li	$t7,57
	li 	$t4,2
	addi	$sp,$sp, -4
	sw	$ra,($sp)
	lw	$s5,($a0)
	
loop:	beq	$t3,$a1,contMain
	add	$t1,$t3,$a2
	lb	$t0, ($t1)
	addi	$t3,$t3,1
	add	$t1,$t3,$a2
	lb	$t2,($t1)
	jal 	check
	sw	$v0,($s5)
	
increment:
	addi	$s5,$s5,4
	addi	$t3,$t3,1
	j	loop

contMain:	jr	$ra
	
check:	
	addi	$t5,$0,10
	blt	$t0,$t6,	increment
	bgt	$t0,$t7,increment
	blt	$t2,$t6,	return1
	bgt	$t2,$t7,return1
	subi	$t0, $t0,48
	mul	$t0,$t0,$t5
	subi	$t2, $t2,48
	add	$v0,$t2,$t0
	jr	$ra
	
return1:	
	subi	$t0, $t0,48
	add	$v0,$0,$t0
	jr	$ra
