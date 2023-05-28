.global main                    # Specifies that the main subroutine is globally accessible

main:                           # Main subroutine that setups the timer interrupts and the tasks
subui $sp, $sp, 1               # Backup $ra value onto the stack
sw $ra, 0($sp)

movsg $1, $evec                 # Copy the old handler's address into $1
sw $1, old_vector($0)           # Save the old handler's address into memory
la $1, handler                  # Store the (current) handler address into $1
movgs $evec, $1                 # Move the handler address into $evec



movsg $2, $cctrl                # Copy the current value of $cctrl into $2
andi $2, $2, 0x000F             # Disable all interrupts using andi
ori $2, $2, 0x42                # Enable IRQ2 (Timer Interrupt) and IE (Global Interrupts)
movgs $cctrl, $2                # Move the value of $2 into $cctrl

sw $0, 0x72003($0)              # Acknowledge any outstanding interrupts before setting up the Timer
addi $3, $0, 24                 # Set $3 to be 24
sw $3, 0x72001($0)              # Load $3 value into the Timer Load Register

addi $3, $0, 0x3                # Set $3 to be 3
sw $3, 0x72000($0)              # Enable auto-restart and enable the Timer using $3 and the Timer Control Register

jal serial_main                 # Jump-and-link to the serial task's main subroutine

lw $ra, 0($sp)                  # Get $ra value from the stack
addui $sp, $sp, 1
jr $ra                          # Jump to $ra so we can exit


handler:                    	# Subroutine that handles exceptions by determing the type and where to jump to
movsg $13, $estat               # Set $13 to be the value of $estat
andi $13, $13, 0xFFB0           # Check if interrupt should be handled by timer handler
beqz $13, handle_timer          # Branch to timer handler if it should be handled by it

                                # If the interrupt should be handled by the default handler:
lw $13, old_vector($0)          # Set $13 to be the old_vector value
jr $13                          # Jump to the default/old handler 


handle_timer:                   # Handler for the Timer
lw $13, counter($0)             # Set $13 to be the value of counter
addi $13, $13, 1                # Increment $13 by 1
sw $13, counter($0)             # Update counter with the new value

sw $0, 0x72003($0)              # Acknowledge interrupt by setting the interrupt acknowledge register to 0
rfe                             # Return from the exception back to the main program


.bss                            # Section that allows allocation of memory (without initialisation)
old_vector:                     # Defines a "variable" that stores the old exception (handler) vector
.word 

serialtask_pcb:                 # Defines a process control block for the serial task
.space 17

serialtask_stack:               # Defines a separate stack for the serial task
.space 200
