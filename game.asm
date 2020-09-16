include macro.h

.model small
.stack
.data
string1 db "Game	Over$"	;�C���������r��w�q
string2 db "Best Score:   $"
string3 db "Score:   $"
string4 db "press Enter to play again $"
string5 db "press Esc to leave $"
string6 db "Game Start(press Enter to play)$"	;�C���������r��w�q
string7 db "Exit(press Esc to leave)   $"
string8 db "    FROGGY    $"
xend	dw 340	;�C��x�y�Ъ����u
x	dw 300	;�C��x�y��
y	dw 440	;�C��y�y��
virusy	dw 480	;�U��r��y�y��
counter	dw 40	;�C��counter
counter0 dw 10	;�I��counter
counter1 dw 0	;�I��counter
viruscounter dw ?	;�r��C�L��counter
goviruscounter dw 0	;�}�l�I��r��counter
carXcounter dw 45	;��x�y��counter
carYcounter dw 45
jumpcounter  dw 5	;�C��i�H����counter
car1x	dw 595	;��1��x�y��
car2x	dw 0
car3x	dw 595
car4x	dw 0
car5x	dw 595
car6x	dw 0
car7x	dw 595
cary	dw 55
car1speed dw 12	;��1���t��
car2speed dw 7
car3speed dw 10
car4speed dw 15
car5speed dw 8
car6speed dw 6
car7speed dw 4
virusspeed dw 1
score dw 0	;����
bestscore dw 0	;���v����
fail	dw 0	;����counter
nocar	dw 0	;�r��g�L �L������counter
color1 db 1010b	;�C���C��
carcolor db 1001b	;���C��
.code
main proc
	mov ax,@data
	mov ds,ax
startpicture:
	SetMode 12h	;�C���}�l�e��
	Setcolor 1
	SetCursor 10,25	;�C���W��
	PrintStr string8
	SetCursor 23,25	;start��m
	PrintStr string6
	SetCursor 26,25		;exit��m
	PrintStr string7
press:
	mov ah,10h
	int 16h
	cmp al,1bh	;��esc����
	jz over
	cmp al,0dh	;��enter�i�J�C��
	jz gamestart0
	jmp press	;�j�� 
gamestart0:	;�s�C�������k0
	mov	score,0
gamestart:	;�C���}�l or �C�챼�춤�� ��l�Ƴ]�w
	mov	x,300
	mov	y,440
	mov	virusy,480
	mov	nocar,0
	mov	car1x,595
	mov	car2x,0
	mov	car3x,595
	mov	car4x,0
	mov	car5x,595
	mov	car6x,0
	mov	car7x,595
	mov	cary,595
	mov	fail,0
	mov	goviruscounter,0
	mov	jumpcounter,5
	mov	xend,340
	SetMode 12h  
	SetColor 0111b	;�I���Ǧ�
	call	Setback	;�e�զ���j�q
	call	drawfrog	;�e�C��
	call	drawcar	;�e���|�ʪ�7�x���l

game:	;�C���j��		
	call	scan	;���y����A�C��W�U���k����
	cmp al,1bh	;��esc ��������
	je over
	cmp al,38h
	je up
	cmp al,32h
	je down	
	cmp al,34h
	je left
	cmp al,36h
	je right
	call	drawcarmove	;7�x���l����
	cmp	fail,1	;�I�쨮�lgameover
	je	gameover
	cmp	goviruscounter,30	;���l����20���ᩳ���}�l��r
	ja	virus	
	jmp	game
	
virus:	;��r
	call	drawvirus	;�e�r��
	cmp	fail,1	;�I��rgameover
	je	gameover
	jmp	game

up:	;�C��V�W��
	cmp	jumpcounter,5	;���l����5������~�i�H���A�������۫���@����
	jae	canjump
	jmp	game
