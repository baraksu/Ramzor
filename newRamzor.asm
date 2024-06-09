                 ; Program: graph.asm
.MODEL small
.STACK 256

.DATA
;=========================================
; Basic program to draw a circle
;=========================================
 mode db 13h ;
 x_center dw 100
 y_center dw 100
 y_value dw 0
 x_value dw 15 ;r
 decision dw 0   
 startpoint dw ?
 h dw ?
 w dw ?
 color db 3 ;1=blue
 homescreen1 db 13,10,'                   _____            __  __ __________  _____  $'
homescreen2 db 13,10,'                  |  __ \     /\   |  \/  |___  / __ \|  __ \ $'
homescreen3 db 13,10,'                  | |__) |   /  \  | \  / |  / / |  | | |__) | $'
homescreen4 db 13,10,'                  |  _  /   / /\ \ | |\/| | / /| |  | |  _  / $' 
homescreen5 db 13,10,'                  | | \ \  / ____ \| |  | |/ /_| |__| | | \ \ $' 
homescreen6 db 13,10,'                  |_|  \_\/_/    \_\_|  |_/_____\____/|_|  \_\$' 
                                                                                         
namepresentation db 13,10,'                                by Ori Papkin                             $'

lines       db 13,10,'  ____________________________________________________________________________    $'

downtab db 13,10,'$'
pressanykey db 13,10,'                    PLEASE PRESS ANY KEYBOARD KEY TO START                            $'

pleaseuse db   13,10,'                                  PLEASE USE                         $' 
pleaseuse1 db  13,10,'                   ______________           _______________           $'
pleaseuse2 db  13,10,'                  |              |         |               |            $'
pleaseuse3 db  13,10,'                  |  R to puase  |         | G to continue |           $'
pleaseuse4 db  13,10,'                  |              |         |               |  $'


;=========================================
.CODE 
homescreen proc ;this proc is showing the home screen of the game
    
    mov ah, 9 
    
    lea dx, downtab
	int 21h
    
    lea dx, homescreen1
	int 21h 
	
	lea dx, homescreen2
	int 21h
	
	lea dx, homescreen3
	int 21h
	
	lea dx, homescreen4
	int 21h     
	
	lea dx, homescreen5
	int 21h
	
	lea dx, homescreen6
	int 21h
	
	lea dx, downtab
	int 21h
	
	lea dx, downtab
	int 21h    
	
	lea dx, namepresentation
	int 21h   
	
	lea dx, downtab
	int 21h
	
	lea dx, lines
	int 21h
	
	lea dx, downtab
	int 21h         
	
	lea dx, pleaseuse
	int 21h
	
	lea dx, downtab
	int 21h
	
	lea dx, pleaseuse1
	int 21h           
	        
	lea dx, pleaseuse2
	int 21h
	
	lea dx, pleaseuse3
	int 21h                  
	
	lea dx, pleaseuse4
	int 21h                   
	
	
	lea dx, downtab
	int 21h 
	
	lea dx, pressanykey
	int 21h
	
	lea dx, downtab
	int 21h  

    ret    
homescreen endp   

Draw_Circle proc  
 mov x_value, 15
 mov y_value, 0 
 mov decision, 0
 mov bx, x_value
 mov ax,2
 mul bx
 mov bx,3
 sub bx,ax ; E=3-2r
 mov decision,bx
 
 mov al,color ;color goes in al
 mov ah,0ch
 
drawcircle:
 mov al,color ;color goes in al
 mov ah,0ch
 
 mov cx, x_value ;Octonant 1
 add cx, x_center ;( x_value + x_center,  y_value + y_center)
 mov dx, y_value
 add dx, y_center
 int 10h
; 
 mov cx, x_value ;Octonant 4
 neg cx
 add cx, x_center ;( -x_value + x_center,  y_value + y_center)
 int 10h
; 
 mov cx, y_value ;Octonant 2
 add cx, x_center ;( y_value + x_center,  x_value + y_center)
 mov dx, x_value
 add dx, y_center
 int 10h
