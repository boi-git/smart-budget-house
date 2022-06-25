.data 
welcomemsg:	.asciiz "\nWelcome to Smart Room "
offmsg : .asciiz "\n Type 0 exit "
optionmsg: .asciiz "\nEnter your option : "

doormsg:	.asciiz "\n1: Detecting door movement "
doortimer :.asciiz "s\n "
doordetail :.asciiz "\nDoor has been opened at  "
dooropen:.asciiz "\nDoor Open \n"
doorclose:.asciiz "\nDoor Close "
  
airmsg:.asciiz "\n2: Determin air quality "
airon:	.asciiz "\nTurning on air purifier "

voicemsg:.asciiz "\n3: Detecting commands "
voicemsginput:.asciiz "\nDetected  commands : "
voiceon :.asciiz "\nLamp On "
voiceoff:.asciiz "\nLamp off "


			.text
#1.	Print out a message string with a welcome message
#syscall print string

addi $t4, $zero, 0
	main:
		addi $t0, $zero, 9  
		
		while:

			beqz $t0,exit
			
			la	$a0,welcomemsg
			jal	PrintString
			la	$a0,doormsg
			jal	PrintString
			la	$a0,airmsg
			jal	PrintString
			la	$a0,voicemsg
			jal	PrintString
			la	$a0,offmsg
			jal	PrintString
			la	$a0,optionmsg
			jal	PrintString
			
			li $v0,5
			syscall
			move $t0,$v0
			
			beq $t0,1,door
			beq $t0,2,air
			beq $t0,3,lamp

			
			
			j while
			
		
		exit:
		
	li	$v0,10
	syscall

door:
	la	$a0,dooropen
	jal	PrintString
	addi $t4, $t4, 1	
	addi $t2,$zero,0
	while1:
		
		
		bgt $t2,9,exit1	
		addi $t2,$t2,1	
		li $v0,1
		move $a0,$t2
		syscall
		
		la	$a0,doortimer
		jal	PrintString
		
	
		j while1
		
	exit1:
	la	$a0,doordetail 
	jal	PrintString
	li $v0,1
	move $a0,$t4
	syscall
	
	
	
	la	$a0,doorclose
	jal	PrintString
	j main


air:
	la	$a0,airon
	jal	PrintString
	j main
	

lamp:

	la	$a0,voicemsginput
	jal	PrintString
	
	li $v0,5
	syscall
	
	move $t7,$v0
	
	beq $t7,1,on
	beq $t7,0,off
			

	on:
		la	$a0,voiceon
		jal	PrintString
		j main
	off:
		la	$a0,voiceoff
		jal	PrintString
		j main
	
		


PrintString:
	li	$v0,4
	syscall
	jr	$ra
	