canjump:	
	sub	color1,0011b	
	call	drawfrog	;�e�I���C��A�M���쥻��
	add	color1,0011b
	sub	y,55	;�C�쩹�W�@�ӹD��
	call	drawfrog
	mov	jumpcounter,0	;�i�H���ocounter�k0
	cmp	dx,0	;�P�_��̤W���ɡA�W�[�C������
	je	gowin
	jmp game
down:
	sub	color1,0011b
	call	drawfrog
	add	color1,0011b
	add	y,55
	cmp	y,440	;�b�����ɤ���A�V�U����
	ja	bottom
	jmp	nothing
bottom:
	mov	y,440
nothing:	;�b�����H�W�A�i�H�V�U	
	call	drawfrog
	jmp game
left:
	sub	color1,0011b
	call	drawfrog
	add	color1,0011b
	sub	x,55	;�C�첾��55��
	sub	xend,55	;�C��x�����u�]�n�@�_����55��
	call	drawfrog
	jmp game
right:
	sub	color1,0011b
	call	drawfrog
	add	color1,0011b
	add	x,55
	add	xend,55
	call	drawfrog	
	jmp game

gowin:	;�W�[�C������
	call	delay	;���ݤ@�U
	call	win	;�I�s�W�[�C������*1��
	jmp gamestart

gameover:	;�I��r or ���l �C������
	mov	ax,score	;�P�_�̨ξ��v����
	cmp	ax,bestscore
	jae	setscore
gameover1:
	SetMode 12h  
	SetColor 0001b	;�I�����Ŧ�
	SetCursor 8,27	;�]��Ц�m
	PrintStr string1	;�Lgame over
	SetCursor 14,27	
	PrintStr string2	;�L�̨Τ���
	mov	ax,bestscore	;ax���n�B�z��L��4���
	call	printscore	;�B�z4��ƫ�L
	SetCursor 16,27
	PrintStr string3	;�L����
	mov	ax,score
	call	printscore
	SetCursor 20,27
	PrintStr string4	;�L�b���@������k
	SetCursor 22,27
	PrintStr string5	;�L���}����k
	GetChar	
	cmp al,1bh	;��esc���}
	je over
	cmp al,0dh	;��enter �A���@��
	je gamestart0	;�A���@���A���Ƴ]0 ��l��l��
	jmp	gameover1
setscore:	;����Ƥj��̨Τ��Ʈ�
	mov	bestscore,ax
	jmp	gameover1

over:	;���}�C��
	SetMode 03h
	mov ax,4c00h
	int 21h
main endp


drawfrog proc	;���C��
	mov	cx,x
	mov	dx,y
L5:
	WrPixel cx,dx,color1
	inc	dx 	;�ѤW���V�U�e
	dec	counter	;y�b�e40��
	cmp	counter,0
	je	L6
	jmp	L5	
L6:
	mov	counter,40	;y�e�����ƭ��]��40
	sub	dx,40	;y�q�^�W��
	inc	cx	;X�b+1�A�A���k��e
	cmp	cx,xend	;�u��e40���A���i�W�L	
	je	L7
	jmp	L5

L7:	
	ret
drawfrog endp


drawvirus proc	;�e�r
	mov	cx,0	;�q�̥���}�l
	mov	dx,virusy
	mov	ax,virusspeed	;�r�V�W���t��
	mov	viruscounter,ax	;�r�V�W�����
virusstart:
	call	colortest	;����e��m���C��A�O�C�쪺�C��N����
	cmp	fail,1
	je	virusend
	cmp	al,1001b	;����e��m���C��A�O�����C��N�]�m���l���n��
	je	carstop	
	WrPixel cx,dx,0100b
	inc	cx	;�ѳ̥k�� 0 �e�� 640	
	cmp	cx,641
	je	virus1
	jmp	virusstart	
virus1:
	mov	cx,0
	sub	dx,1	;�V�W�@�C
	sub	viruscounter,1		
	cmp	viruscounter,0	;�P�_�r�i�H�V�W����ơA�Ĥ@���u�|�V�W�@��
	je	virusend 
	jmp	virusstart

carstop:
	add	nocar,1
virusend:
	mov	virusy,dx
	ret		
	drawvirus endp
	


