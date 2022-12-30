; print string at bx register
print:
	pusha
	mov ah, 0x0e	
print_char:
	mov al, [bx] 	; move char into al
	cmp al, 0
	je done_print	; stop at null terminator

	int 0x10	; trigger video interrupt
	inc bx
	jmp print_char
done_print:
	popa
	ret

print_nl:
	pusha
	mov ah, 0x0e
	mov al, 0x0a 	; new line
	int 0x10
	mov al, 0x0d	; carriage return
	int 0x10
	popa
	ret

; print hex at dx register
print_hex:
	pusha
	mov cx, 0 	; index
loop_print_hex: 	 
	cmp cx, 4	; loop 4 times, once per hex digit in string
	je done_print_hex
	mov ax, dx	
	and ax, 0xf	; take last digit
	add ax, 0x30	; convert to ascii
	cmp ax, 0x39
	jle skip_if_numeric
	add ax, 7	; if A-F (ascii), add 7
skip_if_numeric:
	mov bx, HEX_OUT + 5	
	sub bx, cx	; point bx to hex string using index
	mov [bx], al	; write digit to string
	ror dx, 4	; rotate input hex 
	inc cx
	jmp loop_print_hex
done_print_hex:
	mov bx, HEX_OUT
	call print
	popa
	ret

HEX_OUT:
	db "0x0000", 0
