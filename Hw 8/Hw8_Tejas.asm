# Instructions: 
#   Connect bitmap display:
#         set pixel dim to 8x8
#         set display dim to 256x256
#	use $gp as base address
#   Connect keyboard and run
#	use w (up), s (down), a (left), d (right), space (exit)
#	all other keys are ignored
.eqv WIDTH 64 #width of the screen
.eqv HEIGHT 64 #height of the screen
# colors
.eqv	RED 	0x00FF0000
.eqv	GREEN	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW	0x00FFFF00
.eqv	CYAN	0x0000FFFF
.eqv	MAGENTA	0x00FF00FF

.data 
colors:	.word	RED,GREEN,BLUE,WHITE,YELLOW,CYAN,MAGENTA

.text
main: 
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	addi	$a0,$a0,-7
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	addi	$a1,$a1,-7
	sra 	$a1, $a1, 1
	#lw	$t7,colors
loop:	#main loop that contains all other loops
	
	addi	$t1,$0,6
	
	loop1: 	ble	$t1,0,loop2
		sll	$t5,$t1,2
		lw 	$a2, colors($t5) #color loop
		jal	drawPixel
		move	$t6,$a0
		li	$v0,32
		syscall #dealy timer
		addi	$a0,$0,5
		move	$a0,$t6
		addi	$a0,$a0,1
		addi	$t1,$t1,-1
		j	loop1
		
	loop2:	bge	$t1,6,loop3
		sll	$t5,$t1,2
		lw 	$a2, colors($t5)#color loop
		jal	drawPixel
		move	$t6,$a0
		li	$v0,32
		syscall#dealy timer
		addi	$a0,$0,5
		move	$a0,$t6
		addi	$a1,$a1,1
		addi	$t1,$t1,1
		j	loop2
	loop3:	ble	$t1,0,loop4	#loop3
		sll	$t5,$t1,2
		lw 	$a2, colors($t5)#color loop
		jal	drawPixel
		move	$t6,$a0
		li	$v0,32
		syscall#dealy timer
		addi	$a0,$0,5
		move	$a0,$t6
		addi	$a0,$a0,-1
		addi	$t1,$t1,-1
		j	loop3
		
	loop4:	bge	$t1,6,ret
		sll	$t5,$t1,2
		lw 	$a2, colors($t5)#color loop
		jal	drawPixel
		move	$t6,$a0
		li	$v0,32
		syscall#dealy timer
		addi	$a0,$0,5
		move	$a0,$t6
		addi	$a1,$a1,-1
		addi	$t1,$t1,1
		j	loop4
	
ret:	# check for input
	lw $t0, 0xffff0000  #t1 holds if input available
    	beq $t0, 0, loop   #If no input, keep displaying
	
	# process input
	lw 	$s1, 0xffff0004
	beq	$s1, 32, exit	# input space
	beq	$s1, 119, up 	# input w
	beq	$s1, 115, down 	# input s
	beq	$s1, 97, left  	# input a
	beq	$s1, 100, right	# input d
	# invalid input, ignore
	j	loop
	
	# process valid input
	
up:	li	$a2, 0		# black out the pixel
	jal	blackloop
	addi	$a1, $a1, -1
	addi 	$a2, $0, RED
	j	loop
down:
	li	$a2, 0		# black out the pixel
	jal	blackloop
	addi	$a1, $a1, 1
	addi 	$a2, $0, RED
	j	loop
left:
	li	$a2, 0		# black out the pixel
	jal	blackloop
	addi	$a0, $a0, -1
	addi 	$a2, $0, RED
	j	loop
right:
	li	$a2, 0		# black out the pixel
	jal	blackloop
	addi	$a0, $a0, 1
	addi 	$a2, $0, RED
	j	loop


	
exit:	li	$v0,10
	syscall 	


# $a0=x, $a1=y$a2 = color
drawPixel:
	# s1 = address = $gp + 4*(x + y*width)
	mul	$t9, $a1, WIDTH   # y * WIDTH
	add	$t9, $t9, $a0	  # add X
	mul	$t9, $t9, 4	  # multiply by 4 to get word offset
	add	$t9, $t9, $gp	  # add to base address
	sw	$a2, ($t9)	  # store color at memory location
	jr 	$ra


blackloop:	#black loop that contains all other loops same as main loop but with black color
	addi	$sp,$sp,-4
	sw	$ra,($sp)
	addi	$t1,$0,6
	
	bloop1: 	ble	$t1,0,bloop2
		addi 	$a2, $0, 0 
		jal	drawPixel
		addi	$a0,$a0,1
		addi	$t1,$t1,-1
		j	bloop1
		
	bloop2:	bge	$t1,6,bloop3
		addi 	$a2, $0, 0 
		jal	drawPixel
		addi	$a1,$a1,1
		addi	$t1,$t1,1
		j	bloop2
	bloop3:	ble	$t1,0,bloop4	#loop3
		addi 	$a2, $0, 0  
		jal	drawPixel
		addi	$a0,$a0,-1
		addi	$t1,$t1,-1
		j	bloop3
		
	bloop4:	bge	$t1,6,bret
		addi 	$a2, $0, 0  
		jal	drawPixel
		addi	$a1,$a1,-1
		addi	$t1,$t1,1
		j	bloop4
	
bret:	lw	$ra,($sp)
	addi	$sp,$sp,4
	jr	$ra
		
	
