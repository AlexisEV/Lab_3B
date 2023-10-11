# potencia.asm

# SECCION DE INSTRUCCIONES (.text)
.text
.globl __start

__start:
la $a0, base
li $v0, 4
syscall
li $v0, 5
syscall
addi $t0, $v0, 0
la $a0, potencia
li $v0, 4
syscall
li $v0, 5
syscall
addi $t1, $v0, 0
addi $a0, $t0, 0
addi $a1, $t1, 0
jal pot
addi $t2, $v0, 0
la $a0, res
li $v0, 4
syscall
addi $a0, $t0, 0
li $v0, 1
syscall
la $a0, res2
li $v0, 4
syscall
addi $a0, $t1, 0
li $v0, 1
syscall
la $a0, res3
li $v0, 4
syscall
addi $a0, $t2, 0
li $v0, 1
syscall
j fin


pot:bltz $a0, error
    bltz $a1, error
    sw $fp,-4($sp)    #Guardando $t1 y $t2 en pila
    addi $fp,$sp,0 
    addi $sp,$sp,-12
    sw $t0,-8($fp)
    sw $t1,-12($fp)
    beqz $a1, caso0
    addi $t0, $a0, 0
    addi $t1, $a1, 0
        
    loop:addi $t1, $t1, -1 
         beqz $t1, done
         mul $t0, $t0, $a0
         j loop
    
    caso0:li $v0, 1
          j return
          
    done: addi $v0, $t0, 0
          bltz $v0, overflow
          j return

    return:lw $t1,-12($fp)
           lw $t0, -8($fp)
           addi $sp,$fp, 0
           lw $fp,-4($sp)
           jr $ra
           
error:la $a0, err
      li $v0, 4
      syscall
      j fin

overflow:la $a0, over
         li $v0, 4
         syscall
         j fin

fin:li $v0,10
    syscall



# SECCION DE VARIABLES EN MEMORIA (.data)
.data
base: .asciiz "Ingresar base:"
potencia: .asciiz "Ingresar potencia: "
res: .asciiz " El resultado de "
res2: .asciiz " elevado a "
res3: .asciiz " es: "
err: .asciiz "La base y la potencia deben ser positivos "
over: .asciiz "Overlow detectado, operacion finalizada"
coma:    .asciiz ", "
endl:    .asciiz "\n"
