; ----------------------------------------------------------------------------
; p3.asm
; ----------------------------------------------------------------------------

        global  main
        extern  atoi
        extern  printf

        section .text
main:
        mov     eax, [esp+4]            ; argc
        cmp     eax, 2                  ; die Kommandozeile muss genau 2 Parameter haben, d.h. 1 Argument
        jne     badCommand

        mov     eax, [esp+8]            ; argv
        push    DWORD [eax+4]           ; atoi-Parameter ist die Zeichenkette, auf die das zweite argv-Element zeigt
        call    atoi				    ; liefert integer in eax
        add     esp, 4					; ESP um 1 DWORD zur�ckstellen
		
		;;;;;;;;;;;;;;;;;;;;;;;;; eigentl. Programm ;;;;;;;;;;;;;;;;;;;;;;;;;

loop:   cmp eax, 1
        je  end
        push eax
        push eax             
        push decNumFormat
        call printf
        add esp, 8
        pop eax
        push eax                        ;eax sichern, falls eax ungerade ist
        
divide: mov ebx, 2
        mov edx, 0
        div ebx
        cmp edx, 0
        jne multip
        pop ebx
        jmp loop

multip: pop eax                         ;gesichertes eax
        mov ebx, 3
        mul ebx
        inc eax
        jmp loop

end:    push eax
        push eax        
        push decNumFormat
        call printf
        add esp, 8
        pop eax

finished:
		ret

		;;;;;;;;;;;;;;;;;;;;;;;;; Programmende bei Eingabefehler ;;;;;;;;;;;;;;;;;;;;;;;;;
		
badCommand:
        push    badArgumentFormat
        call    printf
        add     esp, 4			; ESP um 1 DWORD zur�ckstellen
        ret

	
		section .data
		
badArgumentFormat:
        db      'bad argument', 10, 0		; 10 = LF
decNumFormat:
        db      '%10d', 10, 0
stringFormat:
        db      '"%s"', 10, 0	; falls zum Testen ben�tigt