drawcar proc	;�e7�x���|�ʪ�����
	call	car1	;�e��1���Ʋ[��
	call	car2
	mov	car2x,0	;��2 4 6���q�̥���X��
	call	car3
	call	car4
	mov	car4x,0
	call	car5
	call	car6
	mov	car6x,0
	call	car7
	ret
drawcar endp

drawcarmove proc	;7������

drawcar7set:	;�̤U�誺���l����
	cmp	nocar,1	;�I��r
	je	drawcar6set0	;nocar����1�A��ܥu�M�@��
	cmp	nocar,2	;�M���@����A�������U�@�x������
	jae	drawcar6set
	mov	carcolor,0111b
	call	car7set	;���l���ʡA���ΦǦ�M��
	mov	carcolor,1001b
	call	car7set	;���l����

	jmp	drawcar6set
drawcar6set0:	;�I��r�A�h�����έI���C��(�Ǧ�)�M��	
	mov	carcolor,0111b
	sub	car7x,44	;���|�ʪ����l�O�q���W�}�l�e�A�ҥHX�y�Эn��^�h
	call	car7
	add	nocar,1	;�M���@����Anocar+1�A�U���i�H�������U�@�x��

drawcar6set:	;��6����
	cmp	nocar,3
	je	drawcar5set0
	cmp	nocar,4
	jae	drawcar5set
	mov	carcolor,0111b
	call	car6set
	mov	carcolor,1001b
	call	car6set
	jmp	drawcar5set
drawcar5set0:
	mov	carcolor,0111b
	call	car6
	add	nocar,1

drawcar5set:	;��5����
	cmp	nocar,5
	je	drawcar4set0
	cmp	nocar,6
	jae	drawcar4set
	mov	carcolor,0111b
	call	car5set
	mov	carcolor,1001b
	call	car5set
	jmp	drawcar4set
drawcar4set0:
	mov	carcolor,0111b
	sub	car5x,44
	call	car5
	add	nocar,1
	
drawcar4set:	;��4����
	cmp	nocar,7
	je	drawcar3set0
	cmp	nocar,8
	jae	drawcar3set
	mov	carcolor,0111b
	call	car4set
	mov	carcolor,1001b
	call	car4set
	jmp	drawcar3set
drawcar3set0:
	mov	carcolor,0111b
	call	car4
	add	nocar,1

drawcar3set:	;��3����
	cmp	nocar,9
	je	drawcar2set0
	cmp	nocar,10
	jae	drawcar2set
	mov	carcolor,0111b
	call	car3set
	mov	carcolor,1001b		
	call	car3set
	jmp	drawcar2set
drawcar2set0:
	mov	carcolor,0111b
	sub	car3x,44
	call	car3
	add	nocar,1

drawcar2set:	;��2����
	cmp	nocar,11
	je	drawcar1set0
	cmp	nocar,12
	jae	drawcar1set
	mov	carcolor,0111b
	call	car2set
	mov	carcolor,1001b
	call	car2set
	jmp	drawcar1set
drawcar1set0:	;��1����
	mov	carcolor,0111b
	call	car2
	add	nocar,1

drawcar1set:
	cmp	nocar,13
	jae	drawcarmoveend
	mov	carcolor,0111b
	call	car1set
	mov	carcolor,1001b
	call	car1set

drawcarmoveend:
	inc	goviruscounter
	inc	jumpcounter 
	ret
drawcarmove endp


car1set proc	;��1���ʲ[���A���q�k�W�����U�}�l�e�AX�b�u�e�t�ױơA�ӫD���e
	jmp	start
