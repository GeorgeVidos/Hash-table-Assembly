#Dimitris Kakouris 3160043
#Giorgos Vidos 3160014


.text


	main:

		li $s0,10 #n=10
		li $s1,0  #keys=0

		
		li $s2,0 #pos=0
		li $t2,0 #choice=0
		li $t3,0 #telos=0
		
		li $t4,0#i=0
		li $t5,0#to i pou tha ginetai i+4

		Tableinitialization:
		bge $t4,$s0,exitTableinitialization # i>=N exit loop
		sw $zero,hash($t5) #hash[i]=0
		addi $t5,$t5,4 # add 4 to go to the next position
		addi $t4,$t4,1#i++
		j Tableinitialization #back to loop



	exitTableinitialization:

		
		li $v0,4
		la $a0,menu #print menu
		syscall
		
		
		li $v0,4
		la $a0,choice1 #print choice1
		syscall
		li $v0,4
		la $a0,choice2 #print choice2
		syscall
		
		li $v0,4
		la $a0,choice3 #print choice3
		syscall
		
		li $v0,4
		la $a0,choice4 #print choice4
		syscall
		

		li $v0,4
		la $a0,choice #print choice
		syscall
		
		
		li $v0,5  #user input
		syscall	 
		
		move $t2,$v0 # store userr input in $t2=choice
		

		
		beq $t2,1,Choi1
		beq $t2,2,Choi2
		beq $t2,3,Choi3
		beq $t2,4,Choi4
		bgt $t2,4,exitTableinitialization #if choice>4 then go back to menu
		
		
		Choi1:
			
			li $v0,4
			la $a0,text1 #print text1 "Give new key(greater than zero):"
			syscall
			
			li $v0,5 # user input
			syscall	 
		
			move $a1,$v0 #store outcome in $a1 $a1=key or k
			
			
		
			bgt $a1,$zero,insertkey
			li $v0,4
			la $a0,text2 #print text2 "key must be greater than zero"
			syscall
			
			j Choi1			#back to choi1 to write a new valid key
			
			
			
		Choi2:
		
			li $v0,4
			la $a0,text3 #print text3 " Give key to search for: "
			syscall
			
			li $v0,5 # user input
			syscall	 
			
			move $a1,$v0 #store result in $a1 $a1=key or k
			
			jal findkey
			
			move $s2,$v1#$s2=returned pos
			
			bne $s2,-1,notequal
			li $v0,4
			la $a0,text4 #print text4 "Key not in hash table."
			syscall
			j exitTableinitialization #once you ve searched the key return to menu
			
		notequal:
			li $v0,4
			la $a0,text5 #print text5 "Key value ="
			syscall
			
			sll $t0,$t0,2
			li $v0,1
			lw $s2,hash($t0)
			syscall
			
			li $v0,4
			la $a0,text6 #print text5 "Table position = "
			syscall
			
			li $v0,1
			move $a0,$s2 #print pos
			syscall
			
			j exitTableinitialization #once you ve searched the key return to menu

			
		Choi3:
			jal displaytable
			j exitTableinitialization # go to menu again
			
			
		Choi4:
			addi $t3,$t3,1

			
		beqz $t3,exitTableinitialization
		li $v0,10
		syscall
		
		
insertkey:
		
			li $t0,0 #position=0
			jal findkey
			move $t0,$v1
			
			bne $t0,-1,display# position aka $t0!=-1 go to display
			
			blt $s1,$s0,calculations #keys<N go to display2
			li $v0,4
			la $a0,text8 #print text8 "hash table is full"
			syscall
			j exitTableinitialization
			
		display:
			li $v0,4
			la $a0,text7 #print text7 "Key already in hash table."
			syscall
			j exitTableinitialization
			
		calculations:
			
			jal hashfunction
			
			move $t0,$a2 #put hushfunction result to $t0
			sw $a1,hash($t0)
			addi $s1,$s1,1#keys++
			j exitTableinitialization
			
			
		
			
hashfunction:
		li $t0,0#position
		rem $t0,$a1,$s0
		
		Whileloop:
		
			sll $t0,$t0,2
			lw $t6, hash($t0)
			beqz $t6,Whileloopend
			addi $t0,$t0,1
			rem $t0,$t0,$s0	
			j Whileloop
		
		Whileloopend:	
			move $a2,$t0
			jr $ra
	
	
displaytable:
			li $t0,0#i
			li $t1,0#i+4
			
			li $v0,4
			la $a0,text9
			syscall
		
		forloop:	
			bge $t0,$s0,exitforloop
			
			li $v0,4
			la $a0,spacebar#print space
			syscall
			
			
			li $v0,1
			move $a0,$t0#print counter i
			syscall
			
			li $v0,4
			la $a0,spacebar#print space
			syscall
			
			li $v0,1
			lw $a0,hash($t1)#print the table
			syscall

			
			addi $t1,$t1,4#move 4 places for next byte
			addi $t0,$t0,1#i++
			j forloop
		exitforloop:
			jr $ra
		
		
findkey:
		
			li $t0,0#posotiton
			li $t1,0#i counter
			li $t2,0#found
			rem $t0,$a1,$s0
			
		whileloop1:
			blt $t1,$s0,gosecond
			j exitwhile
		gosecond:
			beqz $t2,godo
			j exitwhile
		godo:	
			addi $t1,$t1,1
			
			sll $t3,$t0,2			
			lw $t4,hash($t3)
			beq $t4,$a1,godo1
			addi $t0,$t0,1
			rem $t0,$t0,$s0
			j whileloop1
			
		godo1:
			li $t2,1#found=1
			j whileloop1

		exitwhile:
			beq $t2,1,godo2
			addi $v1,$zero,-1
			jr $ra
		godo2:
			move $v1,$t0
			jr $ra	
		
		

.data
	hash: .space 40 #N=10 10*4 40 space
	menu: .asciiz " \n  Menu "
	choice1: .asciiz "\n 1.Insert Key"
	choice2: .asciiz "\n 2.Find Key "
	choice3: .asciiz "\n 3.Display Hash Table "
	choice4: .asciiz "\n 4.Exit "
	choice: .asciiz "\n Choice? \n "
	text1: .asciiz " \n Give new key(greater than zero): "
	text2: .asciiz "\n key must be greater than zero" 
	text3: .asciiz "\n Give key to search for: "
	text4: .asciiz "\n Key not in hash table."
	text5: .asciiz "\n Key value = "
	text6: .asciiz "\n Table position = " 
	text7: .asciiz "\n Key already in hash table."
	text8: .asciiz "\n hash table is full"
	text9: .asciiz "\n pos key \n"
	spacebar: .asciiz " "
	spacebarnewline: .asciiz "\n"
	
