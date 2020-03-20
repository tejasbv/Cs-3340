.include		"macroFile.asm"

.data
area:		.word	0
read:		.space	1024
filename:	.space	20
uncompressed:	.space 1024	




.text
main:	
	
	allocate_mem(1024) #allocate memory
	sw	$v0, area  #store memory to varialbe
	
	
	print_str("please enter the filename to compress or <enter> to exit: ")
	#read the file name
	li 	$v0, 8
	la	$a0, filename
	li	$a1, 80
	syscall
	#remove \n from the file name
	la	$a0, filename
	remove_end_of_string()	
	
	lb	$t1, filename($0)
	beqz	$t1,exit
	print_str("\n")
	
	#n li	$v0, 4
	#la	$a0, filename
	#syscall
	
	#open the file
	open_file()
	
	
	
	#create error if file open error exists
	bltz	$s1, errorOpen
	
	#else print the file was opened succesfully 
	print_str("the file was succesfully opened\n\n")
	
	#if file opened sucessfully read file into the "read" variable
	read_file()
	move	$s2, $v0 #$s2 the original file size
	
	#close the file as it is already read into the variable
	close_file()
	
	print_str("original data:\n")
	#print the contents in read(original data)
	li	$v0, 4
	la	$a0, read
	syscall
	print_str("\n")
	
	#compresses the data
	la	$a0, read
	lw	$a1, area
	move	$a2, $s2
	jal	compress
	move $s3, $v0 #$s3 contains the compressed file size
	
	#prints the compressed data
	print_str("compressed data:\n")
	lw	$a1, area  	#the compressed data
	move	$a2, $s3	#size of the compressed data
	jal	printcompress
	print_str("\n")
	
	
	#uncompresses the data
	la	$a0, uncompressed	#location to store the uncompressed 
	lw	$a1, area		#compressed data
	move	$a2, $s3		#size of compressed
	jal	uncompress
	
	
	#prints the uncompressed data
	print_str("uncompressed data:\n")
	li	$v0, 4
	la	$a0, uncompressed
	syscall
	print_str("\n")
	print_str("\n")
	
	#original file size
	print_str("original file size: ")
	move $a0, $s2
	print_int()
	print_str("\n")
	
	#prints compressed file size
	print_str("compressed file size: ")
	move $a0, $s3
	print_int()
	print_str("\n")
	
	j	main
exit:	li 	$v0, 10
	syscall
	
errorOpen:
	print_str("the file name is incorrect try again\n")
	j	main
	
compress:
#	la	$a0, read (the file to compress)
#	la	$a1, area (the location to store the data)
#	move	$a2, $s2	(original file size)
	
	
	
	li	$t0, 0 #i=0
	
	
	li	$t7,0	#file size
loopcomp:	beq	$t0, $a2, returncompdata
		lbu	$t5, ($a0)	#loads the character to put in stream
		sb	$t5, ($a1)	#stores the char info in the heap
		addi	$a1,$a1,1	#set heap to number of instances
		addi	$t7,$t7,1	#increase the file size by 1
		li	$t3,1		#number of characters of the same type
second:		addi	$a0,$a0,1	#get next char
		addi	$t0,$t0,1	#i++
		lbu	$t6, ($a0)	
		beq	$t6,$t5,increment
		sb	$t3,($a1)
		addi	$a1,$a1,1	#set heap to char again
		addi	$t7,$t7,1	#increase the file size by 1
		j	loopcomp
		
increment:	addi	$t3,$t3,1
		j	second
		
returncompdata:
		move	$v0,$t7
		jr	$ra
		
		
		
printcompress:
#		lw	$a1, area (compressed data)
#		move	$a2, $s3 (file size)
		li	$t1,0 #i=0
loopprint:	beq	$t1,$a2,returnprint
		lb	$t0, ($a1)	#loads the character to put in stream
		la	$a0, ($t0)
		print_char()
		addi	$a1,$a1,1	#increase to load number of instances
		lbu	$a0, ($a1)	#loads the int to put in stream
		print_int()
		addi	$t1,$t1,2
		addi	$a1,$a1,1	#change back to char
		j	loopprint
returnprint:	jr	$ra



uncompress:
#		la	$a0, uncompressed	#location to store the uncompressed 
#		lw	$a1, area (compressed data)
#		move	$a2, $s3  (file size of compressed data)
		li	$t1,0 #i=0
loopuncomp:	beq	$t1,$a2,returnuncomp
		li	$t2,0	#j=0
		lbu	$t5, ($a1)	#loads the character to put in stream
		addi	$a1,$a1,1	#increase to load number of instances
		lbu	$t6, ($a1)	#loads the number of times to repeat char
		looprep:	sb	$t5,($a0)
				addi	$a0,$a0,1
				addi	$t2,$t2,1
				blt	$t2,$t6,looprep
		
		addi	$a1,$a1,1
		addi	$t1,$t1,2
		j	loopuncomp
		
returnuncomp:	jr	$ra