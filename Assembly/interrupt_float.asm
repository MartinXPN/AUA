##################################################
#####                                       ######
#####       Read Float with interrupt       ######
#####       © 2017 All Rights Reserved.     ######
#####                                       ######
##################################################
#####                                       ######
#####    $s1 = current size of the buffer   ######
#####    $s2 = &buffer[0]                   ######
#####    $s3 = &buffer[size-1]              ######
#####    $f1 = resulting float              ######
#####    $f7 = 0.0                          ######
#####                                       ######
##################################################


	.kdata					# kernel data
s1:		.word 10
s2:		.word 11
prompt: 	.asciiz "Input float: "		# Prompt for user to input a floating point number
bad_float:	.asciiz "\nInvalid float!\n"
result_float:	.asciiz "\nResult float: "
new_line: 	.asciiz "\n"
float_buffer:	.space 100			# Reserve 100 bytes for float input
zero:		.float 0.0
point_one:	.float 0.1
ten:		.float 10.0

	.text
	.globl main
main:				# Enable interrupts in main and jump to infinite loop of here:
	mfc0 $a0, $12		# read from the status register
	ori $a0, 0xff11		# enable all interrupts
	mtc0 $a0, $12		# write back to the status register

	lui $t0, 0xFFFF		# $t0 = 0xFFFF0000;
	ori $a0, $0, 2		# enable keyboard interrupt
	sw $a0, 0($t0)		# write back to 0xFFFF0000;

	li $s1, 0    		# $s1 is the counter of the buffer (how many characters we've read already)
				# set $s1 to 0

	la $s2, float_buffer	# Pointer to the first element of the buffer
	la $s3, float_buffer	# $s3 is the current element where the modifications need to be done
	lwc1 $f7, zero		# Store 0 in register $f7 as there is no default register with value 0 for floats like for integers...

	li $v0,4		# print a string
	la $a0, prompt 		# Prompt user to enter a float
	syscall


here: 			# Infinite loop
	j here		# stay here forever
	li $v0, 10	# exit,if it ever comes here
	syscall



.ktext 0x80000180		# kernel code starts here

	.set noat		# tell the assembler not to use $at, not needed here actually, just to illustrae the use of the .set noat
	move $k1, $at		# save $at. User prorams are not supposed to touch $k0 and $k1 
	.set at			# tell the assembler okay to use $at
	
	sw $v0, s1		# We need to use these registers
	sw $a0, s2		# not using the stack because the interrupt might be triggered by a memory reference 
				# using a bad value of the stack pointer

	mfc0 $k0, $13		# Cause register
	srl $a0, $k0, 2		# Extract ExcCode Field
	andi $a0, $a0, 0x1f

    bne $a0, $zero, kdone	# Exception Code 0 is I/O. Only processing I/O here

	lui $v0, 0xFFFF		# $t0 = 0xFFFF0000;
	lw $a0, 4($v0)		# get the input key
	li $v0,11		# print it here. (11 for character, 1 for int-code)
	syscall


	# Size Manipulation
	li $t4, 8				# $t4 = backspace code 	(8)
	li $t5, 10				# $t5 = enter code 	(10)
	beq $a0, $t5, check_float		# close the program when cliking enter
	beq $a0, $t4, decrement_counter		# if( backspace )	decrement()
						# else			increment()

	# BUFFER SIZE MANIPULATION
	increment_counter:	
		sb	$a0, 0($s3)		# Store the value of input into #s3
		addi $s1, 1			# Increment the counter $s1
		addi $s3, 1			# Move to the next cell
		j continuation			# Jump to continuation, don't decrement the counter
	decrement_counter:
		bgtz $s1, decrement_number	# Decrement only when $s1 > 0
		j continuation			# Otherwise jump to continuation
		decrement_number:
			addi $s1, -1		# Decrement the counter ($s1) by 1
			addi $s3, -1		# Move to the previous cell
	continuation:
		jal print_buffer		# Print current buffer



kdone:
	mtc0 $0, $13		# Clear Cause register
	mfc0 $k0, $12		# Set Status register
	andi $k0, 0xfffd	# clear EXL bit
	ori  $k0, 0x11		# Interrupts enabled
	mtc0 $k0, $12		# write back to status

	lw $v0, s1		# Restore other registers
	lw $a0, s2

	.set noat		# tell the assembler not to use $at
	move $at, $k1		# Restore $at
	.set at			# tell the assembler okay to use $at

	eret			# return to EPC