; 
 mov cx, y_value ;Octonant 3
 neg cx
 add cx, x_center ;( -y_value + x_center,  x_value + y_center)
 int 10h
; 
 mov cx, x_value ;Octonant 8
 add cx, x_center ;( x_value + x_center,  -y_value + y_center)
 mov dx, y_value
 neg dx
 add dx, y_center
 int 10h
; 
 mov cx, x_value ;Octonant 5
 neg cx
 add cx, x_center ;( -x_value + x_center,  -y_value + y_center)
 int 10h

 mov cx, y_value ;Octonant 7
 add cx, x_center ;( y_value + x_center,  -x_value + y_center)
 mov dx, x_value
 neg dx
 add dx, y_center
 int 10h
 
 mov cx, y_value ;Octonant 6
 neg cx
 add cx, x_center ;( -y_value + x_center,  -x_value + y_center)
 int 10h
 


condition1:
 cmp decision,0
 jg condition2      
 ;e<0
 mov cx, y_value
 mov ax, 2
 imul cx ;2y
 add ax, 3 ;ax=2y+3
 mov bx, 2
 mul bx  ; ax=2(2y+3)
 add decision, ax
 mov bx, y_value
 mov dx, x_value
 cmp bx, dx
 ja return  
 inc y_value
 jmp drawcircle

condition2:
 ;e>0
 mov cx, y_value 
 mov ax,2
 mul cx  ;cx=2y
 mov bx,ax
 mov cx, x_value
 mov ax, -2
 imul cx ;cx=-2x
 add bx,ax
 add bx,5;bx=5-2z+2y
 mov ax,2
 imul bx ;ax=2(5-2z+2y)       
 add decision,ax
 mov bx, y_value
 mov dx, x_value
 cmp bx, dx
 ja return
 dec x_value
 inc y_value
 jmp drawcircle 
 
return:
 
 ret
Draw_Circle endp   

; startpoint = start column of line, h = row, color = color, w = weight of line > horizontal line
Draw_lr_line proc
   pusha 
    
    mov cx, startpoint  ; column
    mov dx, h       ; row
    mov al, color     ; white
u2: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, w
    ja u2  
   
   popa 
    ret 
draw_lr_line endp

; startpoint = start row of line, w = weight, color = color, h = height of line > vertical line
Draw_ub_line proc 
   pusha
    
    mov cx, w  ; column
    mov dx, startpoint       ; row
    mov al, color     ; white
u3: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, h
    ja u3  
   
   popa 
    ret 
draw_ub_line endp 
    
; w = car's left-up's column, h = car's left-up's row > square car
draw_car proc 
    mov cx, w 
    mov dx, h
    
    mov startpoint, cx
    add startpoint, 30
    mov w, cx
    mov h, dx
    add h, 30 
    call draw_lr_line 
     
    mov startpoint, dx
    add startpoint, 30
    add w, 30
    mov h, dx
    call draw_ub_line 
    
    mov startpoint, cx
    add startpoint, 30
    mov w, cx
    mov h, dx  
    call draw_lr_line
    
    mov startpoint, dx
    add startpoint, 30
    mov w, cx  
    mov h, dx  
    dec h
    call draw_ub_line
                        
    ret
draw_car endp   

; h = height of the first car > column of square cars
draw_pkak proc 
    mov bx, h
  u4:  
    call draw_car
    add h, 55
    
    cmp h, 200
    jb u4
    
    mov h, bx
    
    ret
draw_pkak endp 

; w = car's left-up's column, h = car's left-up's row > move a square car one pixel upwards
move_car proc
   pusha
    
    mov cx, w 
    mov dx, h   
      
    cmp h, 170
    ja u20
    
    mov startpoint, cx
    add startpoint, 30          
    mov w, cx 
    dec w
    mov h, dx
    add h, 30 
    call draw_lr_line
    
    mov color, 0
    inc h
    call draw_lr_line
     
    mov color, 15
   
   u20:                         
    mov startpoint, cx
    add startpoint, 30
    mov w, cx 
    dec w
    mov h, dx  
    
    cmp dx, 0
    je u9
    
    call draw_lr_line 
    
  u9:    
    mov color, 0
    inc h         
    dec startpoint
    inc w
    call draw_lr_line  
    
    mov color, 15 
    
   popa
    ret 
