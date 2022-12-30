[org 0x7c00] 		; bios places boot sector at 0x7c00

mov ah, 0x0e 		; select bios write function for video interrupt

mov ebx, 0
print_char: 		; print msg
	mov al, [msg+ebx]
	int 0x10
	inc ebx
	cmp ebx, 13 	; length of msg + 1
	jne print_char

jmp $

msg:
	db "hello, world!"

times 510-($-$$) db 0 	; pad with 0 bytes until 510 bytes in size

dw 0xaa55 		; magic number for bootable sector (two bytes)

			; total - 512 bytes (expected size of boot sector)
