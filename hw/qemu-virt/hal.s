@ --- Equates
.equ    UART_ADDR,      0x09000000  @ QEMU UART Base Adddress
.equ    UART_DR_OFFSET, 0x00      @ UART Data Register Offset
.equ    UART_FR_OFFSET, 0x18      @ UART Flag Register Offset
.equ    UART_RXFE_MASK, 0x10      @ UART Flag Register RX Empty Mask
.equ    UART_TXFF_MASK, 0x20      @ UART Flag Register TX Full Mask
.equ    OUT_CHAR,       0x20      @ First printable ASCII character - 1.

.text
.global putc
putc:
/*  Prints the contents of R0 out of the UART pointed to by R1.
 *  Preconditions:
 *    R0 contains the character to send over the UART.
 *  Modifies: None
 */
        PUSH {LR}
        PUSH {R1-R3}              @ Preserve used registers in stack.
        LDR   R1, =UART_ADDR            @ Load R1 with UART_ADDR.
        MOV   R3, #UART_TXFF_MASK
1:  	LDR   R2, [R1,#UART_FR_OFFSET]  @ Check [R1:UART_FR_OFFSET] & UART_TXFF_MASK == 0.
        TST   R2, R3
        BNE   1b                        @ Loop till UART0 is ready to TX.
        STR   R0, [R1,#UART_DR_OFFSET]  @ Store value R0 in [R1:UART_DR_OFFSET].
        POP  {R1-R3}              @ Return used registers from stack.
        POP  {PC}                       @ Return to main.

.global getc
getc:
/*  Prints the contents of R0 out of the UART pointed to by R1.
 *  Preconditions:
 *    R1 contains the address of the UART to send the character over.
 *  Modifies:
 *    R0 will contain the value in the UART buffer.
 */
        PUSH {LR}
        PUSH {R1-R3}              @ Preserve used registers in stack.
        LDR   R1, =UART_ADDR            @ Load R1 with UART_ADDR.
        MOV   R3, #UART_RXFE_MASK
1:      LDR   R2, [R1,#UART_FR_OFFSET]  @ Check [R1:UART_FR_OFFSET] & UART_TXFF_MASK == 0.
        TST   R2, R3
        BNE   1b                        @ Loop till UART0 is ready to TX.
        LDR   R0, [R1,#UART_DR_OFFSET]  @ Store value R0 in [R1:UART_DR_OFFSET].
        POP  {R1-R3}              @ Return used registers from stack.
        POP  {PC}                       @ Return to main.
