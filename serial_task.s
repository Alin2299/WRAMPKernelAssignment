.global	counter
counter:
	.word	0x1403
.global	receivedChar
receivedChar:
	.word	0x31
.global	printChar
.text
printChar:
	subui	$sp, $sp, 2
	sw	$12, 0($sp)
	sw	$13, 1($sp)
L.6:
L.7:
	lhi	$13, 0x7
	ori	$13, $13, 0x1003
	lw	$13, 0($13)
	andi	$13, $13, 2
	seq	$13, $13, $0
	bnez	$13, L.6
	lhi	$13, 0x7
	ori	$13, $13, 0x1000
	lw	$12, 2($sp)
	sw	$12, 0($13)
L.5:
	lw	$12, 0($sp)
	lw	$13, 1($sp)
	addui	$sp, $sp, 2
	jr	$ra
.global	receiveChar
receiveChar:
	subui	$sp, $sp, 1
	sw	$13, 0($sp)
	lhi	$13, 0x7
	ori	$13, $13, 0x1003
	lw	$13, 0($13)
	andi	$13, $13, 1
	sne	$13, $13, $0
	bnez	$13, L.10
	lw	$1, receivedChar($0)
	j	L.9
L.10:
	lhi	$13, 0x7
	ori	$13, $13, 0x1001
	lw	$1, 0($13)
L.9:
	lw	$13, 0($sp)
	addui	$sp, $sp, 1
	jr	$ra
.global	main
main:
	subui	$sp, $sp, 11
	sw	$2, 1($sp)
	sw	$3, 2($sp)
	sw	$4, 3($sp)
	sw	$5, 4($sp)
	sw	$6, 5($sp)
	sw	$7, 6($sp)
	sw	$12, 7($sp)
	sw	$13, 8($sp)
	sw	$ra, 9($sp)
	j	L.14
L.13:
	lw	$7, counter($0)
	jal	receiveChar
	addu	$13, $0, $1
	sw	$13, receivedChar($0)
	addui	$13, $0, 13
	sw	$13, 0($sp)
	jal	printChar
	lw	$13, receivedChar($0)
	snei	$13, $13, 49
	bnez	$13, L.16
	addui	$13, $0, 10
	rem	$6, $7, $13
	div	$7, $7, $13
	addi	$6, $6, 48
	rem	$5, $7, $13
	div	$7, $7, $13
	addi	$5, $5, 48
	rem	$4, $7, $13
	div	$7, $7, $13
	addi	$4, $4, 48
	rem	$3, $7, $13
	div	$7, $7, $13
	addi	$3, $3, 48
	rem	$2, $7, $13
	div	$7, $7, $13
	addi	$2, $2, 48
	rem	$13, $7, $13
	sw	$13, 10($sp)
	lw	$13, 10($sp)
	addi	$13, $13, 48
	sw	$13, 10($sp)
	lw	$13, 10($sp)
	sw	$13, 0($sp)
	jal	printChar
	sw	$2, 0($sp)
	jal	printChar
	sw	$3, 0($sp)
	jal	printChar
	sw	$4, 0($sp)
	jal	printChar
	addui	$13, $0, 46
	sw	$13, 0($sp)
	jal	printChar
	sw	$5, 0($sp)
	jal	printChar
	sw	$6, 0($sp)
	jal	printChar
L.16:
	lw	$13, receivedChar($0)
	snei	$13, $13, 50
	bnez	$13, L.18
	divi	$13, $7, 100
	divi	$6, $13, 60
	divi	$13, $7, 100
	remi	$5, $13, 60
	addui	$13, $0, 10
	rem	$2, $6, $13
	div	$6, $6, $13
	addi	$2, $2, 48
	rem	$12, $6, $13
	sw	$12, 10($sp)
	lw	$12, 10($sp)
	addi	$12, $12, 48
	sw	$12, 10($sp)
	rem	$4, $5, $13
	div	$5, $5, $13
	addi	$4, $4, 48
	rem	$3, $5, $13
	addi	$3, $3, 48
	lw	$13, 10($sp)
	sw	$13, 0($sp)
	jal	printChar
	sw	$2, 0($sp)
	jal	printChar
	addui	$13, $0, 58
	sw	$13, 0($sp)
	jal	printChar
	sw	$3, 0($sp)
	jal	printChar
	sw	$4, 0($sp)
	jal	printChar
L.18:
	lw	$13, receivedChar($0)
	snei	$13, $13, 51
	bnez	$13, L.20
	addui	$13, $0, 10
	rem	$6, $7, $13
	div	$7, $7, $13
	addi	$6, $6, 48
	rem	$5, $7, $13
	div	$7, $7, $13
	addi	$5, $5, 48
	rem	$4, $7, $13
	div	$7, $7, $13
	addi	$4, $4, 48
	rem	$3, $7, $13
	div	$7, $7, $13
	addi	$3, $3, 48
	rem	$2, $7, $13
	div	$7, $7, $13
	addi	$2, $2, 48
	rem	$13, $7, $13
	sw	$13, 10($sp)
	lw	$13, 10($sp)
	addi	$13, $13, 48
	sw	$13, 10($sp)
	lw	$13, 10($sp)
	sw	$13, 0($sp)
	jal	printChar
	sw	$2, 0($sp)
	jal	printChar
	sw	$3, 0($sp)
	jal	printChar
	sw	$4, 0($sp)
	jal	printChar
	sw	$5, 0($sp)
	jal	printChar
	sw	$6, 0($sp)
	jal	printChar
L.20:
	lw	$13, receivedChar($0)
	snei	$13, $13, 113
	bnez	$13, L.22
	j	L.12
L.22:
	addui	$13, $0, 10
	sw	$13, 0($sp)
	jal	printChar
L.14:
	j	L.13
L.12:
	lw	$2, 1($sp)
	lw	$3, 2($sp)
	lw	$4, 3($sp)
	lw	$5, 4($sp)
	lw	$6, 5($sp)
	lw	$7, 6($sp)
	lw	$12, 7($sp)
	lw	$13, 8($sp)
	lw	$ra, 9($sp)
	addui	$sp, $sp, 11
	jr	$ra
