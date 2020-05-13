; ----------------------------------------------------------------------------
; p2.asm
;
; NASM Template f�r Praktikum 2
; ----------------------------------------------------------------------------

        global  main
        extern  printf

        section .text
main:
		;;;;;;;;;;;;;;;;;;;;;;;;; eigener Code beginnt hier ;;;;;;;;;;;;;;;;;;;;;;;;;

		; Initialisierung
        mov     eax, 0
        mov     edx, 1
        mov		ecx, 50
        loop:  
        call    fib
        call    print
        dec     ecx
        jnz     loop
        ret
        
fib:    
        mov     ebx, eax        
        add     eax, edx
        mov     edx, ebx
        ret

		
		;;;;;;;;;;;;;;;;;;;;;;;;; abschlie�ende Ausgabe ;;;;;;;;;;;;;;;;;;;;;;;;;
		
print:
        push    eax
        push    edx
        push    ecx      
        push    ebx  
        push    eax             ;;;;; hier Register angeben, welches das Ergebnis enth�lt
        push    decformat
        call    printf
        add     esp, 8			; ESP um 2 DWORD zur�ckstellen
        pop     ebx
        pop     ecx
        pop     edx
        pop     eax
        ret
		
		section .data

decformat:
        db      '%10d', 10, 0	; null-terminierter String, 10 = LF
