.global main                    # Specifies that the main subroutine is globally accessible

main:                           # Main subroutine that setups the timer interrupts and the tasks

                                # Defines constants for the PCB registers
.equ pcb_link, 0
.equ pcb_reg1, 1
.equ pcb_reg2, 2
.equ pcb_reg3, 3
.equ pcb_reg4, 4
.equ pcb_reg5, 5
.equ pcb_reg6, 6
.equ pcb_reg7, 7
.equ pcb_reg8, 8
.equ pcb_reg9, 9
.equ pcb_reg10, 10
.equ pcb_reg11, 11
.equ pcb_reg12, 12
.equ pcb_reg13, 13
.equ pcb_sp, 14
.equ pcb_ra, 15
.equ pcb_ear, 16
.equ pcb_cctrl, 17
.equ pcb_timeslice, 18

subui $sp, $sp, 1               # Backup $ra value onto the stack
sw $ra, 0($sp)

subui $sp, $sp, 4               # Allocate 4 spaces on the stack
sw $1, 0($sp)                   # Backup $1, $2, $3, and $5 values onto the stack
sw $2, 1($sp) 
sw $3, 2($sp)      
sw $5, 3($sp)            

movsg $1, $evec                 # Copy the old handler's address into $1
sw $1, old_vector($0)           # Save the old handler's address into memory
la $1, handler                  # Store the (current) handler address into $1
movgs $evec, $1                 # Move the handler address into $evec


addi $5, $0, 0x4d               # Enables IRQ2, KU, OKU and OIE, but disables IE

la $1, serialtask_pcb           # Setup PCB for serial task

la $2, paralleltask_pcb         # Setup the link field (with the next task)
sw $2, pcb_link($1)

la $2, serialtask_stack         # Setup the stack pointer
sw $2, pcb_sp($1)

la $2, serial_main              # Setup the $ear field
sw $2, pcb_ear($1)

sw $5, pcb_cctrl($1)            # Setup the $cctrl field

la $1, serialtask_pcb           # Set serial task as the current task
sw $1, current_task($0)


la $1, paralleltask_pcb         # Setup PCB for parallel task

la $2, gametask_pcb             # Setup the link field (with the next task)
sw $2, pcb_link($1)

la $2, paralleltask_stack       # Setup the stack pointer
sw $2, pcb_sp($1)

la $2, parallel_main            # Setup the $ear field
sw $2, pcb_ear($1)

sw $5, pcb_cctrl($1)            # Setup the $cctrl field


la $1, gametask_pcb             # Setup PCB for the game task

la $2, serialtask_pcb           # Setup the link field (with the next task)
sw $2, pcb_link($1)

la $2, gametask_stack           # Setup the stack pointer
sw $2, pcb_sp($1)

la $2, gameSelect_main          # Setup the $ear field
sw $2, pcb_ear($1)

sw $5, pcb_cctrl($1)            # Setup the $cctrl field

movsg $2, $cctrl                # Copy the current value of $cctrl into $2
andi $2, $2, 0x000F             # Disable all interrupts using andi
ori $2, $2, 0x42                # Enable IRQ2 (Timer Interrupt) and IE (Global Interrupts)
movgs $cctrl, $2                # Move the value of $2 into $cctrl

sw $0, 0x72003($0)              # Acknowledge any outstanding interrupts before setting up the Timer
addi $3, $0, 24                 # Set $3 to be 24
sw $3, 0x72001($0)              # Load $3 value into the Timer Load Register

addi $3, $0, 0x3                # Set $3 to be 3
sw $3, 0x72000($0)              # Enable auto-restart and enable the Timer using $3 and the Timer Control Register

jal load_context                # Jump-and-link to the dispatcher context loader section
 
lw $1, 0($sp)                   # Restores register values $1, $2, $3 and $5 from the stack
lw $2, 1($sp)
lw $3, 2($sp)
lw $5, 3($sp)
lw $ra, 4($sp)                  # Get $ra value from the stack
addui $sp, $sp, 5               # Deallocate 5 spaces on the stack
jr $ra                          # Jump to $ra so we can exit


handler:                    	# Subroutine that handles exceptions by determing the type and where to jump to
movsg $13, $estat               # Set $13 to be the value of $estat
andi $13, $13, 0xFFB0           # Check if interrupt should be handled by timer handler
beqz $13, handle_timer          # Branch to timer handler if it should be handled by it

                                # If the interrupt should be handled by the default handler:
lw $13, old_vector($0)          # Set $13 to be the old_vector value
jr $13                          # Jump to the default/old handler 


handle_timer:                   # Handler for the Timer

sw $0, 0x72003($0)              # Acknowledge interrupt by setting the interrupt acknowledge register to 0

subui $sp, $sp, 1               # Backup the value for $1 onto the stack before we use it
sw $1, 0($sp)

lw $13, counter($0)             # Set $13 to be the value of counter
addi $13, $13, 1                # Increment $13 by 1
sw $13, counter($0)             # Update counter with the new value

lw $13, current_task($0)        # Get the PCB of the current task
lw $1, pcb_timeslice($13)       # Get the current timeslice value into $1
subi $1, $1, 1                  # Subtract 1 from the current timeslice value
sw $1, pcb_timeslice($13)       # Update timeslice with new value
beqz $1, dispatcher             # If timeslice expired, branch to dispatcher

lw $1, 0($sp)                   # Restore $1 value before returning
addui $sp, $sp, 1               

rfe                             # Return from the exception back to the main program


dispatcher:                     # Subroutine that saves current task context, schedules the next task,
                                # restores the task's context and returns to that task (using rfe)    

save_context:                   # Saves the context of the task
lw $13, current_task($0)        # Get base address of current PCB

sw $1, pcb_reg1($13)            # Save registers
sw $2, pcb_reg2($13) 
sw $3, pcb_reg3($13)            
sw $4, pcb_reg4($13)
sw $5, pcb_reg5($13)            
sw $6, pcb_reg6($13)
sw $7, pcb_reg7($13)            
sw $8, pcb_reg8($13)
sw $9, pcb_reg9($13)
sw $10, pcb_reg10($13)            
sw $11, pcb_reg11($13)
sw $12, pcb_reg12($13)

sw $sp, pcb_sp($13)
sw $ra, pcb_ra($13)

movsg $1, $ers                  # Set $1 to be old value of $13
sw $1, pcb_reg13($13)           # Save $1 to the PCB

movsg $1, $ear                  # Save the value of $ear
sw $1, pcb_ear($13)

movsg $1, $cctrl                # Save the value of $cctrl
sw $1, pcb_cctrl($13)


schedule:                       # Choose the next task to run
lw $13, current_task($0)        # Get the current task
lw $13, pcb_link($13)           # Get the next task from the pcb_link field
sw $13, current_task($0)        # Set next task to be the current task


load_context:                   # Restore the task's context
lw $13, current_task($0)        # Get the PCB of the current task

lw $1, pcb_reg13($13)           # Get PCB value for $13 back into $ers
movgs $ers, $1

lw $1, pcb_ear($13)             # Restore value of $ear
movgs $ear, $1

lw $1, pcb_cctrl($13)           # Restore value of $cctrl
movgs $cctrl, $1

addi $1, $0, 100                # Set task to have a time-slice of 100
sw $1, pcb_timeslice($13)

lw $1, pcb_reg1($13)            # Restore the value of the other registers
lw $2, pcb_reg2($13)
lw $3, pcb_reg3($13)            
lw $4, pcb_reg4($13)
lw $5, pcb_reg5($13)            
lw $6, pcb_reg6($13)
lw $7, pcb_reg7($13)            
lw $8, pcb_reg8($13)
lw $9, pcb_reg9($13)
lw $10, pcb_reg10($13)            
lw $11, pcb_reg11($13)
lw $12, pcb_reg12($13)
  
lw $sp, pcb_sp($13)
lw $ra, pcb_ra($13)


rfe                             # Return to the new task


.bss                            # Section that allows allocation of memory (without initialisation)

current_task:                   # Defines a "variable" that pointers to the PCB of the current task
.word

old_vector:                     # Defines a "variable" that stores the old exception (handler) vector
.word 

serialtask_pcb:                 # Defines a process control block for the serial task
.space 19

paralleltask_pcb:               # Defines a process control block for the parallel task
.space 19

gametask_pcb:                   # Defines a process control block for the game task
.space 19


.space 200                      # Defines a separate stack for the serial task
serialtask_stack:               

.space 200                      # Defines a separate stack for the parallel task
paralleltask_stack:               

.space 200                      # Defines a separate stack for the game task
gametask_stack:               

