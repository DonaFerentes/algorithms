#frame pointer
	
	.data
A:	.word	9,7,5,4,8,1,11,8,9
nwln:	.asciiz "\n"
tab:	.asciiz "\t"
msg:	.asciiz "Value of $sp (entering merge):	"
msge:	.asciiz "Value of $sp (leaving merge) :	"
msga:	.asciiz "Value of $sp (actualized)    :	"
msg1:	.asciiz "Something went wrong!"
msg2:	.asciiz "$sp and $t5 are equal. OK!"
m1:	.asciiz "First call to mergesort p ($a1) q \n"
m2:	.asciiz "Second call to mergesort q+1  r ($a2)\n"
bar1:	.asciiz "|-------------------------------------\n"
bar2:	.asciiz "-------------------------------------|\n"
mp:	.asciiz "Value of p  -   r   :	"
r0:	.asciiz "R[0]:	"
l0:	.asciiz "L[0]:	"
L:	.asciiz "L["
R:	.asciiz "R["
sch:	.asciiz "]: "

	.text
	.globl	main
	
main:

#********************************************
	la	$a0, A
	addi	$a1, $0, 9
	jal print_array
#********************************************


#*******************************************
#
#	la	$a0, A		#base address
#	addi	$a1, $0, 0	#p
#	addi	$a2, $0, 4	#q
#	addi	$a3, $0, 9
#	jal     merge
#*******************************************
	
#*******************************************
	la	$a0, A		#base address
	addi	$a1, $0, 0
	addi	$a2, $0, 8
	jal	mergesort
#*******************************************


	
#*******************************************
	la	$a0, A
	addi	$a1, $0, 9
	jal     print_array
#*******************************************
	

	li	$v0, 10
	syscall




#============================================
#		SUBPROGRAMS
#============================================

#....................................................
mergesort:
#arguments
#$a0 = base address
#$a1 = p
#$a2 = r

	addi	$sp, $sp, -16
	sw	$a1, 0($sp)
	sw	$a2, 4($sp)
	sw	$ra, 8($sp)
	sw	$s4, 12($sp)
	

	slt	$s3, $a1, $a2		#$t0 dummy variable
	beq	$s3, $0, exit_ms

	add	$s4, $a1, $a2		#p+r 
	srl	$s4, $s4, 1		#$s4 = q

	move	$a2, $s4		#$a2 = q

#	$a0 = base address
#	$a1 = p
#	$a2 = q

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	move	$s3, $a0
	li	$v0, 4
	la	$a0, m1
	syscall

	li	$v0, 1
	add	$a0, $0, $a1
	syscall

	li	$v0, 4
	la	$a0, tab
	syscall

	li	$v0, 1
	add	$a0, $0, $a2
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall

	move	$a0, $s3
	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	
	jal	mergesort

	
	addi	$s7, $s4, 1		#q+1
	move	$a1, $s7
	
#	$a0 = base address
#	$a1 = q+1
#	$a2 = ?
	

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	move	$s3, $a0
	
	li	$v0, 4
	la	$a0, m2
	syscall

	li	$v0, 1
	add	$a0, $0, $a1
	syscall

	li	$v0, 4
	la	$a0, tab
	syscall

	li	$v0, 1
	add	$a0, $0, $a2
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall

	move	$a0, $s3
	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	jal	mergesort

	move	$a3, $a2
	move	$a2, $s4

#	$a0  = base address
#	$a1  = ?
#	$a2  = q
#	$a3  = ?

	jal	merge

exit_ms:
	lw	$ra, 8($sp)
	lw	$s4, 12($sp)
	
	addi	$sp, $sp, 16
	
	lw	$a1, 0($sp)
	lw	$a2, 4($sp)

	jr	$ra	

#.....................................................
	
	

	
#.....................................................
merge:	
#arguments
#$a0 base of array
#$a1 p
#$a2 q
#$a3 r

		
	#save parameters
	move	$fp, $sp	#set  $fp
	move	$t0, $a0	#save $a0
	move	$t1, $a1	#save $a1
	move	$t2, $a2	#save $a2
	move	$t3, $a3	#save $a3

	sub	$t4, $t2, $t1	#n1  size of L                   |
	addi	$t4, $t4, 1     #array begins at 0               | L
				#                                |
	sub	$t5, $t3, $t2	#n2  size of R                   | R
	
	add	$t6, $t4, $t5	#add the sizes   n1 + n2
	addi	$t6, $t6, 2	#add place for the sentinels
	
	sll	$t7, $t6, 2	#size of the stack =  size*4

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	li	$v0, 4
	la	$a0, msg
	syscall
	
	li	$v0, 1
	add	$a0, $0, $sp
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	

	sub	$sp, $sp, $t7	#create frame
	
	#For the manipultion of the array
	

#	li	$v0, 4
#	la	$a0, mp
#	syscall
	
#	li	$v0, 1
#	add	$a0, $0, $t1
#	syscall

#	li	$v0, 4
#	la	$a0, nwln
#	syscall
	
	sll	$t9, $t1, 2	#offset p*4
	la	$t0, A
	add	$t9, $t9, $t0   #$t9 = cursor     base+offset (p)

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	li	$v0, 4
	la	$a0, msga
	syscall
	
	
	li	$v0, 1
	add	$a0, $0, $sp
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	

	move	$s1, $fp	  #cursor
	addi	$s1, $s1, -4	  #position 0 of the stack
	addi	$s2, $0, 0	  #initialize i = 0
	
	slt	$s0, $s2, $t4	  #$s0  dummy variable
	beq	$s0, $0, end_forL
