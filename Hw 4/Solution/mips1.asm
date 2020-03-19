.include "helper.asm"
.data
	read:			.space	80
	array:			.space	80
	filename:		.asciiz	"input.txt"
	space: 		.asciiz	" "
	meanval:		.float	0.0

.text
	la	$a0,	filename
	la	$a1,	read
	jal	readtxt
	ble	$v0,	$zero,	exit

	la	$a0,	array
	li	$a1,	20
	la	$a2,	($s0)
	jal	extractnum
	
	printstr("array unsorted:\n")
	la	$a0,array
	li	$a1,20
	la	$a2, space
	jal	print
	
	la	$a0, array
	li	$a1, 20
	jal sort
	
	printstr("\narray sorted:\n")
	la	$a0,array
	li	$a1,20
	la	$a2, space
	jal	print
	
	la	$a0, array
	li	$a1, 20
	jal 	mean
	swc1	$f2,meanval
	
	printstr("\nthe mean is: ")
	li	$v0,2
	lwc1	$f12,meanval
	syscall
	
	la	$a0, array
	li	$a1, 20
	jal 	median
	
	
	printstr("\nthe median is: ")
	jal	printMedian
	
	la	$a0,	array
	li	$a1,	20
	lwc1	$f1,	meanval
	jal	Deviation	
	
	
	printstr("\nthe standard of deviation is: ")
	li	$v0,	2
	mtc1	$zero,	$f2
	add.s	$f12,	$f1,	$f2
	syscall

exit:
		li	$v0,	10
		syscall
		
		#read to buffer
	#	la	$a0,	filename
	#	la	$a1,	read
readtxt:		move	$s0,	$a1 
		li	$v0,	13 
		li	$a1,	0
		li	$a2,	0
		syscall
		move 	$s1,	$v0 
	
		
		li	$v0,	14
		move	$a0,	$s1
		la	$a1,	($s0)
		li	$a2,	80
		syscall
	
		jr	$ra
	
extractnum: 	#extract numbers to array
		la	$s0,	($a0) 
		la	$s1,	($a2) 
		
		li	$t5,	0 
		li	$t2,	0 
		li	$t6,	0 
		li	$t7,	10
loop1:
		beq	$t6,	$a1,	numexit
			
loop2:
		lb	$t2,	($s1)
		beq	$t2,	10,	arrayPlus1
		blt	$t2,	48,	next
		bgt	$t2,	57,	next
		subi	$t2,	$t2,	48 
		
		mul	$t5,$t5,$t7 	
		add	$t5,	$t5,	$t2 
		
next:
		addi	$s1,	$s1,	1 
		j	loop2
			
arrayPlus1:
		sw	$t5,	($s0)
		addi	$s0,	$s0,	4
		addi	$s1,	$s1,	1
		addi	$t6,	$t6,	1
		li	$t5,	0
		j	loop1
			
numexit:
		jr	$ra
		
		
print:	
		li	$t0,0 
		move	$t1,$a0 
		la	$t2,($t1)
		
loop3:		bge	$t0,$a1,printExit
		lw	$t3,($t2)
		
		li	$v0,1
		move	$a0,$t3
		syscall
		
		li	$v0,	4
		la	$a0,	($a2)
		syscall
		
		addi	$t2,$t2,4
		addi	$t0,$t0,1
		j loop3
		
printExit:	jr	$ra

sort:	
		addi	$s0,$a1,-1
		li	$t0,	0 
		forLoop1:
			beq	$t0,	$s0,	exitsrt
			move	$t1,	$t0
			move	$t2,	$t0
		forLoop2:
			add	$t2,	$t2,	1
			bne	$t2,	$a1, compare
			j	swap
		
		compare:
			li	$t3,	4
			mul	$t4,	$t3,	$t2
			add	$t4,	$t4,	$a0
			mul	$t5,	$t3,	$t1
			add	$t5,	$t5,	$a0
			lw	$t6,	($t4)
			lw	$t7,	($t5)
			bge	$t6	$t7,	forLoop2
			move	$t1,	$t2
			j forLoop2
		
		swap:
			li	$t3,	4
			mul	$t4,	$t3,	$t0
			add	$t4,	$t4,	$a0
			lw	$t6,	($t4)
			
			mul	$t5,	$t3,	$t1
			add	$t5,	$t5,	$a0
			lw	$t7,	($t5)
			sw	$t6,	($t5)
			sw	$t7,	($t4)
			add	$t0,	$t0,	1
			j	forLoop1
		
		exitsrt:
			jr	$ra

		
mean:	
		la	$t0, ($a0)
		li	$t1,0	# i
		li	$t2,0	# sum
		li	$v0,0	# return val
loopadd:	bge	$t1,$a1,retmean
		lw	$t3,($t0)
		add	$t2, $t2, $t3
		addi	$t0, $t0, 4
		addi	$t1, $t1, 1
		j	loopadd
		
retmean:	mtc1	$t2,$f0
		cvt.s.w	$f0,$f0
		
		mtc1	$a1,$f1
		cvt.s.w	$f1,$f1
		
		div.s	$f2,$f0,$f1
		jr	$ra

median:		
		la	$s0,	($a0) 
		li	$t1,	1 
		
		sll	$a1,	$a1,	2
		
		li	$t0,2
		div	$a1,$t0
		mfhi	$t1
		beqz	$t1,even
		srl	$t2,	$a1,	2 
		add	$s0,	$s0,	$t2
		lw	$v0,	($s0)
		li	$v1,	0
		j	exitMedian
exitMedian:
		jr	$ra
		
even:
		li	$t1,	2 
		srl	$t2,	$a1,	1 
		subi	$t2,	$t2,	4
		add	$s0,	$s0,	$t2
		
		lwc1	$f1,	($s0)
		cvt.s.w	$f1,	$f1
		
		lwc1	$f2,	4($s0)
		cvt.s.w	$f2,	$f2
		
		mtc1	$t1,	$f3
		cvt.s.w	$f3,	$f3
		
		add.s	$f0,	$f1,	$f2
		div.s	$f0,	$f0,	$f3
		li	$v1,	1
		j	exitMedian


printMedian:
		beq	$v1,	1,	printOutMedianFloat
printOutMedianInteger:
		li	$v0,	4
		la	$a0,	($v0)
		syscall
		jr	$ra
printOutMedianFloat:
		li	$v0,	2
		mtc1	$zero,	$f1
		add.s	$f12,	$f0,	$f1
		syscall
		jr	$ra
		
		
		
Deviation:
		la	$s0,	($a0) 
		
		mtc1	$zero,	$f1 
		cvt.s.w	$f1,	$f1
		
		li	$t0,	0 
loopStandardOfDeviation:
		beq	$t0,	$a1,	calculateRadicand
		
		lwc1	$f3,	($s0) 
		cvt.s.w	$f3,	$f3
		
		sub.s	$f3,	$f3,	$f2
		mul.s	$f3,	$f3,	$f3
		add.s	$f1,	$f1,	$f3
		
		addi	$s0,	$s0,	4
		addi	$t0,	$t0,	1
		j	loopStandardOfDeviation
	
calculateRadicand:
		move	$t1,	$a1 
		subi	$t1,	$t1,	1
			
		mtc1	$t1,	$f5 
		cvt.s.w	$f5,	$f5
		
		div.s	$f1,	$f1,	$f5
		sqrt.s	$f1,	$f1
		jr	$ra
