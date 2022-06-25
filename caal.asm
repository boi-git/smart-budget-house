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

addi $t4, $zero, 0 #variable for door to store time when it's open #0 for close 1 for open
addi $t5, $zero, 0#variable for air codition #0 for bad air 1 for good air

	main:
		addi $t0, $zero, 9  
		
		while: # while loop and will exit if user enter 0

			beqz $t0,exit
			
			la	$a0,welcomemsg
			jal	PrintString #calling fucntion to print string
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
			
			li $v0,5 #retrive input from user
			syscall
			move $t0,$v0#move value from v0 to t0
			
			beq $t0,1,door # go to door fucntion
			beq $t0,2,air # go to air fucntion
			beq $t0,3,lamp # go to lamp fucntion
			#comparing input 
			
			
			j while #jump to while until user enter 0
			
		
		exit:
		
	li	$v0,10
	syscall

door:
	la	$a0,dooropen
	jal	PrintString
	
	addi $t4, $t4, 1	 #varibale for timer and stored it
	addi $t2,$zero,0  #varible for duration the door stay open
	
	while1:
		
		
		bgt $t2,9,exit1	#if duriation is more that 10s the door will close
		addi $t2,$t2,1	#incrmenet 
		
		li $v0,1			
		move $a0,$t2
		syscall
		la	$a0,doortimer
		jal	PrintString
		#print out integer as duriation+string as second "s"
	
		j while1
		
	exit1:
	la	$a0,doordetail 
	jal	PrintString
	li $v0,1
	move $a0,$t4
	syscall
	#print out door detail aka when the door is opened
	
	
	la	$a0,doorclose #after 10s the door wil l close
	jal	PrintString
	j main


air:
	beqz $t5,purifier
	beq $t5,1,nonpurifier
	#checking the state of air
	
	purifier:
		la	$a0,airon
		jal	PrintString
		li $t5,1	#load 1 as shows the air is good after air purifier is on
		j main
	
	nonpurifier:
		li $t5,0 #laod 0 as shows the air becoming bad when purifer is off
		j main
	

lamp:

	la	$a0,voicemsginput 
	jal	PrintString
	li $v0,5 
	syscall
	#input ccommand for user
	
	move $t7,$v0
	
	beq $t7,1,on
	beq $t7,0,off
	#if statement based on the command 

	on:
		la	$a0,voiceon
		jal	PrintString
		j main
	off:
		la	$a0,voiceoff
		jal	PrintString
		j main
	
		


PrintString: # function to pritn out string
	li	$v0,4
	syscall
	jr	$ra
	
