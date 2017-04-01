	.kdata					# kernel data
s1:		.word 10
s2:		.word 11
prompt: 	.asciiz "Input float: "		# Prompt for user to input a floating point number
buffer_title:	.asciiz "\nBuffer: "		# Prompt for printing the buffer
buffer_size:	.asciiz "\nBuffer size: "	# Prompt for buffer size
new_line: 	.asciiz "\n\n"			# Utility to print a new line
float_buffer:	.space 100			# Reserve 100 bytes for float input


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
	beq $a0, $t5, exit			# close the program when cliking enter
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

	# Print current size of buffer ($s1)
	# Print prompt for buffer size
	li $v0,4
	la $a0, buffer_size
	syscall

	# Print buffer size
	ori     $2, $0, 1
	or     	$a0, $0, $s1
	syscall
	# Print new line in the end
	jal print_new_line

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

exit:
    li      $v0, 10         # terminate program run and
    syscall                 # Exit


# Print buffer of user input
print_buffer:
	li $t4, 0		# Counter for the loop
	move $t0, $s2		# keep pointer to the first element of the buffer

	li $v0, 4		# Prepare to print string
	la $a0, buffer_title	# Print Title for buffer
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