move_car endp 

; w = car's left-up's column, h = car's left-up's row > move a botton of a square car one pixel upwards
move_car_bottom proc
     
    mov cx, w 
    mov dx, h 
    
    mov startpoint, cx
    add startpoint, 30
    mov w, cx 
    mov h, dx  
    
    cmp dx, 0
    je u11
    
    call draw_lr_line  
    
    mov w, cx 
    mov h, dx
    
  u11:    
    mov color, 0
    inc h          
    dec w
    call draw_lr_line
    inc w  
    
    mov color, 15
    
    ret
move_car_bottom endp
                                                          
; h = height of the first car > move a column of square cars one pixel upwards
go proc 
    dec h      

    mov bx, h 
    
    cmp h, 25
    jb u5
    
    sub h, 25
    call move_car_bottom
    add h, 23
      
  u5:         
    call move_car
    add h, 53
           
    cmp h, 200
    jb u5
    
    mov h, bx
    
    cmp h, 0
    je u10
    
    ret
    
  u10:
    add h, 55
    ret             
go endp 

; > Make the Ramzor red, according to the Israeli law
red proc
    mov y_center, 137
    mov color, 7
    call Draw_Circle 
    mov y_center, 100 
    mov color, 14
    call Draw_Circle 
    mov color, 7
    call Draw_Circle 
    mov y_center, 63
    mov color, 4
    call Draw_Circle  
    
    ret
red endp

; > Make the Ramzor green, according to the Israeli law
green proc
    mov y_center, 100 
    mov color, 14
    call Draw_Circle   
    mov y_center, 63
    mov color, 7
    call Draw_Circle
    mov y_center, 100
    call Draw_Circle 
    mov y_center, 137
    mov color, 2    
    call Draw_Circle
    mov color, 15
    
    ret
green endp

start: 
 
 mov ax,@DATA
 mov ds, ax  
 
 call homescreen 
 homescreenwait:
  mov ah,00
  int 16h
  cmp al,0
je homescreenwait 
 
 mov ah,0 ;subfunction 0
 mov al,mode ;select mode 13h 
 int 10h ;call graphics interrupt 
 mov color, 7
;==========================     
 mov x_center, 235
 call Draw_Circle 
 mov y_center, 63
 call Draw_Circle
 mov y_center, 137
 mov color, 2
 call Draw_Circle 
 
 mov color, 15
 mov startpoint, 250
 mov w, 220
 mov h, 170
 call Draw_lr_line 
 mov startpoint, 170
 mov w, 235
 mov h, 152
 call Draw_ub_line    
 mov startpoint, 121
 mov h, 115
 call Draw_ub_line
 mov startpoint, 84
 mov h, 78
 call Draw_ub_line 

 mov startpoint, 195
 mov h, 5        
 mov w, 185
 call Draw_ub_line
 mov w, 135
 call Draw_ub_line
 
 mov w, 145                                                                                                             
 mov h, 7
 call draw_pkak
 mov h, 7
 
u6:
 mov ah, 0Ch 
 int 21h
  
 call go  
 
 mov ah, 1
 int 16h
 jz u6 
  
 mov ah, 00
 int 16h  
             
 cmp ah, 13h
 jne u6 
 
 call red 

u7:
 mov ah, 00
 int 16h 
 
 cmp ah, 22h
 je u8
 
 jmp u7
 
u8:
 call green
 jmp u6 
                   
                    
endd:
 mov ah,00 ;again subfunc 0
 mov al,03 ;text mode 3
 int 10h ;call int
 mov ah,04ch
 mov al,00 ;end program normally
 int 21h 

END start