# Check if the float is valid or not
check_float:
	li $t3, 46		# $t3 = '.'
	li $t4, -1		# Counter for the loop
	move $t0, $s2		# keep pointer to the first element of the buffer
	addi $t0, -1
	li $t2, 0		# Number of dots found so far

	lp:
		addi 	$t0, 1			# Move to the next cell
		addi 	$t4, 1			# Add 1 to index ($t4)
		beq 	$s1, $t4, parse_float	# Break if $t4 reached the size of the buffer
		lb    	$a0, 0($t0)     	# load byte into $a0
		beq	$a0, $t3, found_dot	# continue the loop if current digit is '.'
		addi	$t1, $a0, -48		# Check char < '0'
		bltz	$t1, bad_string
		addi	$t1, $a0, -57		# Check char > '9'
		bgtz	$t1, bad_string
		j lp				# continue the loop
		found_dot:
			bgtz $t2, bad_string	# If this dot is not the first one then the string is invalid
			addi $t2, 1		# Add one to counter
			j lp
	bad_string:
		li $v0, 4
		la $a0, bad_float
		syscall
		j exit

# Parse string in the buffer to float in $f1
parse_float:
	lwc1 $f2, point_one	# $f2 = 0.1
	lwc1 $f3, ten		# $f3 = 10.0
	lwc1 $f4, point_one	# $f4 = 0.1 (exponent which will decrease by 0.1 in each step)
	lwc1 $f1, zero		# $f1 = res = 0.0
	li $t3, 46		# $t3 = '.'

	li $t4, 0		# Counter for the loop
	move $t0, $s2		# keep pointer to the first element of the buffer

	
	parse_decimal_loop:
		beq 	$s1, $t4, print_result		# Break if $t4 reached the size of the buffer
		lb    	$t1, 0($t0)     		# load byte into $t1
		beq	$t1, $t3, parse_floating_loop	# parse digits after floating point
		addi	$t1, -48			# Get value of the character
		
		mtc1 	$t1, $f12		# move to c1 value stored in t1
 		cvt.s.w $f6, $f12		# Convert to float and keep in $f6

		mul.s 	$f1, $f1, $f3		# res *= 10
		add.s 	$f1, $f1, $f6 		# res += buffer[$t4]
		addi 	$t0, 1			# Move to the next cell
		addi 	$t4, 1			# Add 1 to index ($t4)
		j parse_decimal_loop
	

	parse_floating_loop:
		addi 	$t0, 1			# Move to the next cell
		addi 	$t4, 1			# Add 1 to index ($t4)
		beq 	$s1, $t4, print_result	# Break if $t4 reached the size of the buffer
		lb    	$t1, 0($t0)     	# load byte into $t1
		addi	$t1, -48		# Get value of the character

		mtc1 	$t1, $f12		# move to c1 value stored in t1
 		cvt.s.w $f6, $f12		# Convert to float and keep in $f6

 		mul.s 	$f6, $f6, $f4		# s[i] * exp
 		mul.s 	$f4, $f4, $f2 		# exp *= 0.1	($f4 *= 0.1)
 		add.s 	$f1, $f1, $f6		# res += $f6
		j parse_floating_loop



	# Print resulting float
	print_result:
		li $v0, 4		# Display string
		la $a0, result_float	# Display promot of what we are printing
		syscall

		li $v0, 2 		# Display a float
		mov.s $f12, $f1		# store $f1 in f12
		syscall

		# Terminate the program
		j exit



exit:
    li      $v0, 10         # terminate program run and
    syscall                 # Exit


# Print buffer of user input
print_buffer:
	li $t4, 0		# Counter for the loop
	move $t0, $s2		# keep pointer to the first element of the buffer

	li $v0, 4		# Prepare to print string
	la $a0, new_line	# Print Title for buffer
	syscall			# Trigger a system call

	li $v0, 4		# Prepare to print string
	la $a0, prompt		# Print Title for buffer
	syscall			# Trigger a system call


	loop:
		beq 	$s1, $t4, end	# Break if $t4 reached the size of the buffer
		lb    	$a0, 0($t0)     # load byte into $a0
		li    	$v0, 11         # print the character
		syscall                 # issue a system call
		addi 	$t0, 1		# Move to the next cell
		addi 	$t4, 1		# Add 1 to index ($t4)
		j loop
	end:
		jr $ra 			# return


print_new_line:
	li $v0, 4
	la $a0, new_line
	syscall
	jr $ra
