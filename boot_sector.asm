[org 0x7c00] 		; bios places boot sector at 0x7c00

mov ah, 0x0e 		; select bios write function for video interrupt (tty mode)

mov bp, 0x8000		; setup stack
mov sp, bp 		; empty stack, so sp = bp

mov bx, MSG
call print

jmp $

; print string at bx register
print:
	pusha
	mov ah, 0x0e	
print_char:
	mov al, [bx] 	; move char into al
	cmp al, 0
	je done_print	; stop at null terminator

	int 0x10
	add bx, 1
	jmp print_char
done_print:
	popa
	ret


MSG:
	db "hello, world!", 0

times 510-($-$$) db 0 	; pad with 0 bytes until 510 bytes in size

dw 0xaa55 		; magic number for bootable sector (two bytes)

			; total - 512 bytes (expected size of boot sector)
