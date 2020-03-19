.include		"macroFile.asm"

.data
area:		.word
read:		.space	1024
filename:	.space	20
ofsize:		.word
cfsize:		.word	
compressed_data:.space	1024



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
	
	#close the file as it is already read into the variable
	close_file()
	
	print_str("original data:\n")
	#print the contents in read(original data)
	li	$v0, 4
	la	$a0, read
	syscall
	print_str("\n")
	
	#original file size
	la	$a0, read
	getsize()
	move	$a0, $v0
	print_int()
	
	la	$a0, read
	la	$a1, compressed_data
	
	
	j	main
exit:	li 	$v0, 10
	syscall
	
errorOpen:
	print_str("the file name is incorrect try again\n")
	j	main
	
