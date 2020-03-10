.macro printstr(%x)
.data
str:	.asciiz %x
.text
	li	 $v0, 4
	la	$a0,str
	syscall
.end_macro