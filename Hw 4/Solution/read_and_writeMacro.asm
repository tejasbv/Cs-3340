.data


.text
start:
	.macro open_read(%x, %Y)
	#open the file
	li 	$v0, 13
	la	$a0, %x
	li	$a0, 0
	li	$a2, 0
	syscall
	move	$s0, $v0
#################################################
	
	#read from file
	li	$v0, 14
	move	$a0,$s0
	la	$a1, %y
	li	$a2, 80
	syscall
#################################################
	.end_macro
