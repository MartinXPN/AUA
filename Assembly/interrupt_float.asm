	.kdata					# kernel data
s1:				.word 10
s2:				.word 11
prompt: 		.asciiz "Input float: "		# Prompt for user to input a floating point number
buffer_size:	.asciiz "\nBuffer size: "	# Prompt for buffer size
new_line: 		.asciiz "\n\n"				# Utility to print a new line
float_buffer:	.space 1000					# Reserve 1000 bytes for float input


	.text
	.globl main
main:						# Enable interrupts in main and jump to infinite loop of here:
	mfc0 $a0, $12			# read from the status register
	ori $a0, 0xff11			# enable all interrupts
	mtc0 $a0, $12			# write back to the status register

	lui $t0, 0xFFFF			# $t0 = 0xFFFF0000;
	ori $a0, $0, 2			# enable keyboard interrupt
	sw $a0, 0($t0)			# write back to 0xFFFF0000;

	li $s1, 0    			# $s1 is the counter of the buffer (how many characters we've read already)
							# set $s1 to 0

	li $v0,4				# print a string
	la $a0, prompt 			# Prompt user to enter a float
	syscall


here: 						# Infinite loop
	j here					# stay here forever
	li $v0, 10				# exit,if it ever comes here
	syscall



.ktext 0x80000180			# kernel code starts here

	.set noat				# tell the assembler not to use $at, not needed here actually, just to illustrae the use of the .set noat
	move $k1, $at			# save $at. User prorams are not supposed to touch $k0 and $k1 
	.set at					# tell the assembler okay to use $at
	
	sw $v0, s1				# We need to use these registers
	sw $a0, s2				# not using the stack because the interrupt might be triggered by a memory reference 
							# using a bad value of the stack pointer

	mfc0 $k0, $13			# Cause register
	srl $a0, $k0, 2			# Extract ExcCode Field
	andi $a0, $a0, 0x1f

    bne $a0, $zero, kdone	# Exception Code 0 is I/O. Only processing I/O here

	lui $v0, 0xFFFF			# $t0 = 0xFFFF0000;
	lw $a0, 4($v0)			# get the input key
	li $v0,11				# print it here. (11 for character, 1 for int-code)
	syscall


	# Size Manipulation
	li $t4, 8							# $t4 = backspace code  	backspace = 8
	li $t5, 10							# $t5 = enter code 			enter = 10
	beq $a0, $t5, exit					# close the program when cliking enter
	beq $a0, $t4, decrement_counter		# if( backspace )	decrement()
										# else				increment()

	# BUFFER SIZE MANIPULATION
	increment_counter:	
		addi $s1, 1
		j continuation
	decrement_counter:
		bgtz $s1, decrement_number
		j continuation
		decrement_number:
			addiu $s1, -1
	continuation:

	# Print current size of buffer ($s1)
	# Print prompt for buffer size
	li $v0,4
	la $a0, buffer_size
	syscall

	# Print buffer size
	ori     $2, $0, 1
	or     	$a0, $0, $s1
	syscall

	# Print new line after all
	li $v0,4
	la $a0, new_line
	syscall

kdone:
	mtc0 $0, $13			# Clear Cause register
	mfc0 $k0, $12			# Set Status register
	andi $k0, 0xfffd		# clear EXL bit
	ori  $k0, 0x11			# Interrupts enabled
	mtc0 $k0, $12			# write back to status

	lw $v0, s1				# Restore other registers
	lw $a0, s2

	.set noat				# tell the assembler not to use $at
	move $at, $k1			# Restore $at
	.set at					# tell the assembler okay to use $at

	eret					# return to EPC

exit:
    li      $v0, 10         # terminate program run and
    syscall                 # Exit 