forL:	lw	$s0, 0($t9)	  #read L[i]	
	sw	$s0, 0($s1)       #write stack
	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#	 print L in stack
	li	$v0, 1
	add	$a0, $0, $s0	#value in stack
	syscall

	li	$v0, 4
	la	$a0, tab
	syscall

	li	$v0, 1
	add	$a0, $0, $s1	#address in stack
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	addi	$t9, $t9,  4	#actualize cursor $t9 in array
	addi	$s1, $s1, -4	#actualize cursor $s1 in stack
	addi	$s2, $s2, 1	#actualize i = i+1
	slt	$s0, $s2, $t4
	bne	$s0, $0, forL
end_forL:

	
	addi	$s0, $0, 1000   #$s0 = dummy variable
	sw	$s0, 0($s1)	#store sentinel in stack

	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#             print sentinel of L
	li	$v0, 1
	add	$a0, $0, $s0	#value in stack
	syscall

	li	$v0, 4
	la	$a0, tab
	syscall

	li	$v0, 1
	add	$a0, $0, $s1	#address in stack
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	addi	$s1, $s1, -4	#actualize cursor $s1
	
	#$t9 holds the direction of the first element
	#in the subarray of A which should correspond to the
	#first element in the subarray R.
	#$s1 holds the direction of the first free cell
	#on the stack.

	addi	$s2, $0, 0	#initialize j = 0

	slt	$s0, $s2, $t5	  #$s0  dummy variable
	beq	$s0, $0, end_forR
forR:	
	lw	$s0, 0($t9)
	sw	$s0, 0($s1)

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#	print R in stack
	li	$v0, 1
	add	$a0, $0, $s0	#Value in stack
	syscall

	li	$v0, 4
	la	$a0, tab
	syscall

	li	$v0, 1
	add	$a0, $0, $s1	#Address in stack
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	
	addi	$t9, $t9,  4	#actualize cursor $t9 in array
	addi	$s1, $s1, -4	#actualize cursor $s1 in stack
	addi	$s2, $s2, 1	#actualize j = j + 1
	slt	$s0, $s2, $t5
	bne	$s0, $0, forR
end_forR:

	addi	$s0, $0, 1000
	sw	$s0, 0($s1)	#store sentinel
	

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#		print sentinel of R
	
	li	$v0, 1
	add	$a0, $0, $s0	#value in stack
	syscall

	li	$v0, 4
	la	$a0, tab
	syscall

	li	$v0, 1
	add	$a0, $0, $s1	#address in stack
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	

	bne	$s1, $sp, error
	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#          OK!
	li	$v0, 4
	la	$a0, msg2
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	j	exit

error:
	
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#         print error msg
	li	$v0, 4
	la	$a0, msg1
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

exit:

	move	$s1, $fp
	addi	$s1, $s1, -4	#cursor $s1 points to the base of the stack
		

	lw	$t2, 0($s1)
	
	li	$v0, 4
	la	$a0, l0
	syscall

	li	$v0,1
	add	$a0, $0, $t2
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
	
	
	
	addi	$t4, $t4, 1
	sll	$t4, $t4, 2
	sub	$s2, $s1, $t4

	lw	$t2, 0($s2)
	
	li	$v0, 4
	la	$a0, r0
	syscall

	li	$v0,1
	add	$a0, $0, $t2
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall


	addi	$t3, $t3, 1	#$t3 = r+1
	
	#$t1 = p
	
	la	$t0, A
	sll	$t1, $t1, 2
	add	$t1, $t1, $t0

	sll	$t3, $t3, 2
	add	$t3, $t3, $t0
	
	
	slt	$s0, $t1, $t3
	beq	$s0, $0, exit_k_loop

k_loop:
	
	lw	$t6, 0($s1)	#$t6 = L[i]
	lw	$t7, 0($s2)     #$t7 = R[j]

	li	$v0, 4
	la	$a0, L
	syscall

	li	$v0, 1
	add	$a0, $0, $s1
	syscall

	li	$v0, 4
	la	$a0, sch
	syscall

	li	$v0, 1
	add	$a0, $0, $t6
	syscall


	li	$v0, 4
	la	$a0, tab
	syscall

	li	$v0, 4
	la	$a0, R
	syscall

	li	$v0, 1
	add	$a0, $0, $s2
	syscall

	li	$v0, 4
	la	$a0, sch
	syscall
	
	li	$v0, 1
	add	$a0, $0, $t7
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall

	sgt	$s0, $t7, $t6
	bne	$s0, $0, then
	
	sw	$t7, 0($t1)     #A[k] <-- R[j]
	addi	$s2, $s2, -4	#j = j +1
	j	exit_if
	
then:
	sw	$t6, 0($t1)	#A[k] <--L[i]
	addi	$s1, $s1, -4	#i = i +1

exit_if:	

	addi	$t1, $t1, 4	#k+1
	slt	$s0, $t1, $t3
	bne	$s0, $0, k_loop
	
exit_k_loop:	
	
	move	$sp, $fp	#restore original $sp

	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	li	$v0, 4
	la	$a0, msge
	syscall
	
	li	$v0, 1
	add	$a0, $0, $sp
	syscall

	li	$v0, 4
	la	$a0, nwln
	syscall
	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	
	
	jr	$ra
#........................................................


	
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
	
	
		
	
	


