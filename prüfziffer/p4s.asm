; ----------------------------------------------------------------------------
; p4.asm: checksum calculation for German ID card number
; ----------------------------------------------------------------------------

          global  main
          extern  printf

          section .text
main:
          mov     eax, [esp+4]            ; argc
          cmp     eax, 2                  ; die Kommandozeile muss genau 2 Parameter haben, d.h. 1 Argument
          jne     badCommand

          mov     eax, [esp+8]            ; argv
          mov	  ebx, [eax+4]            ; Startadresse der Zeichenkette, auf die das zweite argv-Element zeigt

          mov edi, 0
          mov edx, 0
          push ebx
  
          call	checksum
  
          pop edx

          push    ebx                     ; Prüfziffer
          push    edx                     ; String der Nummer
          push    stringFormat
          call    printf
          add     esp, 12	       		  ; ESP um 3 DWORD zurückstellen

          ret     				          ; beendet main

checksum:
          mov eax, [esp+4]                ; erste Stelle des argarrays
          mov ecx, 0                      ; Index des aktuellen Buchstabens
          mov esi, 7                      ; erster Multiplikator 

schleife:
          mov bl, [eax+ecx]
          inc ecx
          cmp bl, 65                      ; A in ASCII = 65
          jge buchstabe
          jmp zahl

bedingung:
          mov bl, [eax+ecx]
          cmp bl, 0
          je ende
          jmp schleife
          ret

buchstabe:
          sub bl, 55                      ; A = 10

          push eax                        ; erste Stelle des argarrays
          mov eax, 0                      ; eax und edx leeren
          mov edx, 0

          movzx eax, bl
          mul esi

          add edi, eax                    ; KA EDI, wahrscheinlich zum speichern des Ergebnnis

          pop eax

          jmp zaehler                     
          ret

zahl:
          sub bl, 48 ; 0 = 0

          push eax
          mov eax, 0
          mov edx, 0
          
          movzx eax, bl
          mul esi

          add edi, eax

          pop eax

          jmp zaehler ; Pruefen, welches naechse Mul-Zahl is
          ret

zaehler:                                  ; nächsten Multiplikator setzen
          cmp esi, 7
          je sieben

          cmp esi, 3
          je drei

          cmp esi, 1
          je eins

          jmp ende                        ; Fehlerbehandlung
          ret

sieben:
          mov esi, 3
          jmp bedingung
          ret

drei:
          mov esi, 1
          jmp bedingung
          ret

eins:
          mov esi, 7
          jmp bedingung
          ret

ende:
          mov eax, edi
          mov ecx, 10
          div ecx
          mov ebx, edx
          ret

		  ;;;;;;;;;;;;;;;;;;;;;;;;; Ausgaben ;;;;;;;;;;;;;;;;;;;;;;;;;

badCommand:
          push    badArgumentFormat
          call    printf
          add     esp, 4			; ESP um 1 DWORD zurückstellen
          ret

          section .data
badArgumentFormat:
          db      'bad argument', 10, 0		; 10 = LF
stringFormat:
          db      '"%s%1d"', 10, 0
dummy:
          db      'NN', 0
