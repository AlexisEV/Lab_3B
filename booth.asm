# booth.asm

# SECCION DE INSTRUCCIONES (.text)
.text
.globl __start

__start:
la $a0, multiplicando
li $v0, 4
syscall
li $v0, 5
syscall
addi $t0, $v0, 0
la $a0, multiplicador
li $v0, 4
syscall
li $v0, 5
syscall
addi $t1, $v0, 0
addi $a0, $t0, 0
addi $a1, $t1, 0
jal booth
addi $t2, $v0, 0 #Guardando la primera parte del resultado en $t2
addi $t3, $v1, 0 #Guardando la segunda parte del resultado en $t3

#Revisar valor resultado en $t2-$t3 al finalizar el programa

li $v0,10
syscall


booth:sw $fp,-4($sp)    #Guardando $t1 y $t2 en pila
      addi $fp,$sp,0 
      addi $sp,$sp,-12
      sw $t0,-8($fp)
      sw $t1,-12($fp)
      li $t1, 1            #valor de 000..1 que se usara para comparar
      li $t2, -1           #valor de 111..1 que se usara para comparar
      addi $s0, $a0, 0     #M
      addi $s1, $a1, 0     #Q
      li $s2, 0            #s2 es Q-1 (q)
      li $s3, 0            #s3 es A
      li $s4, 32           #contador
      
      loop:
           andi $t3, $s1, 1   # verificar LSB de Q
           sra  $t4, $s2, 31  # verificar MSB de Q-1
           beq $t3, $t1, check_q_cero  # Si $t3 es 1, verifiquemos $t4
           beq $t3, $zero, check_q_uno # Si $t3 es 0, verifiquemos $t4

      check_q_cero:
           beq $t4, $zero, resta   # Si $t3 es 1 y $t4 es 0, saltar a resta
           j shiftAQ

      check_q_uno:
           beq $t4, $t2, suma       # Si $t3 es 0 y $t4 es -1, saltar a suma
           j shiftAQ          
      suma:
          add $s3, $s3, $s0         #A+M
          j shiftAQ

      resta:
          sub $s3, $s3, $s0         #A-M
          j shiftAQ
          
      shiftAQ:
          andi $t5, $s3, 1                #LSB de Q en t3, LSB de A en t5
          sra $s3, $s3, 1                 #desplazamiento aritmetico de A
          
          sra $s1, $s1, 1                 #desplazamiento aritmetico de Q
          
          beq $t5, $zero, colocar_MSB_Q_cero #si el LSB de A es 0
          ori $s1, $s1, 0x80000000        #configurar MSB de Q a 1
          j shiftQq
          
      
      colocar_MSB_Q_cero:
          andi $s1, $s1, 0x7FFFFFFF        #configurar MSB de Q a 0
           
      shiftQq:                            
          beq $t3, $zero, colocar_MSB_q_cero #si LSB de Q es 0, Q-1 sera 0
          ori $s2, $s2, 0x80000000           #si LSB de Q es 0, Q-1 sera 1
          j restar_contador
      
      colocar_MSB_q_cero:
         andi $s2, $s2, 0x7FFFFFFF           #configurar MSB de Q-1 a 0
      
      restar_contador:
         addi $s4, $s4, -1
         beq $s4, $zero, done
         j loop
      
      done:
         addi $v0, $s3, 0
         addi $v1, $s1, 0
         lw $t1,-12($fp)
         lw $t0, -8($fp)
         addi $sp,$fp, 0
         lw $fp,-4($sp)
         jr $ra
      
      
      

# SECCION DE VARIABLES EN MEMORIA (.data)
.data
multiplicando: .asciiz "Ingresar multiplicando:"
multiplicador: .asciiz "Ingresar multiplicador: "
res: .asciiz " El resultado de "
res2: .asciiz " multiplicado por "
res3: .asciiz " es: "
coma:    .asciiz ", "
endl:    .asciiz "\n"