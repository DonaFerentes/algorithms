#       Insertion Sort
#       Input:  A sequence of n numbers (a_1, a_2,...,a_n)
#	Output: A permutation of the input sequence a_1' <= a_2'....<=a_n'
#       "Introduction to Algorithms." Cormen, et al. 3 edition
#	p. 18	
	
	
	.data
A:	.word	5, 2, 4, 6, 1, 3
bar1:	.asciiz "|-----------------------\n"
bar2:	.asciiz "------------------------|\n"
nwln:	.asciiz "\n"
	
	.text
	.globl main
main:

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	
	addu $s7, $0, $ra
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	addi    $s1, $0, 1                 #j = 1
	addi    $s2, $0, 6		   #n = 6
	addi 	$t8, $0, -1		   #bound -1
	la	$s4, A

	#********************************************
	la	$a0, A
	add	$a1, $0, $s2
	jal     print_array
	#********************************************
	
Loop:	
	slt     $t0, $s1, $s2
	beq	$t0, $0 , exit

#	li	$v0, 1			#print_int
#	add	$a0, $0, $s1
#	syscall

	sll	$s3, $s1, 2		#$s3:= j*4
	add	$s3, $s3, $s4           #$s3:= j*4 + base address of array
	lw	$t5, 0($s3)		#$t5:= A[j] -> key

	addi	$s5, $s1, -1		#i = j - 1

while:
	slt	$t3, $t8, $s5            # -1 < i    #short-circuit evaluation
	beq	$t3, $0, exit_while      #  
	
	sll	$s6, $s5, 2		#$s6:= i*4
	add	$s6, $s6, $s4           #$s3:= i*4 + base address of array
	lw	$t4, 0($s6)		#$t4:= A[i] 	
	
	slt 	$t2, $t5, $t4            # key < A[i]
	and	$t3, $t3, $t2
	beq	$t3, $0, exit_while

	addi	$t3, $s5, 1	        #$t3:= i + 1
	
	sll	$t1, $t3, 2		#$t1:= (i+1)*4
	add	$t1, $t1, $s4           #$s3:= (i+1)*4 + base address of array
	sw	$t4, 0($t1)		#$t4:= A[i+1] 
	addi	$s5, $s5, -1		#i = i - 1
	j	while
	
exit_while:	

	addi	$s5, $s5, 1		#$s5 = i + 1

	sll	$t1, $s5, 2		#$t1:= (i+1)*4
	add	$t1, $t1, $s4           #$s3:= (i+1)*4 + base address of array
	sw	$t5, 0($t1)		#$t5:= A[i+1] 
	
	addi	$s1, $s1 , 1
	j	Loop
exit:

	#********************************************
	la	$a0, A
	add	$a1, $0, $s2
	jal     print_array
	#********************************************

	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	addu	$ra, $0, $s7		#usual stuff at main's end
	jr	$ra
	add	$0,  $0, $0		#nop
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	
#......................................................
print_array:
#arguments
#$a0 = base array
#$a1 = size

	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	move	$s0, $a0         #base address
	move	$s1, $a1	 #size of array

	addi	$s2, $0, 0	 #initialize i=0
		
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#	print header
	li	$v0, 4
	la	$a0, bar1
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	
	slt	$s3, $s2, $s1	 #$s3 dummy variable
	beq	$s3, $0, exit_loop
loop:
	sll	$s4, $s2, 2	 #i*4
	add	$s4, $s4, $s0    #offset + base
	
	lw	$s3, 0($s4)
	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#	PRINT ROUTINE
	li	$v0, 1
	add	$a0, $0, $s3
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	addi	$s2, $s2, 1	#i = i + 1
	slt	$s3, $s2, $s1
	bne	$s3, $0, loop
exit_loop:
	
	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#       print coda
	li	$v0, 4
	la	$a0, bar2
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)

	addi	$sp, $sp, 20

	jr	$ra
#.....................................................
