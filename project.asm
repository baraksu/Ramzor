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
;=========================================
.CODE

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
    

draw_car proc 
    mov cx, w 
    mov dx, h
    
    mov startpoint, cx
    add startpoint, 50
    mov w, cx
    mov h, dx
    add h, 50 
    call draw_lr_line 
     
    mov startpoint, dx
    add startpoint, 50
    add w, 50
    mov h, dx
    call draw_ub_line 
    
    mov startpoint, cx
    add startpoint, 50
    mov w, cx
    mov h, dx  
    call draw_lr_line
    
    mov startpoint, dx
    add startpoint, 50
    mov w, cx  
    mov h, dx  
    dec h
    call draw_ub_line
                        
    ret
draw_car endp   

draw_pkak proc 
    mov bx, h
  u4:  
    call draw_car
    add h, 75
    
    cmp h, 200
    jb u4
    
    mov h, bx
    
    ret
draw_pkak endp 

move_car proc
   pusha
    
    mov cx, w 
    mov dx, h   
      
              
    mov startpoint, cx
    add startpoint, 50
    mov w, cx 
    dec w
    mov h, dx
    add h, 50 
    call draw_lr_line
    
    mov color, 0
    inc h
    call draw_lr_line
     
    mov color, 15
                      
    mov startpoint, cx
    add startpoint, 50
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

move_car_bottom proc
     
    mov cx, w 
    mov dx, h 
    
    mov startpoint, cx
    add startpoint, 50
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
    add h, 73
           
    cmp h, 200
    jb u5
    
    mov h, bx
    
    cmp h, 0
    je u10
    
    ret
    
  u10:
    add h, 75
    ret             
go endp 

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
 mov startpoint, 122
 mov h, 115
 call Draw_ub_line
 mov startpoint, 85
 mov h, 78
 call Draw_ub_line 

 mov startpoint, 195
 mov h, 5        
 mov w, 195
 call Draw_ub_line
 mov w, 125
 call Draw_ub_line
 
 mov w, 135                                                                                                               ; fix when done
 mov h, 7
 call draw_pkak
 mov h, 7
 
u6: 
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