.globl main
.data
        inputStr: .asciiz "Enter a two digit integer [00-99]: "
        str2Int: .word 0
        binAns: .asciiz "The binary representation of your integer is:  "
        space: .space 10
        error: .asciiz "Oops... That's not an integer."
	
.text
main:
        la $a0, inputStr
        li $v0, 4
        syscall

        li $v0, 8
        la $a0, space
        li $a1, 8
        syscall			  # inputStr Ready
	
        lb $t1, 1($a0)       	  # first digit
        add $t1, $t1, -48     
        lb $t0, ($a0)            # second digit
        add $t0, $t0, -48     
        mul $t0, $t0, 10  
        add $t1, $t1, $t0   
        sw $t1, str2Int           # str2Int Ready
        
        lwc1 $f12, ($t1)
        
        add $t4, $zero, 00	  # Error handling
	      blt $t1, $t4, typeError
	      add $t4, $zero, 99
	      bgt $t1, $t4, typeError
        
        la $a0, binAns			
        li $v0, 4
        syscall
        
        add $t0, $zero, 7          # 8 bits 
        add $t2, $zero, 1         	 
	      sll $t2, $t2, 7 
	
loop:  
        blt $t0, $zero, Exit	    
        and $t3, $t1, $t2           # masking
        srav $t3, $t3, $t0
        add $a0, $t3, $zero         # prepare for printing 
        li $v0, 1  
        syscall                   
 	      sra $t2, $t2, 1		    # move to next bit
        addi $t0, $t0, -1    	    # decrement
              
        j loop 
         
typeError:
    	la $a0, error	
	    li $v0, 4
    	syscall 
	
Exit:
