addi    sp, zero, 508      # Initialize Stack Pointer (sp) to 508
addi    s0, zero, 1024     # s0 = switch address
lui     s1, 0x1            # s1 = 0x1000
addi    s1, s1, -2048      # s1 = led address
lui     s2, 0x1            # s2 = 0x1000
addi    s2, s2, -1024      # s2 = reset address
sw      zero, 0(s1)        # Clear LEDs (Write 0 to s1)
 
# loading Loop
lw      t1, 0(s0)          # Read input from switches (s0)
beq     t1, zero, -4       # If input == 0, jump back
sw      t1, 0(s1)          # Write the input to the LEDs
addi    a0, t1, 0          # Move input value to a0 (function argument)
jal     ra, 8              # Call the countdown
jal     x0, -24          # When returned, jump back to clear leds
 
# Countdown/Display Function
addi    sp, sp, -12        # Grow stack by 3 words
sw      ra, 8(sp)          # Save return address
sw      s0, 4(sp)          # Save s0
sw      s1, 0(sp)          # Save s1
addi    t2, a0, 0          # t2 = a0 (Our countdown starting value)
 
# Subroutine Loop
lw      t1, 0(s2)          
bne     t1, x0, 20         # if not reset
beq     t2, x0, 20         # If countdown value (t2) == 0, exit loop
sw      t2, 0(s1)          # Display current countdown value on LEDs
addi    t2, t2, -1         # Decrement countdown (t2 = t2 - 1)
jal     x0, -20          # Jump back to start of this loop
 
#Return
sw      x0, 0(s1)        # Clear the LEDs
lw      s1, 0(sp)          # Restore s1
lw      s0, 4(sp)          # Restore s0
lw      ra, 8(sp)          # Restore return address
addi    sp, sp, 12         # Shrink stack
jalr    x0, 0(ra)        # Return to main program