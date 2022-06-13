; Desenvolvido para a placa EK-TM4C1294XL
; -------------------------------------------------------------------------------
; Declarações EQU
;<NOME>         EQU <VALOR>

; -------------------------------------------------------------------------------

		AREA  DATA, ALIGN=2
		
        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
			
		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; --------------------------------------------------------------------------------
Aleatorio EQU 0x20000A00 ; equivalente aos "defines"
Ordenado EQU  0x20000B00 ; equivalente aos "defines"



Start
   LDR R0, =Aleatorio
   LDR R1, =Ordenado
   LDR R2, =Valores
   MOV R9, #0
   

Guardar_Valores
   LDRB R3, [R2], #1
   STRB R3, [R0], #1
   CMP R3, #0
   IT NE
   BNE Guardar_Valores
   LDR R0, =Aleatorio
   
Setar_Valores_Para_Operacoes
   LDRB R4, [R0], #1 
   MOV R5, #3
   CMP R4, #0
   ITT EQ
	MOVEQ R2, #1
   BEQ Resetar_Registradores_Nao_Usados
  
Operacoes
   UDIV R6, R4, R5
   MLS R7, R6, R5, R4
   CMP R7, #0
   ITT NE
	ADDNE R5, #2
   BNE Operacoes
   CMP R5, R4
   ITT HS
	STRBHS R5, [R1], #1
	ADDHS R9, R9, #1
   B Setar_Valores_Para_Operacoes

Resetar_Registradores_Nao_Usados
   MOV R1, #0
   MOV R2, #0
   MOV R3, #0
   MOV R4, #0
   MOV R5, #0
   MOV R6, #0
   MOV R7, #0
   MOV R8, #0
   MOV R10, #0
   B Setar_Valores_Para_Ordenacao
   
   
Setar_Valores_Para_Ordenacao
   LDR R5, =Ordenado
   ADD R6, R5, #1
   MOV R4, #1
   MOV R2, #1
   ADD R2, R2, R3
   B Loop_1



Loop_1
   CMP R2, R9
   ITE HS
	ADDHS R3, R3, #1
   BLO Ordenar 
   B Setar_Valores_Para_Ordenacao

Ordenar
   CMP R4, R9
   IT EQ
   BEQ FINAL
   LDRB R7, [R5]
   LDRB R8, [R6]
   CMP R7, R8
   ITTTE HS
	MOVHS R10, R7
	MOVHS R7, R8
	MOVHS R8, R10
   BLO Pular_O_Maior
   STRB R7, [R5]
   STRB R8, [R6]
   ADD R5, #1
   ADD R6, #1
   ADD R2, R2, #1
   B Loop_1

Pular_O_Maior
   ADD R5, #1
   ADD R6, #1
   ADD R2, R2, #1
   ADD R4, R4, #1
   B Ordenar

FINAL
   NOP

; ---------------------------------------------------------------------------------
; Declarando constantes:

Valores DCB 193, 63, 176, 127, 43, 13, 211, 3, 203, 5, 21, 7, 206, 245, 157, 237, 241, 105, 252, 19, 0


    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