Lcarset:	;���l�I����ɮɡA���M���쥻��m�����l�A�A�q��l��m�}�l�e�C
	mov	carcolor,0111b
	mov	car1x,0	;�q���(0)�}�l���k�U�M
	call	car1	;�εe��l���l���[���M��x��
	mov	carcolor,1001b
	mov	car1x,595	;���l��l��m
	call	car1
	mov	carcolor,0111b	
	call	car1set	;���l�^��l��m��A���ʤ@��
	jmp	set1end	
start:
	cmp	carcolor,0111b	;����O�n�M���٬O����
	je	cover1
	jne	add1
cover1:	
	mov	cx,car1x	;��1��X�y�ЦA�̥k��A���ΰʧY�i��
	jmp	draw1
add1:	;���ʼW�[	
	cmp	car1speed,45	;��t�׶W�L���l�j�p�ɡA�εe��l���l���[������
	ja	bigsize
	mov	ax,car1x	
	sub	ax,45	;�A�̥k�䪺X�y�лݴ�45�A�ܨ�̥k��A�}�l�����W�[
	mov	cx,ax
	mov	ax,car1speed
	sub	car1x,ax	;���l��X�y��(�A�̥k��)�����t�סA�אּ���ʫ�b�̥k�䪺�y�СC
	jmp	draw1
bigsize:
	cmp	cx,45	;������l�O�_�I�����
	jb	Lcarset	
	sub	cx,45	;X�y�лݴ�45�A�]���e��l���l���[���O�q�̥���}�l�e�A�ҥHcover���᪺x�y�лݦA-45�A�e
	mov	car1x,cx
	call	car1
	jmp	set1end	


draw1:	
	mov	cary,55	;��7��y�y��
	mov	dx,cary
	mov	carYcounter,45	;���l���j�p(45*45)
	mov	ax,car1speed
	mov	carXcounter,ax	;���l�t�סA��x�b�@���i�H�W�[�h��
Lcar0set:
	call	colortest	;�P�_�O�_�I��C��
	WrPixel cx,dx,carcolor
	inc	dx	;�V�U�e 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar1set
	jmp	Lcar0set
Lcar1set:
	mov	carYcounter,45
	sub	dx,45
	dec	cx	;�V���e
	cmp	cx,0	;�I�����
	je	Lcarset 			
	dec	carXcounter	
	cmp	carXcounter,0	;�@���u�e or �M �ƱơA�ӫD���e
	je	set1end
	jmp	Lcar0set
set1end:	
	ret				
	car1set endp

car2set proc	;��2���ʲ[���A���q���W���k�U�}�l�e�AX�b�u�e�t�ױơA�ӫD���e	
	jmp	start2
Lcar2set:	;��2�I�����
	mov	carcolor,0111b
	mov	car2x,595
	call	car2
	mov	carcolor,1001b
	mov	car2x,0
	call	car2
	sub	cx,45	
	mov	car2x,cx
	jmp	set2end	
start2:
	cmp	carcolor,0111b
	je	cover2
	jne	add2
cover2:	
	mov	cx,car2x	;��2��X�y�ЦA�̥���A���ΰʧY�i�q����}�l�M
	jmp	draw2
add2:	
	cmp	car2speed,45	;���t�j��45
	ja	bigsize2
	mov	ax,45
	add	ax,car2x	;��2��X�y�вM����A�ݥ[45�~��q�k��}�l���k�e�A���ʡC
	mov	cx,ax
	mov	ax,car2speed
	add	car2x,ax	;���l�M�� �e�����X�y�Э��s�]�b�̥���C
	jmp	draw2
bigsize2:
	cmp	cx,595	;�I�����
	ja	Lcar2set
	mov	car2x,cx	
	call	car2
	sub	cx,45	;X�y�лݴ�45�A�]���e����X�A�̥k��A�ݴ�45�^��̥���
	mov	car2x,cx
	jmp	set2end	

draw2:	
	mov	cary,110	;��2��y�y��
	mov	dx,cary
	mov	carYcounter,45
	mov	ax,car2speed
	mov	carXcounter,ax	
Lcar2set1:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx	;�V�U�e
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar2set2
	jmp	Lcar2set1
Lcar2set2:
	mov	carYcounter,45
	sub	dx,45
	inc	cx	;�V�k�e
	cmp	cx,640	;�I�����
	je	Lcar2set 	
	dec	carXcounter
	cmp	carXcounter,0
	je	set2end
	jmp	Lcar2set1
set2end:	
	ret				
	car2set endp


car3set proc	;�P��1�A�u��y�y�и�t��
	jmp	start3
Lcar3set:
	mov	carcolor,0111b
	mov	car3x,0
	call	car3
	mov	carcolor,1001b
	mov	car3x,595
	call	car3
	mov	carcolor,0111b
	call	car3set
	jmp	set3end	
start3:
	cmp	carcolor,0111b
	je	cover3
	jne	add3
cover3:	
	mov	cx,car3x
	jmp	draw3
add3:	
	cmp	car3speed,45
	ja	bigsize3
	mov	ax,car3x
	sub	ax,45
	mov	cx,ax
	mov	ax,car3speed
	sub	car3x,ax
	jmp	draw3
bigsize3:
	cmp	cx,45
	jb	Lcar3set
	sub	cx,45
	mov	car3x,cx
	call	car3
	jmp	set3end	


