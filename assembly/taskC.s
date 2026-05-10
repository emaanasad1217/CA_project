lui     gp, 0x0            # gp = 0 (Base memory address for array)
lui     sp, 0x0            
addi    sp, sp, 256        # sp = 256 (Setup Stack) 0-256
lui     x14, 0x1           # x14 = 0x1000      
addi    x14, x14, -2048      # x14 = 0x800 LED Memory Address
 
 
lw      x10, 1024(x0)     # Read switches into x10, input of n for fibonacci
jal     x1, 16             # Call alloting
lw      x12, 1024(x0)     # (Returns here) Read switches again
bne     x12, x10, -12        # If switches changed, loop back up to read
jal     x0, -8           # If not changed, wait in read
 
 #alloting 0 and 1
addi    sp, sp, -12        # Grow stack
sw      x1, 8(sp)          # Save return address
sw      x10, 4(sp)          # Save switch input
sw      gp, 0(sp)          # Save gp
sw      x0, 0(gp)        # F(0) = 0 (Save to memory index 0)
addi    x5, x0, 1        
sw      x5, 4(gp)          # F(1) = 1 (Save to memory index 1)
addi    x7, x0, 2        # x7 = 2 (Our loop counter)
add     x11, x0, x10       # x11 = Target 'n' (From switches)
jal     x1, 24             # Jump to the exit condition
 
 
lw      x1, 8(sp)          # Restore return address
lw      x10, 4(sp)          # Restore switch input
lw      gp, 0(sp)          # Restore gp
addi    sp, sp, 12         # Shrink stack
jalr    x0, 0(x1)        # Return to main polling loop
#EXIT condition
blt     x11, x7, 72        
bge     x7, x11, 72         # If counter >= target, EXIT loop
#F(n-2)
addi    x5, x7, -2         # Index: n - 2
slli    x5, x5, 2          # Multiply by 4 (to get byte offset)
add     x5, x5, gp         # Add to base address
lw      x5, 0(x5)          # Load F(n-2) from memory into x5
 #F(n-1)
addi    x6, x7, -1         # Index: n - 1
slli    x6, x6, 2          # Multiply by 4 (to get byte offset)
add     x6, x6, gp         # Add to base address
lw      x6, 0(x6)          # Load F(n-1) from memory into x6
 
add     s0, x6, x5         # s0 = F(n-1) + F(n-2)
 
slli    s1, x7, 2          # Current Index * 4
add     s1, s1, gp         # Add to base address
sw      s0, 0(s1)          # Store new Fibonacci number in memory array
 
add     x15, x0, s0       # Copy answer to x15
sw      x15, 0(x14)          # Write answer to LED memory address
 
addi    x7, x7, 1          # Increment counter (x7 = x7 + 1)
jal     x0, -68          # Jump back up to loop exit condition
 
jalr    x0, 0(x1)