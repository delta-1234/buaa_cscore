.macro exit
li $v0,10
syscall
.end_macro

.macro scanInt(%d)
li $v0,5
syscall
move %d,$v0
.end_macro

.macro scanChar(%c)
li $v0,12
syscall
move %c,$v0
.end_macro

.macro printInt(%d)
move $a0,%d
li $v0,1
syscall
.end_macro

.macro printSpace
la $a0,space
li $v0,4
syscall
.end_macro

.macro printEnter
la $a0,enter
li $v0,4
syscall
.end_macro

.macro cal(%s,%i,%j,%n)
mult %i,%n
mflo %s
add %s,%s,%j
sll %s,%s,2
.end_macro

.data
mx1: .space 576#mx1[12][12]
mx2: .space 576#mx2[12][12]
space: .asciiz " "
enter: .asciiz "\n"

.text
scanInt($s0)#m1
scanInt($s1)#n1
scanInt($s2)#m2
scanInt($s3)#n2
#输入矩阵mx1
li $t0,0#i
li $t1,0#j
loop_1_begin:
	beq $t0,$s0,loop_1_end
	li $t1,0
	loop_2_begin:
		beq $t1,$s1,loop_2_end
		scanInt($t2)
		cal($t3,$t0,$t1,$s1)
		sw $t2,mx1($t3)
		addi $t1,$t1,1
		j loop_2_begin
	loop_2_end:
	addi $t0,$t0,1
	j loop_1_begin
loop_1_end:

#输入矩阵mx2
li $t0,0#i
li $t1,0#j
loop_3_begin:
	beq $t0,$s2,loop_3_end
	li $t1,0
	loop_4_begin:
		beq $t1,$s3,loop_4_end
		scanInt($t2)
		cal($t3,$t0,$t1,$s3)
		sw $t2,mx2($t3)
		addi $t1,$t1,1
		j loop_4_begin
	loop_4_end:
	addi $t0,$t0,1
	j loop_3_begin
loop_3_end:

#进行卷积运算并输出
li $t0,0
li $t1,0
li $t2,0#k
li $t3,0#l
li $s4,0#sum
sub $s5,$s0,$s2
addi $s5,$s5,1#m1-m2+1
sub $s6,$s1,$s3
addi $s6,$s6,1#n1-n2+1
loop1_begin:
	beq $t0,$s5,loop1_end
	li $t1,0#j=0
	loop2_begin:
		beq $t1,$s6,loop2_end
		li $s4,0#sum=0
		li $t2,0#k=0
		loop3_begin:
			beq $t2,$s2,loop3_end
			li $t3,0#l=0
			loop4_begin:
				beq $t3,$s3,loop4_end
				add $t4,$t0,$t2
				add $t5,$t1,$t3
				cal($t6,$t4,$t5,$s1)
				lw $t4,mx1($t6)#mx1[i+k][j+l]
				cal($t6,$t2,$t3,$s3)
				lw $t5,mx2($t6)#mx2[k][l]
				mult $t4,$t5
				mflo $t6
				add $s4,$s4,$t6#sum+=mx1[i+k][j+l]*mx2[k][l]
				addi $t3,$t3,1
				j loop4_begin
			loop4_end:
			addi $t2,$t2,1
			j loop3_begin
		loop3_end:
		printInt($s4)
		printSpace
		addi $t1,$t1,1
		j loop2_begin
	loop2_end:
	printEnter
	addi $t0,$t0,1
	j loop1_begin
loop1_end:
exit