draw3:	
	mov	cary,165
	mov	dx,cary
	mov	carYcounter,45
	mov	ax,car3speed
	mov	carXcounter,ax	
Lcar3set1:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar3set2
	jmp	Lcar3set1
Lcar3set2:
	mov	carYcounter,45
	sub	dx,45
	dec	cx
	cmp	cx,0
	je	Lcar3set 	
	dec	carXcounter
	cmp	carXcounter,0
	je	set3end
	jmp	Lcar3set1
set3end:	
	ret				
	car3set endp



car4set proc	;�P��2�A�u��y�y�и�t��
	jmp	start4
Lcar4set:
	mov	carcolor,0111b
	mov	car4x,595
	call	car4
	mov	carcolor,1001b
	mov	car4x,0
	call	car4
	sub	cx,45
	mov	car4x,cx
	jmp	set4end	
start4:
	cmp	carcolor,0111b
	je	cover4
	jne	add4
cover4:	
	mov	cx,car4x
	jmp	draw4
add4:	
	cmp	car4speed,45
	ja	bigsize4
	mov	ax,45
	add	ax,car4x
	mov	cx,ax
	mov	ax,car4speed
	add	car4x,ax
	jmp	draw4
bigsize4:
	cmp	cx,595
	ja	Lcar4set
	mov	car4x,cx
	call	car4
	sub	cx,45
	mov	car4x,cx
	jmp	set4end	

draw4:	
	mov	cary,220
	mov	dx,cary
	mov	carYcounter,45
	mov	ax,car4speed
	mov	carXcounter,ax	
Lcar4set1:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar4set2
	jmp	Lcar4set1
Lcar4set2:
	mov	carYcounter,45
	sub	dx,45
	inc	cx
	cmp	cx,640
	je	Lcar4set 	
	dec	carXcounter
	cmp	carXcounter,0
	je	set4end
	jmp	Lcar4set1
set4end:	
	ret				
	car4set endp

car5set proc	;�P��1�A�u��y�y�и�t��
	jmp	start5
Lcar5set:
	mov	carcolor,0111b
	mov	car5x,0
	call	car5
	mov	carcolor,1001b
	mov	car5x,595
	call	car5
	mov	carcolor,0111b
	call	car5set
	jmp	set5end	
start5:
	cmp	carcolor,0111b
	je	cover5
	jne	add5
cover5:	
	mov	cx,car5x
	jmp	draw5
add5:	
	cmp	car5speed,45
	ja	bigsize5
	mov	ax,car5x
	sub	ax,45
	mov	cx,ax
	mov	ax,car5speed
	sub	car5x,ax
	jmp	draw5
bigsize5:
	cmp	cx,45
	jb	Lcar5set
	sub	cx,45
	mov	car5x,cx
	call	car5
	jmp	set5end	
draw5:	
	mov	cary,275
	mov	dx,cary
	mov	carYcounter,45
	mov	ax,car5speed
	mov	carXcounter,ax	
Lcar5set1:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar5set2
	jmp	Lcar5set1
Lcar5set2:
	mov	carYcounter,45
	sub	dx,45
	dec	cx
	cmp	cx,0
	je	Lcar5set 	
	dec	carXcounter
	cmp	carXcounter,0
	je	set5end
	jmp	Lcar5set1
set5end:	
	ret				
	car5set endp


car6set proc	;�P��2�A�u��y�y�и�t��
	jmp	start6
Lcar6set:
	mov	carcolor,0111b
	mov	car6x,595
	call	car6
	mov	carcolor,1001b
	mov	car6x,0
	call	car6
	sub	cx,45
	mov	car6x,cx
	jmp	set6end	
start6:
	cmp	carcolor,0111b
	je	cover6
	jne	add6
cover6:	
	mov	cx,car6x
	jmp	draw6
add6:	
	cmp	car6speed,45
	ja	bigsize6
	mov	ax,45
	add	ax,car6x
	mov	cx,ax
	mov	ax,car6speed
	add	car6x,ax
	jmp	draw6
bigsize6:
	cmp	cx,595
	ja	Lcar6set
	mov	car6x,cx
	call	car6
	sub	cx,45
	mov	car6x,cx
	jmp	set6end	

