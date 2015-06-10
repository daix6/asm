EXTRN COLOR:BYTE

PUBLIC SET_MODE, CLEAR

CODESG1 SEGMENT
  ASSUME CS:CODESG1

  ; set mode
  SET_MODE PROC   FAR
    MOV       AH, 00              ; Set mode option
    MOV       AL, 03              ; Change the video mode
    INT       10H                 ; Mode of 80x25 for any color monitor
    RET
  SET_MODE ENDP

  ; make use of the int 10H to clear screen
  CLEAR PROC      FAR
    MOV       AH, 06                  ; Select scroll function
    MOV       AL, 00                  ; The entire page
    MOV       BH, COLOR               ; For initial color
    MOV       CH, 00                  ; Row value of start point
    MOV       CL, 00                  ; Column value of start point
    MOV       DH, 24                  ; Row value of ending point
    MOV       DL, 79                  ; Column value of ending point
    INT       10H                     ; Invoke the interrupt
    RET
  CLEAR ENDP

CODESG1 ENDS
        END