draw6:	
	mov	cary,330
	mov	dx,cary
	mov	carYcounter,45
	mov	ax,car6speed
	mov	carXcounter,ax	
Lcar6set1:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar6set2
	jmp	Lcar6set1
Lcar6set2:
	mov	carYcounter,45
	sub	dx,45
	inc	cx
	cmp	cx,640
	je	Lcar6set 	
	dec	carXcounter
	cmp	carXcounter,0
	je	set6end
	jmp	Lcar6set1
set6end:	
	ret				
	car6set endp

car7set proc	;�P��1�A�u��y�y�и�t��
	jmp	start7
Lcar7set:
	mov	carcolor,0111b
	mov	car7x,0
	call	car7
	mov	carcolor,1001b
	mov	car7x,595
	call	car7
	mov	carcolor,0111b
	call	car7set
	jmp	set7end	
start7:
	cmp	carcolor,0111b
	je	cover7
	jne	add7
cover7:	
	mov	cx,car7x
	jmp	draw7
add7:	
	cmp	car7speed,45
	ja	bigsize7
	mov	ax,car7x
	sub	ax,45
	mov	cx,ax
	mov	ax,car7speed
	sub	car7x,ax
	jmp	draw7
bigsize7:
	cmp	cx,45
	jb	Lcar7set
	sub	cx,45
	mov	car7x,cx
	call	car7
	jmp	set7end	


draw7:	
	mov	cary,385
	mov	dx,cary
	mov	carYcounter,45
	mov	ax,car7speed
	mov	carXcounter,ax	
Lcar7set1:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar7set2
	jmp	Lcar7set1
Lcar7set2:
	mov	carYcounter,45
	sub	dx,45
	dec	cx
	cmp	cx,0
	je	Lcar7set 	
	dec	carXcounter
	cmp	carXcounter,0
	je	set7end
	jmp	Lcar7set1
set7end:	
	ret				
	car7set endp



car1 proc	;�e��l�����l�A�q�̥��W�����k�U���e	
	mov	cx,car1x
	mov	dx,55
	mov	carYcounter,45	;���l�j�p��45*45
	mov	carXcounter,45	
Lcar0:
	call	colortest ;�I��C��
	WrPixel cx,dx,carcolor
	inc	dx 	;�V�U�e
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar1
	jmp	Lcar0	
Lcar1:
	mov	carYcounter,45
	sub	dx,45
	inc	cx	;�V�k�e
	dec	carXcounter	
	cmp	carXcounter,0
	je	Lcar2
	jmp	Lcar0

Lcar2:
	mov	car1x,cx	;�Nx�y�Чאּ�̥k��A�]����1 3 5 7�����ʬO�q�k�W�����U�e
	ret				
	car1 endp



car2 proc	;�P��1�A�u��y�y��
	mov	cx,car2x
	mov	dx,110
	mov	carYcounter,45
	mov	carXcounter,45
Lcar20:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar21
	jmp	Lcar20	
Lcar21:
	mov	carYcounter,45
	sub	dx,45
	inc	cx 	
	dec	carXcounter
	cmp	carXcounter,0
	je	Lcar22
	jmp	Lcar20

Lcar22:
	mov	car2x,cx
	ret
	car2 endp



car3 proc	;�P��1�A�u��y�y��
	mov	cx,car3x
	mov	dx,165
	mov	carYcounter,45
	mov	carXcounter,45
Lcar30:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar31
	jmp	Lcar30	
Lcar31:
	mov	carYcounter,45
	sub	dx,45
	inc	cx 	
	dec	carXcounter
	cmp	carXcounter,0
	je	Lcar32
	jmp	Lcar30

Lcar32:	
	mov	car3x,cx
	ret
	car3 endp



car4 proc	;�P��1�A�u��y�y��
	mov	cx,car4x
	mov	dx,220
	mov	carYcounter,45
	mov	carXcounter,45
Lcar40:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar41
	jmp	Lcar40	
Lcar41:
	mov	carYcounter,45
	sub	dx,45
	inc	cx 	
	dec	carXcounter
	cmp	carXcounter,0
	je	Lcar42
	jmp	Lcar40

Lcar42:		
	mov	car4x,cx
	ret	
	car4 endp



car5 proc	;�P��1�A�u��y�y��
	mov	cx,car5x
	mov	dx,275
	mov	carYcounter,45
	mov	carXcounter,45
Lcar50:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar51
	jmp	Lcar50	
Lcar51:
	mov	carYcounter,45
	sub	dx,45
	inc	cx 	
	dec	carXcounter
	cmp	carXcounter,0
	je	Lcar52
	jmp	Lcar50

Lcar52:	
	mov	car5x,cx
	ret
	car5 endp



car6 proc	;�P��1�A�u��y�y��
	mov	cx,car6x
	mov	dx,330
	mov	carYcounter,45
	mov	carXcounter,45
Lcar60:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar61
	jmp	Lcar60	
Lcar61:
	mov	carYcounter,45
	sub	dx,45
	inc	cx 	
	dec	carXcounter
	cmp	carXcounter,0
	je	Lcar62
	jmp	Lcar60

Lcar62:	
	mov	car6x,cx
	ret
	car6 endp



car7 proc	;�P��1�A�u��y�y��
	mov	cx,car7x
	mov	dx,385
	mov	carYcounter,45
	mov	carXcounter,45
Lcar70:
	call	colortest 
	WrPixel cx,dx,carcolor
	inc	dx 	
	dec	carYcounter
	cmp	carYcounter,0
	je	Lcar71
	jmp	Lcar70	
Lcar71:
	mov	carYcounter,45
	sub	dx,45
	inc	cx 	
	dec	carXcounter
	cmp	carXcounter,0
	je	Lcar72
	jmp	Lcar70

Lcar72:	
	mov	car7x,cx
	ret
	car7 endp




win	proc	;�F��̤W�h�ɡA�W�[�C�����סA�B���]�C���m
	mov	ax,440
	sub	ax,y
	add	score,ax	;���ƼW�[440
	add	car1speed,1	;���t+1
	add	car2speed,1
	add	car3speed,1
	add	car4speed,1
	add	car5speed,1
	add	car6speed,1
	add	car7speed,1
	add	virusspeed,1	;�r��t��+1
	call	delay
	ret
	win endp
printscore	proc	;���ƪ�4���10�i����16�i��o�H�L�X
	mov	dx,0h
	mov	bx,0ah
	div bx
	mov	cl,dl

	mov	dx,0h
	mov	bx,0ah
	div bx
	mov	ch,dl
	
	mov	ah,0h
	mov	bl,0ah
	div bl
	mov	bh,ah

	
	add	al,30h
	add	bh,30h
	add	ch,30h
	add	cl,30h

	PrintChar al
	PrintChar bh
	PrintChar ch
	PrintChar cl
	
	ret
	printscore endp

scan	proc
	mov	ah,06h
	mov	dl,0ffh
	int	21h
	ret
scan	 endp

Setback	proc	;���j�q���k
	mov	cx,0
	mov	dx,45
	add	counter1,8	;�@8�Ӥ��j�q

L0:
	WrPixel cx,dx,1111b
	inc	dx 
	dec	counter0	;���j�q�e��10
	cmp	counter0,0
	je	L1
	jmp	L0
L1:
	mov	counter0,10
	sub	dx,10
	inc	cx
	cmp	cx,641	;���j�q�q0�e��640
	je	L3
	jmp	L0
L3:
	mov	cx,0
	add	dx,55	;�U�@�C�����j�q
	dec	counter1
	cmp	counter1,0
	je	L4
	jmp	L0
L4:	
	ret
	Setback	 endp


colortest	proc	;����O�_�I��C��
	mov	ah,0dh
	mov	bh,00h
	int	10h	;����e��m���C��
	cmp	al,1010b	;�I��C��h�����
	je	failset

colortestend:	
	ret
failset:
	mov	fail,1
	mov	ax,440
	sub	ax,y	;�]�w���ƨ�����440���t��
	add	score,ax	;�]�w����
	colortest endp



delay	proc	;delay�Ʋ[��
	mov	cx,1000h
L8:
	mov	bp,8000h
L9:
	dec	bp
	cmp	bp,0
	jnz	L9
	loop	L8
	ret
delay endp
end	main


