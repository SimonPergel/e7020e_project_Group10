
rtic_bare7d:	file format elf32-littlearm

Disassembly of section .text:

00000100 <__stext>:
     100: f001 fff5    	bl	0x20ee <rtt_init_must_not_be_called_multiple_times> @ imm = #0x1fea
     104: 480e         	ldr	r0, [pc, #0x38]         @ 0x140 <__stext+0x40>
     106: 490f         	ldr	r1, [pc, #0x3c]         @ 0x144 <__stext+0x44>
     108: 2200         	movs	r2, #0x0
     10a: 4281         	cmp	r1, r0
     10c: d001         	beq	0x112 <__stext+0x12>    @ imm = #0x2
     10e: c004         	stm	r0!, {r2}
     110: e7fb         	b	0x10a <__stext+0xa>     @ imm = #-0xa
     112: 480d         	ldr	r0, [pc, #0x34]         @ 0x148 <__stext+0x48>
     114: 490d         	ldr	r1, [pc, #0x34]         @ 0x14c <__stext+0x4c>
     116: 4a0e         	ldr	r2, [pc, #0x38]         @ 0x150 <__stext+0x50>
     118: 4281         	cmp	r1, r0
     11a: d002         	beq	0x122 <__stext+0x22>    @ imm = #0x4
     11c: ca08         	ldm	r2!, {r3}
     11e: c008         	stm	r0!, {r3}
     120: e7fa         	b	0x118 <__stext+0x18>    @ imm = #-0xc
     122: 480c         	ldr	r0, [pc, #0x30]         @ 0x154 <__stext+0x54>
     124: f44f 0170    	mov.w	r1, #0xf00000
     128: 6802         	ldr	r2, [r0]
     12a: ea42 0201    	orr.w	r2, r2, r1
     12e: 6002         	str	r2, [r0]
     130: f3bf 8f4f    	dsb	sy
     134: f3bf 8f6f    	isb	sy
     138: f000 ff4e    	bl	0xfd8 <main>            @ imm = #0xe9c
     13c: de00         	udf	#0x0
     13e: 0000         	movs	r0, r0
     140: 20 00 00 20  	.word	0x20000020
     144: 90 04 00 20  	.word	0x20000490
     148: 00 00 00 20  	.word	0x20000000
     14c: 20 00 00 20  	.word	0x20000020
     150: 80 33 00 00  	.word	0x00003380
     154: 88 ed 00 e0  	.word	0xe000ed88

00000158 <SysTick>:
     158: b5f0         	push	{r4, r5, r6, r7, lr}
     15a: af03         	add	r7, sp, #0xc
     15c: e92d 0f00    	push.w	{r8, r9, r10, r11}
     160: f24e 0b10    	movw	r11, #0xe010
     164: f240 0900    	movw	r9, #0x0
     168: f240 4e50    	movw	lr, #0x450
     16c: f2ce 0b00    	movt	r11, #0xe000
     170: f2c2 0900    	movt	r9, #0x2000
     174: f64f 7aff    	movw	r10, #0xffff
     178: f2c2 0e00    	movt	lr, #0x2000
     17c: f44f 7880    	mov.w	r8, #0x100
     180: e001         	b	0x186 <SysTick+0x2e>    @ imm = #0x2
     182: f8cb 81f0    	str.w	r8, [r11, #0x1f0]
     186: f3ef 8c10    	mrs	r12, primask
     18a: b672         	cpsid i
     18c: f8b9 0018    	ldrh.w	r0, [r9, #0x18]
     190: 4550         	cmp	r0, r10
     192: d119         	bne	0x1c8 <SysTick+0x70>    @ imm = #0x32
     194: 2400         	movs	r4, #0x0
     196: ea5f 70cc    	lsls.w	r0, r12, #0x1f
     19a: d100         	bne	0x19e <SysTick+0x46>    @ imm = #0x0
     19c: b662         	cpsie i
     19e: f3ef 8310    	mrs	r3, primask
     1a2: b672         	cpsid i
     1a4: 2c00         	cmp	r4, #0x0
     1a6: d06e         	beq	0x286 <SysTick+0x12e>   @ imm = #0xdc
     1a8: f8de 001c    	ldr.w	r0, [lr, #0x1c]
     1ac: eb0e 0200    	add.w	r2, lr, r0
     1b0: f080 0001    	eor	r0, r0, #0x1
     1b4: f882 1020    	strb.w	r1, [r2, #0x20]
     1b8: f3bf 8f5f    	dmb	sy
     1bc: f8ce 001c    	str.w	r0, [lr, #0x1c]
     1c0: 07d8         	lsls	r0, r3, #0x1f
     1c2: d1de         	bne	0x182 <SysTick+0x2a>    @ imm = #-0x44
     1c4: b662         	cpsie i
     1c6: e7dc         	b	0x182 <SysTick+0x2a>    @ imm = #-0x48
     1c8: e9d9 4500    	ldrd	r4, r5, [r9]
     1cc: f8db 0000    	ldr.w	r0, [r11]
     1d0: e9de 1304    	ldrd	r1, r3, [lr, #16]
     1d4: 03c0         	lsls	r0, r0, #0xf
     1d6: d504         	bpl	0x1e2 <SysTick+0x8a>    @ imm = #0x8
     1d8: 3101         	adds	r1, #0x1
     1da: f143 0300    	adc	r3, r3, #0x0
     1de: e9ce 1304    	strd	r1, r3, [lr, #16]
     1e2: ea84 0001    	eor.w	r0, r4, r1
     1e6: ea85 0203    	eor.w	r2, r5, r3
     1ea: ea40 0602    	orr.w	r6, r0, r2
     1ee: 1a60         	subs	r0, r4, r1
     1f0: eb65 0203    	sbc.w	r2, r5, r3
     1f4: b3a6         	cbz	r6, 0x260 <SysTick+0x108> @ imm = #0x68
     1f6: f1b0 30ff    	subs.w	r0, r0, #0xffffffff
     1fa: f06f 4000    	mvn	r0, #0x80000000
     1fe: eb72 0000    	sbcs.w	r0, r2, r0
     202: d22d         	bhs	0x260 <SysTick+0x108>   @ imm = #0x5a
     204: f8db 0000    	ldr.w	r0, [r11]
     208: f44f 7a80    	mov.w	r10, #0x100
     20c: 03c0         	lsls	r0, r0, #0xf
     20e: d408         	bmi	0x222 <SysTick+0xca>    @ imm = #0x10
     210: f04f 0800    	mov.w	r8, #0x0
     214: f1b8 0f00    	cmp.w	r8, #0x0
     218: 46d0         	mov	r8, r10
     21a: f64f 7aff    	movw	r10, #0xffff
     21e: d019         	beq	0x254 <SysTick+0xfc>    @ imm = #0x32
     220: e01e         	b	0x260 <SysTick+0x108>   @ imm = #0x3c
     222: 3101         	adds	r1, #0x1
     224: f06f 0601    	mvn	r6, #0x1
     228: f143 0300    	adc	r3, r3, #0x0
     22c: 1a60         	subs	r0, r4, r1
     22e: eb65 0203    	sbc.w	r2, r5, r3
     232: 1a30         	subs	r0, r6, r0
     234: f06f 4000    	mvn	r0, #0x80000000
     238: f04f 0800    	mov.w	r8, #0x0
     23c: e9ce 1304    	strd	r1, r3, [lr, #16]
     240: 4190         	sbcs	r0, r2
     242: bf38         	it	lo
     244: f04f 0801    	movlo.w	r8, #0x1
     248: f1b8 0f00    	cmp.w	r8, #0x0
     24c: 46d0         	mov	r8, r10
     24e: f64f 7aff    	movw	r10, #0xffff
     252: d105         	bne	0x260 <SysTick+0x108>   @ imm = #0xa
     254: ea84 0001    	eor.w	r0, r4, r1
     258: ea85 0103    	eor.w	r1, r5, r3
     25c: 4308         	orrs	r0, r1
     25e: d199         	bne	0x194 <SysTick+0x3c>    @ imm = #-0xce
     260: f8b9 2010    	ldrh.w	r2, [r9, #0x10]
     264: 2401         	movs	r4, #0x1
     266: f8b9 001a    	ldrh.w	r0, [r9, #0x1a]
     26a: f8a9 2018    	strh.w	r2, [r9, #0x18]
     26e: 2200         	movs	r2, #0x0
     270: f899 100c    	ldrb.w	r1, [r9, #0xc]
     274: f8a9 201a    	strh.w	r2, [r9, #0x1a]
     278: f8a9 0010    	strh.w	r0, [r9, #0x10]
     27c: ea5f 70cc    	lsls.w	r0, r12, #0x1f
     280: f43f af8c    	beq.w	0x19c <SysTick+0x44>    @ imm = #-0xe8
     284: e78b         	b	0x19e <SysTick+0x46>    @ imm = #-0xea
     286: f89e 0000    	ldrb.w	r0, [lr]
     28a: 2801         	cmp	r0, #0x1
     28c: d10a         	bne	0x2a4 <SysTick+0x14c>   @ imm = #0x14
     28e: f8db 0000    	ldr.w	r0, [r11]
     292: 03c0         	lsls	r0, r0, #0xf
     294: d506         	bpl	0x2a4 <SysTick+0x14c>   @ imm = #0xc
     296: e9de 0104    	ldrd	r0, r1, [lr, #16]
     29a: 3001         	adds	r0, #0x1
     29c: f141 0100    	adc	r1, r1, #0x0
     2a0: e9ce 0104    	strd	r0, r1, [lr, #16]
     2a4: 07d8         	lsls	r0, r3, #0x1f
     2a6: d100         	bne	0x2aa <SysTick+0x152>   @ imm = #0x0
     2a8: b662         	cpsie i
     2aa: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
     2ae: bdf0         	pop	{r4, r5, r6, r7, pc}

000002b0 <TIMER0>:
     2b0: b5f0         	push	{r4, r5, r6, r7, lr}
     2b2: af03         	add	r7, sp, #0xc
     2b4: e92d 0f00    	push.w	{r8, r9, r10, r11}
     2b8: b099         	sub	sp, #0x64
     2ba: f240 4650    	movw	r6, #0x450
     2be: f2c2 0600    	movt	r6, #0x2000
     2c2: 69b0         	ldr	r0, [r6, #0x18]
     2c4: 69f1         	ldr	r1, [r6, #0x1c]
     2c6: f3bf 8f5f    	dmb	sy
     2ca: 4288         	cmp	r0, r1
     2cc: f000 80e5    	beq.w	0x49a <TIMER0+0x1ea>    @ imm = #0x1ca
     2d0: f10d 0a38    	add.w	r10, sp, #0x38
     2d4: f04f 0800    	mov.w	r8, #0x0
     2d8: f10a 0904    	add.w	r9, r10, #0x4
     2dc: 25fa         	movs	r5, #0xfa
     2de: f080 0001    	eor	r0, r0, #0x1
     2e2: f3bf 8f5f    	dmb	sy
     2e6: 61b0         	str	r0, [r6, #0x18]
     2e8: f240 4090    	movw	r0, #0x490
     2ec: f2c2 0000    	movt	r0, #0x2000
     2f0: e9d0 1000    	ldrd	r1, r0, [r0]
     2f4: f1b0 3fff    	cmp.w	r0, #0xffffffff
     2f8: 6ab2         	ldr	r2, [r6, #0x28]
     2fa: eb06 0302    	add.w	r3, r6, r2
     2fe: f082 0201    	eor	r2, r2, #0x1
     302: f883 802c    	strb.w	r8, [r3, #0x2c]
     306: f3bf 8f5f    	dmb	sy
     30a: 62b2         	str	r2, [r6, #0x28]
     30c: f240 4298    	movw	r2, #0x498
     310: e9cd 1004    	strd	r1, r0, [sp, #16]
     314: f2c2 0200    	movt	r2, #0x2000
     318: 9203         	str	r2, [sp, #0xc]
     31a: f106 0204    	add.w	r2, r6, #0x4
     31e: 9202         	str	r2, [sp, #0x8]
     320: f340 80de    	ble.w	0x4e0 <TIMER0+0x230>    @ imm = #0x1bc
     324: fba1 1205    	umull	r1, r2, r1, r5
     328: fba0 0305    	umull	r0, r3, r0, r5
     32c: 1880         	adds	r0, r0, r2
     32e: f148 0200    	adc	r2, r8, #0x0
     332: 2b00         	cmp	r3, #0x0
     334: bf18         	it	ne
     336: 2301         	movne	r3, #0x1
     338: 431a         	orrs	r2, r3
     33a: 2a01         	cmp	r2, #0x1
     33c: f000 80b4    	beq.w	0x4a8 <TIMER0+0x1f8>    @ imm = #0x168
     340: e9cd 1006    	strd	r1, r0, [sp, #24]
     344: f640 70af    	movw	r0, #0xfaf
     348: f2c0 0000    	movt	r0, #0x0
     34c: 900d         	str	r0, [sp, #0x34]
     34e: a806         	add	r0, sp, #0x18
     350: 900c         	str	r0, [sp, #0x30]
     352: f640 6055    	movw	r0, #0xe55
     356: f2c0 0000    	movt	r0, #0x0
     35a: 900b         	str	r0, [sp, #0x2c]
     35c: a804         	add	r0, sp, #0x10
     35e: 900a         	str	r0, [sp, #0x28]
     360: f640 5051    	movw	r0, #0xd51
     364: f2c0 0000    	movt	r0, #0x0
     368: 9009         	str	r0, [sp, #0x24]
     36a: a802         	add	r0, sp, #0x8
     36c: 9008         	str	r0, [sp, #0x20]
     36e: f3ef 8b10    	mrs	r11, primask
     372: b672         	cpsid i
     374: 6b30         	ldr	r0, [r6, #0x30]
     376: 2800         	cmp	r0, #0x0
     378: f040 80a1    	bne.w	0x4be <TIMER0+0x20e>    @ imm = #0x142
     37c: 6b70         	ldr	r0, [r6, #0x34]
     37e: f04f 31ff    	mov.w	r1, #0xffffffff
     382: 6331         	str	r1, [r6, #0x30]
     384: 2801         	cmp	r0, #0x1
     386: d152         	bne	0x42e <TIMER0+0x17e>    @ imm = #0xa4
     388: 6bb0         	ldr	r0, [r6, #0x38]
     38a: 68c1         	ldr	r1, [r0, #0xc]
     38c: f3bf 8f5f    	dmb	sy
     390: 6902         	ldr	r2, [r0, #0x10]
     392: f3bf 8f5f    	dmb	sy
     396: 6883         	ldr	r3, [r0, #0x8]
     398: 4299         	cmp	r1, r3
     39a: bf38         	it	lo
     39c: 429a         	cmplo	r2, r3
     39e: d30a         	blo	0x3b6 <TIMER0+0x106>    @ imm = #0x14
     3a0: 2100         	movs	r1, #0x0
     3a2: f3bf 8f5f    	dmb	sy
     3a6: 60c1         	str	r1, [r0, #0xc]
     3a8: f3bf 8f5f    	dmb	sy
     3ac: f3bf 8f5f    	dmb	sy
     3b0: 6101         	str	r1, [r0, #0x10]
     3b2: f3bf 8f5f    	dmb	sy
     3b6: f896 203c    	ldrb.w	r2, [r6, #0x3c]
     3ba: f88d 805c    	strb.w	r8, [sp, #0x5c]
     3be: f8cd 8058    	str.w	r8, [sp, #0x58]
     3c2: e9cd 0114    	strd	r0, r1, [sp, #80]
     3c6: b1a2         	cbz	r2, 0x3f2 <TIMER0+0x142> @ imm = #0x28
     3c8: 6bb0         	ldr	r0, [r6, #0x38]
     3ca: f243 01ff    	movw	r1, #0x30ff
     3ce: f1a7 021e    	sub.w	r2, r7, #0x1e
     3d2: 2302         	movs	r3, #0x2
     3d4: 6940         	ldr	r0, [r0, #0x14]
     3d6: f3bf 8f5f    	dmb	sy
     3da: f827 1c1e    	strh	r1, [r7, #-30]
     3de: f000 0103    	and	r1, r0, #0x3
     3e2: a814         	add	r0, sp, #0x50
     3e4: 2902         	cmp	r1, #0x2
     3e6: bf18         	it	ne
     3e8: 2100         	movne	r1, #0x0
     3ea: f001 ffe2    	bl	0x23b2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538> @ imm = #0x1fc4
     3ee: f886 803c    	strb.w	r8, [r6, #0x3c]
     3f2: ab14         	add	r3, sp, #0x50
     3f4: f88d 804c    	strb.w	r8, [sp, #0x4c]
     3f8: cb0f         	ldm	r3, {r0, r1, r2, r3}
     3fa: e889 000f    	stm.w	r9, {r0, r1, r2, r3}
     3fe: f243 3144    	movw	r1, #0x3344
     402: f642 7248    	movw	r2, #0x2f48
     406: f106 003c    	add.w	r0, r6, #0x3c
     40a: ab08         	add	r3, sp, #0x20
     40c: 900e         	str	r0, [sp, #0x38]
     40e: 4650         	mov	r0, r10
     410: f2c0 0100    	movt	r1, #0x0
     414: f2c0 0200    	movt	r2, #0x0
     418: f000 fe07    	bl	0x102a <core::fmt::write::h47398c8a992ac39d> @ imm = #0xc0e
     41c: f89d 0048    	ldrb.w	r0, [sp, #0x48]
     420: 2802         	cmp	r0, #0x2
     422: d10a         	bne	0x43a <TIMER0+0x18a>    @ imm = #0x14
     424: 980e         	ldr	r0, [sp, #0x38]
     426: f89d 104c    	ldrb.w	r1, [sp, #0x4c]
     42a: 7001         	strb	r1, [r0]
     42c: e00c         	b	0x448 <TIMER0+0x198>    @ imm = #0x18
     42e: 2000         	movs	r0, #0x0
     430: 6330         	str	r0, [r6, #0x30]
     432: ea5f 70cb    	lsls.w	r0, r11, #0x1f
     436: d00d         	beq	0x454 <TIMER0+0x1a4>    @ imm = #0x1a
     438: e00d         	b	0x456 <TIMER0+0x1a6>    @ imm = #0x1a
     43a: e9dd 010f    	ldrd	r0, r1, [sp, #60]
     43e: f3bf 8f5f    	dmb	sy
     442: 60c1         	str	r1, [r0, #0xc]
     444: f3bf 8f5f    	dmb	sy
     448: 6b30         	ldr	r0, [r6, #0x30]
     44a: 3001         	adds	r0, #0x1
     44c: 6330         	str	r0, [r6, #0x30]
     44e: ea5f 70cb    	lsls.w	r0, r11, #0x1f
     452: d100         	bne	0x456 <TIMER0+0x1a6>    @ imm = #0x0
     454: b662         	cpsie i
     456: e9dd 4002    	ldrd	r4, r0, [sp, #8]
     45a: 7800         	ldrb	r0, [r0]
     45c: 7821         	ldrb	r1, [r4]
     45e: 07c9         	lsls	r1, r1, #0x1f
     460: d102         	bne	0x468 <TIMER0+0x1b8>    @ imm = #0x4
     462: f000 fb85    	bl	0xb70 <rtic_bare7d::led::led_on::h808275ab66bf54f9> @ imm = #0x70a
     466: e001         	b	0x46c <TIMER0+0x1bc>    @ imm = #0x2
     468: f000 fba0    	bl	0xbac <rtic_bare7d::led::led_off::he4377f9fdc2d123d> @ imm = #0x740
     46c: 6820         	ldr	r0, [r4]
     46e: 3001         	adds	r0, #0x1
     470: d241         	bhs	0x4f6 <TIMER0+0x246>    @ imm = #0x82
     472: 6020         	str	r0, [r4]
     474: e9dd 0104    	ldrd	r0, r1, [sp, #16]
     478: 1d02         	adds	r2, r0, #0x4
     47a: 4650         	mov	r0, r10
     47c: f141 0300    	adc	r3, r1, #0x0
     480: e9cd 2300    	strd	r2, r3, [sp]
     484: f000 f83d    	bl	0x502 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668> @ imm = #0x7a
     488: 980e         	ldr	r0, [sp, #0x38]
     48a: b9f0         	cbnz	r0, 0x4ca <TIMER0+0x21a> @ imm = #0x3c
     48c: 69b0         	ldr	r0, [r6, #0x18]
     48e: 69f1         	ldr	r1, [r6, #0x1c]
     490: f3bf 8f5f    	dmb	sy
     494: 4288         	cmp	r0, r1
     496: f47f af22    	bne.w	0x2de <TIMER0+0x2e>     @ imm = #-0x1bc
     49a: 2000         	movs	r0, #0x0
     49c: f380 8811    	msr	basepri, r0
     4a0: b019         	add	sp, #0x64
     4a2: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
     4a6: bdf0         	pop	{r4, r5, r6, r7, pc}
     4a8: f243 1020    	movw	r0, #0x3120
     4ac: f243 1230    	movw	r2, #0x3130
     4b0: f2c0 0000    	movt	r0, #0x0
     4b4: f2c0 0200    	movt	r2, #0x0
     4b8: 211f         	movs	r1, #0x1f
     4ba: f000 ff54    	bl	0x1366 <core::panicking::panic_fmt::ha5c8d1aa6e35ad31> @ imm = #0xea8
     4be: f243 306c    	movw	r0, #0x336c
     4c2: f2c0 0000    	movt	r0, #0x0
     4c6: f001 fdb3    	bl	0x2030 <core::cell::panic_already_borrowed::h855985b225273df1> @ imm = #0x1b66
     4ca: e9dd 0110    	ldrd	r0, r1, [sp, #64]
     4ce: e9cd 0108    	strd	r0, r1, [sp, #32]
     4d2: f243 01f0    	movw	r1, #0x30f0
     4d6: a808         	add	r0, sp, #0x20
     4d8: f2c0 0100    	movt	r1, #0x0
     4dc: f001 fdca    	bl	0x2074 <core::result::unwrap_failed::h7d9f4b8669bb5e40> @ imm = #0x1b94
     4e0: f243 104c    	movw	r0, #0x314c
     4e4: f243 1210    	movw	r2, #0x3110
     4e8: f2c0 0000    	movt	r0, #0x0
     4ec: f2c0 0200    	movt	r2, #0x0
     4f0: 2131         	movs	r1, #0x31
     4f2: f000 ff38    	bl	0x1366 <core::panicking::panic_fmt::ha5c8d1aa6e35ad31> @ imm = #0xe70
     4f6: f243 00e0    	movw	r0, #0x30e0
     4fa: f2c0 0000    	movt	r0, #0x0
     4fe: f001 fddf    	bl	0x20c0 <core::panicking::panic_const::panic_const_add_overflow::h4ff4e8f08191f960> @ imm = #0x1bbe

00000502 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668>:
     502: b5f0         	push	{r4, r5, r6, r7, lr}
     504: af03         	add	r7, sp, #0xc
     506: e92d 0700    	push.w	{r8, r9, r10}
     50a: f240 4950    	movw	r9, #0x450
     50e: f3ef 8510    	mrs	r5, primask
     512: b672         	cpsid i
     514: f2c2 0900    	movt	r9, #0x2000
     518: f8d9 1024    	ldr.w	r1, [r9, #0x24]
     51c: f8d9 6028    	ldr.w	r6, [r9, #0x28]
     520: f3bf 8f5f    	dmb	sy
     524: 42b1         	cmp	r1, r6
     526: d14a         	bne	0x5be <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0xbc> @ imm = #0x94
     528: 07ed         	lsls	r5, r5, #0x1f
     52a: d155         	bne	0x5d8 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0xd6> @ imm = #0xaa
     52c: b662         	cpsie i
     52e: e9d7 5c02    	ldrd	r5, r12, [r7, #8]
     532: 42b1         	cmp	r1, r6
     534: d054         	beq	0x5e0 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0xde> @ imm = #0xa8
     536: f240 4690    	movw	r6, #0x490
     53a: fa5f f188    	uxtb.w	r1, r8
     53e: f2c2 0600    	movt	r6, #0x2000
     542: f64f 7aff    	movw	r10, #0xffff
     546: f846 5031    	str.w	r5, [r6, r1, lsl #3]
     54a: eb06 01c1    	add.w	r1, r6, r1, lsl #3
     54e: f8c1 c004    	str.w	r12, [r1, #0x4]
     552: f240 0100    	movw	r1, #0x0
     556: f2c2 0100    	movt	r1, #0x2000
     55a: f3ef 8c10    	mrs	r12, primask
     55e: b672         	cpsid i
     560: f8d9 e008    	ldr.w	lr, [r9, #0x8]
     564: 8b0d         	ldrh	r5, [r1, #0x18]
     566: f899 6000    	ldrb.w	r6, [r9]
     56a: f10e 0401    	add.w	r4, lr, #0x1
     56e: f8c9 4008    	str.w	r4, [r9, #0x8]
     572: 2e01         	cmp	r6, #0x1
     574: d13b         	bne	0x5ee <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0xec> @ imm = #0x76
     576: 4555         	cmp	r5, r10
     578: d05b         	beq	0x632 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x130> @ imm = #0xb6
     57a: e9d1 5600    	ldrd	r5, r6, [r1]
     57e: 1b55         	subs	r5, r2, r5
     580: eb73 0506    	sbcs.w	r5, r3, r6
     584: d455         	bmi	0x632 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x130> @ imm = #0xaa
     586: 8b4d         	ldrh	r5, [r1, #0x1a]
     588: eb05 0545    	add.w	r5, r5, r5, lsl #1
     58c: f841 2035    	str.w	r2, [r1, r5, lsl #3]
     590: eb01 05c5    	add.w	r5, r1, r5, lsl #3
     594: f8d1 9000    	ldr.w	r9, [r1]
     598: e9c5 3e01    	strd	r3, lr, [r5, #4]
     59c: 684c         	ldr	r4, [r1, #0x4]
     59e: ebb9 0202    	subs.w	r2, r9, r2
     5a2: 8a2e         	ldrh	r6, [r5, #0x10]
     5a4: eb64 0203    	sbc.w	r2, r4, r3
     5a8: f885 800c    	strb.w	r8, [r5, #0xc]
     5ac: f1b2 3fff    	cmp.w	r2, #0xffffffff
     5b0: 834e         	strh	r6, [r1, #0x1a]
     5b2: dc3b         	bgt	0x62c <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x12a> @ imm = #0x76
     5b4: 8a0a         	ldrh	r2, [r1, #0x10]
     5b6: 4552         	cmp	r2, r10
     5b8: f000 809a    	beq.w	0x6f0 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1ee> @ imm = #0x134
     5bc: e7fe         	b	0x5bc <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0xba> @ imm = #-0x4
     5be: f109 0424    	add.w	r4, r9, #0x24
     5c2: 440c         	add	r4, r1
     5c4: f894 8008    	ldrb.w	r8, [r4, #0x8]
     5c8: f3bf 8f5f    	dmb	sy
     5cc: f081 0401    	eor	r4, r1, #0x1
     5d0: f8c9 4024    	str.w	r4, [r9, #0x24]
     5d4: 07ed         	lsls	r5, r5, #0x1f
     5d6: d0a9         	beq	0x52c <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x2a> @ imm = #-0xae
     5d8: e9d7 5c02    	ldrd	r5, r12, [r7, #8]
     5dc: 42b1         	cmp	r1, r6
     5de: d1aa         	bne	0x536 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x34> @ imm = #-0xac
     5e0: 2101         	movs	r1, #0x1
     5e2: e9c0 5c02    	strd	r5, r12, [r0, #8]
     5e6: 6001         	str	r1, [r0]
     5e8: e8bd 0700    	pop.w	{r8, r9, r10}
     5ec: bdf0         	pop	{r4, r5, r6, r7, pc}
     5ee: 4555         	cmp	r5, r10
     5f0: d043         	beq	0x67a <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x178> @ imm = #0x86
     5f2: e9d1 4500    	ldrd	r4, r5, [r1]
     5f6: 1b14         	subs	r4, r2, r4
     5f8: eb73 0405    	sbcs.w	r4, r3, r5
     5fc: d43d         	bmi	0x67a <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x178> @ imm = #0x7a
     5fe: 8b4c         	ldrh	r4, [r1, #0x1a]
     600: eb04 0444    	add.w	r4, r4, r4, lsl #1
     604: eb01 05c4    	add.w	r5, r1, r4, lsl #3
     608: f841 2034    	str.w	r2, [r1, r4, lsl #3]
     60c: f8d1 9000    	ldr.w	r9, [r1]
     610: e9c5 3e01    	strd	r3, lr, [r5, #4]
     614: 684c         	ldr	r4, [r1, #0x4]
     616: ebb9 0202    	subs.w	r2, r9, r2
     61a: 8a2e         	ldrh	r6, [r5, #0x10]
     61c: eb64 0203    	sbc.w	r2, r4, r3
     620: f885 800c    	strb.w	r8, [r5, #0xc]
     624: f1b2 3fff    	cmp.w	r2, #0xffffffff
     628: 834e         	strh	r6, [r1, #0x1a]
     62a: dd5e         	ble	0x6ea <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1e8> @ imm = #0xbc
     62c: 2200         	movs	r2, #0x0
     62e: 822a         	strh	r2, [r5, #0x10]
     630: e049         	b	0x6c6 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1c4> @ imm = #0x92
     632: f64e 5404    	movw	r4, #0xed04
     636: f04f 6580    	mov.w	r5, #0x4000000
     63a: f2ce 0400    	movt	r4, #0xe000
     63e: 6025         	str	r5, [r4]
     640: 8b4c         	ldrh	r4, [r1, #0x1a]
     642: eb04 0444    	add.w	r4, r4, r4, lsl #1
     646: eb01 06c4    	add.w	r6, r1, r4, lsl #3
     64a: f841 2034    	str.w	r2, [r1, r4, lsl #3]
     64e: 6073         	str	r3, [r6, #0x4]
     650: 8b0d         	ldrh	r5, [r1, #0x18]
     652: 8a34         	ldrh	r4, [r6, #0x10]
     654: 4555         	cmp	r5, r10
     656: f886 800c    	strb.w	r8, [r6, #0xc]
     65a: f8c6 e008    	str.w	lr, [r6, #0x8]
     65e: 834c         	strh	r4, [r1, #0x1a]
     660: d023         	beq	0x6aa <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1a8> @ imm = #0x46
     662: e9d1 4500    	ldrd	r4, r5, [r1]
     666: 1aa2         	subs	r2, r4, r2
     668: eb65 0203    	sbc.w	r2, r5, r3
     66c: f1b2 3fff    	cmp.w	r2, #0xffffffff
     670: dc27         	bgt	0x6c2 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1c0> @ imm = #0x4e
     672: 8a0a         	ldrh	r2, [r1, #0x10]
     674: 4552         	cmp	r2, r10
     676: d034         	beq	0x6e2 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1e0> @ imm = #0x68
     678: e7fe         	b	0x678 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x176> @ imm = #-0x4
     67a: f64e 5404    	movw	r4, #0xed04
     67e: f04f 6580    	mov.w	r5, #0x4000000
     682: f2ce 0400    	movt	r4, #0xe000
     686: 6025         	str	r5, [r4]
     688: 8b4c         	ldrh	r4, [r1, #0x1a]
     68a: eb04 0444    	add.w	r4, r4, r4, lsl #1
     68e: eb01 06c4    	add.w	r6, r1, r4, lsl #3
     692: f841 2034    	str.w	r2, [r1, r4, lsl #3]
     696: 6073         	str	r3, [r6, #0x4]
     698: 8b0d         	ldrh	r5, [r1, #0x18]
     69a: 8a34         	ldrh	r4, [r6, #0x10]
     69c: 4555         	cmp	r5, r10
     69e: f886 800c    	strb.w	r8, [r6, #0xc]
     6a2: f8c6 e008    	str.w	lr, [r6, #0x8]
     6a6: 834c         	strh	r4, [r1, #0x1a]
     6a8: d103         	bne	0x6b2 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1b0> @ imm = #0x6
     6aa: 2200         	movs	r2, #0x0
     6ac: f8a6 a010    	strh.w	r10, [r6, #0x10]
     6b0: e009         	b	0x6c6 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1c4> @ imm = #0x12
     6b2: e9d1 4500    	ldrd	r4, r5, [r1]
     6b6: 1aa2         	subs	r2, r4, r2
     6b8: eb65 0203    	sbc.w	r2, r5, r3
     6bc: f1b2 3fff    	cmp.w	r2, #0xffffffff
     6c0: dd0c         	ble	0x6dc <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1da> @ imm = #0x18
     6c2: 2200         	movs	r2, #0x0
     6c4: 8232         	strh	r2, [r6, #0x10]
     6c6: 830a         	strh	r2, [r1, #0x18]
     6c8: 2100         	movs	r1, #0x0
     6ca: e9c0 1e00    	strd	r1, lr, [r0]
     6ce: ea5f 70cc    	lsls.w	r0, r12, #0x1f
     6d2: d117         	bne	0x704 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x202> @ imm = #0x2e
     6d4: b662         	cpsie i
     6d6: e8bd 0700    	pop.w	{r8, r9, r10}
     6da: bdf0         	pop	{r4, r5, r6, r7, pc}
     6dc: 8a0a         	ldrh	r2, [r1, #0x10]
     6de: 4552         	cmp	r2, r10
     6e0: d102         	bne	0x6e8 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1e6> @ imm = #0x4
     6e2: f8a6 a010    	strh.w	r10, [r6, #0x10]
     6e6: e005         	b	0x6f4 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1f2> @ imm = #0xa
     6e8: e7fe         	b	0x6e8 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1e6> @ imm = #-0x4
     6ea: 8a0a         	ldrh	r2, [r1, #0x10]
     6ec: 4552         	cmp	r2, r10
     6ee: d10c         	bne	0x70a <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x208> @ imm = #0x18
     6f0: f8a5 a010    	strh.w	r10, [r5, #0x10]
     6f4: 2200         	movs	r2, #0x0
     6f6: 820a         	strh	r2, [r1, #0x10]
     6f8: 2100         	movs	r1, #0x0
     6fa: e9c0 1e00    	strd	r1, lr, [r0]
     6fe: ea5f 70cc    	lsls.w	r0, r12, #0x1f
     702: d0e7         	beq	0x6d4 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x1d2> @ imm = #-0x32
     704: e8bd 0700    	pop.w	{r8, r9, r10}
     708: bdf0         	pop	{r4, r5, r6, r7, pc}
     70a: e7fe         	b	0x70a <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668+0x208> @ imm = #-0x4

0000070c <rtic_bare7d::app::idle::h6711758c5946a6c6>:
     70c: b580         	push	{r7, lr}
     70e: 466f         	mov	r7, sp
     710: b084         	sub	sp, #0x10
     712: f642 6060    	movw	r0, #0x2e60
     716: 2105         	movs	r1, #0x5
     718: f2c0 0000    	movt	r0, #0x0
     71c: f001 ff6b    	bl	0x25f6 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c> @ imm = #0x1ed6
     720: f240 4650    	movw	r6, #0x450
     724: f04f 31ff    	mov.w	r1, #0xffffffff
     728: f2c2 0600    	movt	r6, #0x2000
     72c: f04f 0c00    	mov.w	r12, #0x0
     730: bf30         	wfi
     732: f3ef 8210    	mrs	r2, primask
     736: b672         	cpsid i
     738: 6b30         	ldr	r0, [r6, #0x30]
     73a: 2800         	cmp	r0, #0x0
     73c: f040 813f    	bne.w	0x9be <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2b2> @ imm = #0x27e
     740: 6b70         	ldr	r0, [r6, #0x34]
     742: 6331         	str	r1, [r6, #0x30]
     744: 2801         	cmp	r0, #0x1
     746: f040 8090    	bne.w	0x86a <rtic_bare7d::app::idle::h6711758c5946a6c6+0x15e> @ imm = #0x120
     74a: f8d6 9038    	ldr.w	r9, [r6, #0x38]
     74e: f8d9 800c    	ldr.w	r8, [r9, #0xc]
     752: f3bf 8f5f    	dmb	sy
     756: f8d9 0010    	ldr.w	r0, [r9, #0x10]
     75a: f3bf 8f5f    	dmb	sy
     75e: f8d9 1008    	ldr.w	r1, [r9, #0x8]
     762: 4588         	cmp	r8, r1
     764: bf38         	it	lo
     766: 4288         	cmplo	r0, r1
     768: d30d         	blo	0x786 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x7a> @ imm = #0x1a
     76a: f04f 0800    	mov.w	r8, #0x0
     76e: f3bf 8f5f    	dmb	sy
     772: f8c9 800c    	str.w	r8, [r9, #0xc]
     776: f3bf 8f5f    	dmb	sy
     77a: f3bf 8f5f    	dmb	sy
     77e: f8c9 8010    	str.w	r8, [r9, #0x10]
     782: f3bf 8f5f    	dmb	sy
     786: f896 003c    	ldrb.w	r0, [r6, #0x3c]
     78a: 9201         	str	r2, [sp, #0x4]
     78c: 2800         	cmp	r0, #0x0
     78e: f000 8088    	beq.w	0x8a2 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x196> @ imm = #0x110
     792: 6bb0         	ldr	r0, [r6, #0x38]
     794: f243 01ff    	movw	r1, #0x30ff
     798: f04f 0b02    	mov.w	r11, #0x2
     79c: f04f 0e00    	mov.w	lr, #0x0
     7a0: 6940         	ldr	r0, [r0, #0x14]
     7a2: f3bf 8f5f    	dmb	sy
     7a6: f827 1c02    	strh	r1, [r7, #-2]
     7aa: f000 0403    	and	r4, r0, #0x3
     7ae: 1eb8         	subs	r0, r7, #0x2
     7b0: 9002         	str	r0, [sp, #0x8]
     7b2: ea6f 0008    	mvn.w	r0, r8
     7b6: f8d9 300c    	ldr.w	r3, [r9, #0xc]
     7ba: f3bf 8f5f    	dmb	sy
     7be: f8d9 2010    	ldr.w	r2, [r9, #0x10]
     7c2: f3bf 8f5f    	dmb	sy
     7c6: f8d9 1008    	ldr.w	r1, [r9, #0x8]
     7ca: 428b         	cmp	r3, r1
     7cc: bf38         	it	lo
     7ce: 428a         	cmplo	r2, r1
     7d0: d313         	blo	0x7fa <rtic_bare7d::app::idle::h6711758c5946a6c6+0xee> @ imm = #0x26
     7d2: f3bf 8f5f    	dmb	sy
     7d6: f8c9 c00c    	str.w	r12, [r9, #0xc]
     7da: f3bf 8f5f    	dmb	sy
     7de: f3bf 8f5f    	dmb	sy
     7e2: f8c9 c010    	str.w	r12, [r9, #0x10]
     7e6: f3bf 8f5f    	dmb	sy
     7ea: 4541         	cmp	r1, r8
     7ec: f0c0 80ed    	blo.w	0x9ca <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2be> @ imm = #0x1da
     7f0: f000 80eb    	beq.w	0x9ca <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2be> @ imm = #0x1d6
     7f4: 180d         	adds	r5, r1, r0
     7f6: b16d         	cbz	r5, 0x814 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x108> @ imm = #0x1a
     7f8: e015         	b	0x826 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x11a> @ imm = #0x2a
     7fa: 4542         	cmp	r2, r8
     7fc: d902         	bls	0x804 <rtic_bare7d::app::idle::h6711758c5946a6c6+0xf8> @ imm = #0x4
     7fe: 1815         	adds	r5, r2, r0
     800: b145         	cbz	r5, 0x814 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x108> @ imm = #0x10
     802: e010         	b	0x826 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x11a> @ imm = #0x20
     804: 2a00         	cmp	r2, #0x0
     806: d0f0         	beq	0x7ea <rtic_bare7d::app::idle::h6711758c5946a6c6+0xde> @ imm = #-0x20
     808: 4541         	cmp	r1, r8
     80a: f0c0 80e4    	blo.w	0x9d6 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2ca> @ imm = #0x1c8
     80e: eba1 0508    	sub.w	r5, r1, r8
     812: b945         	cbnz	r5, 0x826 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x11a> @ imm = #0x10
     814: 2c02         	cmp	r4, #0x2
     816: d12e         	bne	0x876 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x16a> @ imm = #0x5c
     818: f3bf 8f5f    	dmb	sy
     81c: f8c9 800c    	str.w	r8, [r9, #0xc]
     820: f3bf 8f5f    	dmb	sy
     824: e7c7         	b	0x7b6 <rtic_bare7d::app::idle::h6711758c5946a6c6+0xaa> @ imm = #-0x72
     826: f8d9 0004    	ldr.w	r0, [r9, #0x4]
     82a: 45ab         	cmp	r11, r5
     82c: bf38         	it	lo
     82e: 465d         	movlo	r5, r11
     830: 9902         	ldr	r1, [sp, #0x8]
     832: 4440         	add	r0, r8
     834: 462a         	mov	r2, r5
     836: 46f2         	mov	r10, lr
     838: f001 ffc3    	bl	0x27c2 <__aeabi_memcpy> @ imm = #0x1f86
     83c: eb18 0805    	adds.w	r8, r8, r5
     840: f080 80d5    	bhs.w	0x9ee <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2e2> @ imm = #0x1aa
     844: eb1a 0e05    	adds.w	lr, r10, r5
     848: f04f 0c00    	mov.w	r12, #0x0
     84c: f080 80c9    	bhs.w	0x9e2 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2d6> @ imm = #0x192
     850: f8d9 1008    	ldr.w	r1, [r9, #0x8]
     854: 2000         	movs	r0, #0x0
     856: 4588         	cmp	r8, r1
     858: bf28         	it	hs
     85a: 4680         	movhs	r8, r0
     85c: 9902         	ldr	r1, [sp, #0x8]
     85e: ebbb 0b05    	subs.w	r11, r11, r5
     862: 4429         	add	r1, r5
     864: 9102         	str	r1, [sp, #0x8]
     866: d1a4         	bne	0x7b2 <rtic_bare7d::app::idle::h6711758c5946a6c6+0xa6> @ imm = #-0xb8
     868: e006         	b	0x878 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x16c> @ imm = #0xc
     86a: 2000         	movs	r0, #0x0
     86c: 6330         	str	r0, [r6, #0x30]
     86e: 07d0         	lsls	r0, r2, #0x1f
     870: f47f af5e    	bne.w	0x730 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x24> @ imm = #-0x144
     874: e0a1         	b	0x9ba <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2ae> @ imm = #0x142
     876: 2002         	movs	r0, #0x2
     878: f886 c03c    	strb.w	r12, [r6, #0x3c]
     87c: f243 224c    	movw	r2, #0x324c
     880: f8d9 1014    	ldr.w	r1, [r9, #0x14]
     884: f2c0 0200    	movt	r2, #0x0
     888: f001 0103    	and	r1, r1, #0x3
     88c: f852 b021    	ldr.w	r11, [r2, r1, lsl #2]
     890: f3bf 8f5f    	dmb	sy
     894: b198         	cbz	r0, 0x8be <rtic_bare7d::app::idle::h6711758c5946a6c6+0x1b2> @ imm = #0x26
     896: 2802         	cmp	r0, #0x2
     898: f040 8080    	bne.w	0x99c <rtic_bare7d::app::idle::h6711758c5946a6c6+0x290> @ imm = #0x100
     89c: f886 c03c    	strb.w	r12, [r6, #0x3c]
     8a0: e082         	b	0x9a8 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x29c> @ imm = #0x104
     8a2: f8d9 0014    	ldr.w	r0, [r9, #0x14]
     8a6: f243 214c    	movw	r1, #0x324c
     8aa: f3bf 8f5f    	dmb	sy
     8ae: f2c0 0100    	movt	r1, #0x0
     8b2: f000 0003    	and	r0, r0, #0x3
     8b6: f04f 0e00    	mov.w	lr, #0x0
     8ba: f851 b020    	ldr.w	r11, [r1, r0, lsl #2]
     8be: f642 6465    	movw	r4, #0x2e65
     8c2: f04f 0a05    	mov.w	r10, #0x5
     8c6: f2c0 0400    	movt	r4, #0x0
     8ca: ea6f 0008    	mvn.w	r0, r8
     8ce: f8d9 300c    	ldr.w	r3, [r9, #0xc]
     8d2: f3bf 8f5f    	dmb	sy
     8d6: f8d9 2010    	ldr.w	r2, [r9, #0x10]
     8da: f3bf 8f5f    	dmb	sy
     8de: f8d9 1008    	ldr.w	r1, [r9, #0x8]
     8e2: 428b         	cmp	r3, r1
     8e4: bf38         	it	lo
     8e6: 428a         	cmplo	r2, r1
     8e8: d311         	blo	0x90e <rtic_bare7d::app::idle::h6711758c5946a6c6+0x202> @ imm = #0x22
     8ea: f3bf 8f5f    	dmb	sy
     8ee: f8c9 c00c    	str.w	r12, [r9, #0xc]
     8f2: f3bf 8f5f    	dmb	sy
     8f6: f3bf 8f5f    	dmb	sy
     8fa: f8c9 c010    	str.w	r12, [r9, #0x10]
     8fe: f3bf 8f5f    	dmb	sy
     902: 4541         	cmp	r1, r8
     904: d361         	blo	0x9ca <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2be> @ imm = #0xc2
     906: d060         	beq	0x9ca <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2be> @ imm = #0xc0
     908: 180d         	adds	r5, r1, r0
     90a: b165         	cbz	r5, 0x926 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x21a> @ imm = #0x18
     90c: e01c         	b	0x948 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x23c> @ imm = #0x38
     90e: 4542         	cmp	r2, r8
     910: d902         	bls	0x918 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x20c> @ imm = #0x4
     912: 1815         	adds	r5, r2, r0
     914: b13d         	cbz	r5, 0x926 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x21a> @ imm = #0xe
     916: e017         	b	0x948 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x23c> @ imm = #0x2e
     918: 2a00         	cmp	r2, #0x0
     91a: d0f2         	beq	0x902 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x1f6> @ imm = #-0x1c
     91c: 4541         	cmp	r1, r8
     91e: d35a         	blo	0x9d6 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2ca> @ imm = #0xb4
     920: eba1 0508    	sub.w	r5, r1, r8
     924: b985         	cbnz	r5, 0x948 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x23c> @ imm = #0x20
     926: f1bb 0f02    	cmp.w	r11, #0x2
     92a: d106         	bne	0x93a <rtic_bare7d::app::idle::h6711758c5946a6c6+0x22e> @ imm = #0xc
     92c: f3bf 8f5f    	dmb	sy
     930: f8c9 800c    	str.w	r8, [r9, #0xc]
     934: f3bf 8f5f    	dmb	sy
     938: e7c9         	b	0x8ce <rtic_bare7d::app::idle::h6711758c5946a6c6+0x1c2> @ imm = #-0x6e
     93a: f1bb 0f00    	cmp.w	r11, #0x0
     93e: d0ad         	beq	0x89c <rtic_bare7d::app::idle::h6711758c5946a6c6+0x190> @ imm = #-0xa6
     940: 2600         	movs	r6, #0x0
     942: f8cd e008    	str.w	lr, [sp, #0x8]
     946: e005         	b	0x954 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x248> @ imm = #0xa
     948: 462e         	mov	r6, r5
     94a: f8cd e008    	str.w	lr, [sp, #0x8]
     94e: 45aa         	cmp	r10, r5
     950: bf38         	it	lo
     952: 4656         	movlo	r6, r10
     954: f8d9 0004    	ldr.w	r0, [r9, #0x4]
     958: 4621         	mov	r1, r4
     95a: 4632         	mov	r2, r6
     95c: 4440         	add	r0, r8
     95e: f001 ff30    	bl	0x27c2 <__aeabi_memcpy> @ imm = #0x1e60
     962: eb18 0806    	adds.w	r8, r8, r6
     966: d242         	bhs	0x9ee <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2e2> @ imm = #0x84
     968: f8dd e008    	ldr.w	lr, [sp, #0x8]
     96c: eb1e 0e06    	adds.w	lr, lr, r6
     970: d237         	bhs	0x9e2 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x2d6> @ imm = #0x6e
     972: f8d9 0008    	ldr.w	r0, [r9, #0x8]
     976: f04f 0c00    	mov.w	r12, #0x0
     97a: 4580         	cmp	r8, r0
     97c: bf28         	it	hs
     97e: 46e0         	movhs	r8, r12
     980: b145         	cbz	r5, 0x994 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x288> @ imm = #0x10
     982: 4434         	add	r4, r6
     984: ebba 0a06    	subs.w	r10, r10, r6
     988: f240 4650    	movw	r6, #0x450
     98c: f2c2 0600    	movt	r6, #0x2000
     990: d19b         	bne	0x8ca <rtic_bare7d::app::idle::h6711758c5946a6c6+0x1be> @ imm = #-0xca
     992: e003         	b	0x99c <rtic_bare7d::app::idle::h6711758c5946a6c6+0x290> @ imm = #0x6
     994: f240 4650    	movw	r6, #0x450
     998: f2c2 0600    	movt	r6, #0x2000
     99c: f3bf 8f5f    	dmb	sy
     9a0: f8c9 800c    	str.w	r8, [r9, #0xc]
     9a4: f3bf 8f5f    	dmb	sy
     9a8: 6b30         	ldr	r0, [r6, #0x30]
     9aa: f04f 31ff    	mov.w	r1, #0xffffffff
     9ae: 9a01         	ldr	r2, [sp, #0x4]
     9b0: 3001         	adds	r0, #0x1
     9b2: 6330         	str	r0, [r6, #0x30]
     9b4: 07d0         	lsls	r0, r2, #0x1f
     9b6: f47f aebb    	bne.w	0x730 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x24> @ imm = #-0x28a
     9ba: b662         	cpsie i
     9bc: e6b8         	b	0x730 <rtic_bare7d::app::idle::h6711758c5946a6c6+0x24> @ imm = #-0x290
     9be: f243 306c    	movw	r0, #0x336c
     9c2: f2c0 0000    	movt	r0, #0x0
     9c6: f001 fb33    	bl	0x2030 <core::cell::panic_already_borrowed::h855985b225273df1> @ imm = #0x1666
     9ca: f243 3034    	movw	r0, #0x3334
     9ce: f2c0 0000    	movt	r0, #0x0
     9d2: f001 fb7f    	bl	0x20d4 <core::panicking::panic_const::panic_const_sub_overflow::hba89adce49baa796> @ imm = #0x16fe
     9d6: f243 3024    	movw	r0, #0x3324
     9da: f2c0 0000    	movt	r0, #0x0
     9de: f001 fb79    	bl	0x20d4 <core::panicking::panic_const::panic_const_sub_overflow::hba89adce49baa796> @ imm = #0x16f2
     9e2: f243 3014    	movw	r0, #0x3314
     9e6: f2c0 0000    	movt	r0, #0x0
     9ea: f001 fb69    	bl	0x20c0 <core::panicking::panic_const::panic_const_add_overflow::h4ff4e8f08191f960> @ imm = #0x16d2
     9ee: f243 3004    	movw	r0, #0x3304
     9f2: f2c0 0000    	movt	r0, #0x0
     9f6: f001 fb63    	bl	0x20c0 <core::panicking::panic_const::panic_const_add_overflow::h4ff4e8f08191f960> @ imm = #0x16c6

000009fa <rtic_bare7d::app::rtic_ext::main::__rtic_init_resources::h7b481745fdf278f9>:
     9fa: b5f0         	push	{r4, r5, r6, r7, lr}
     9fc: af03         	add	r7, sp, #0xc
     9fe: e92d 0b00    	push.w	{r8, r9, r11}
     a02: b088         	sub	sp, #0x20
     a04: f240 4950    	movw	r9, #0x450
     a08: 2001         	movs	r0, #0x1
     a0a: f2c2 0900    	movt	r9, #0x2000
     a0e: f889 0002    	strb.w	r0, [r9, #0x2]
     a12: f3ef 8110    	mrs	r1, primask
     a16: b672         	cpsid i
     a18: f899 2001    	ldrb.w	r2, [r9, #0x1]
     a1c: 2a00         	cmp	r2, #0x0
     a1e: f040 8094    	bne.w	0xb4a <rtic_bare7d::app::rtic_ext::main::__rtic_init_resources::h7b481745fdf278f9+0x150> @ imm = #0x128
     a22: f889 0001    	strb.w	r0, [r9, #0x1]
     a26: 07c8         	lsls	r0, r1, #0x1f
     a28: d100         	bne	0xa2c <rtic_bare7d::app::rtic_ext::main::__rtic_init_resources::h7b481745fdf278f9+0x32> @ imm = #0x0
     a2a: b662         	cpsie i
     a2c: f240 0420    	movw	r4, #0x20
     a30: 2130         	movs	r1, #0x30
     a32: f2c2 0400    	movt	r4, #0x2000
     a36: 4620         	mov	r0, r4
     a38: f001 fe6c    	bl	0x2714 <__aeabi_memclr4> @ imm = #0x1cd8
     a3c: f642 70d6    	movw	r0, #0x2fd6
     a40: 2100         	movs	r1, #0x0
     a42: f2c0 0000    	movt	r0, #0x0
     a46: 2254         	movs	r2, #0x54
     a48: 61a0         	str	r0, [r4, #0x18]
     a4a: f44f 6080    	mov.w	r0, #0x400
     a4e: 6220         	str	r0, [r4, #0x20]
     a50: 2320         	movs	r3, #0x20
     a52: 6ae0         	ldr	r0, [r4, #0x2c]
     a54: f3bf 8f5f    	dmb	sy
     a58: f3bf 8f5f    	dmb	sy
     a5c: f020 0003    	bic	r0, r0, #0x3
     a60: 62e0         	str	r0, [r4, #0x2c]
     a62: f240 0050    	movw	r0, #0x50
     a66: f3bf 8f5f    	dmb	sy
     a6a: f2c2 0000    	movt	r0, #0x2000
     a6e: 61e0         	str	r0, [r4, #0x1c]
     a70: 2001         	movs	r0, #0x1
     a72: 6120         	str	r0, [r4, #0x10]
     a74: 6161         	str	r1, [r4, #0x14]
     a76: 73e1         	strb	r1, [r4, #0xf]
     a78: 73a1         	strb	r1, [r4, #0xe]
     a7a: 7361         	strb	r1, [r4, #0xd]
     a7c: 7321         	strb	r1, [r4, #0xc]
     a7e: 72e1         	strb	r1, [r4, #0xb]
     a80: 72a1         	strb	r1, [r4, #0xa]
     a82: 7262         	strb	r2, [r4, #0x9]
     a84: 7222         	strb	r2, [r4, #0x8]
     a86: 2252         	movs	r2, #0x52
     a88: 71e2         	strb	r2, [r4, #0x7]
     a8a: 71a3         	strb	r3, [r4, #0x6]
     a8c: 2347         	movs	r3, #0x47
     a8e: 7162         	strb	r2, [r4, #0x5]
     a90: 2245         	movs	r2, #0x45
     a92: 7122         	strb	r2, [r4, #0x4]
     a94: 70e3         	strb	r3, [r4, #0x3]
     a96: 70a3         	strb	r3, [r4, #0x2]
     a98: 7062         	strb	r2, [r4, #0x1]
     a9a: 2253         	movs	r2, #0x53
     a9c: 7022         	strb	r2, [r4]
     a9e: f3ef 8210    	mrs	r2, primask
     aa2: b672         	cpsid i
     aa4: f8d9 3030    	ldr.w	r3, [r9, #0x30]
     aa8: 2b00         	cmp	r3, #0x0
     aaa: d150         	bne	0xb4e <rtic_bare7d::app::rtic_ext::main::__rtic_init_resources::h7b481745fdf278f9+0x154> @ imm = #0xa0
     aac: f889 103c    	strb.w	r1, [r9, #0x3c]
     ab0: f104 0118    	add.w	r1, r4, #0x18
     ab4: e9c9 010d    	strd	r0, r1, [r9, #52]
     ab8: 07d0         	lsls	r0, r2, #0x1f
     aba: d100         	bne	0xabe <rtic_bare7d::app::rtic_ext::main::__rtic_init_resources::h7b481745fdf278f9+0xc4> @ imm = #0x0
     abc: b662         	cpsie i
     abe: f243 0049    	movw	r0, #0x3049
     ac2: 210d         	movs	r1, #0xd
     ac4: f2c0 0000    	movt	r0, #0x0
     ac8: f04f 080d    	mov.w	r8, #0xd
     acc: f001 fd93    	bl	0x25f6 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c> @ imm = #0x1b26
     ad0: f24e 0610    	movw	r6, #0xe010
     ad4: f44f 5100    	mov.w	r1, #0x2000
     ad8: f2ce 0600    	movt	r6, #0xe000
     adc: 2400         	movs	r4, #0x0
     ade: 6830         	ldr	r0, [r6]
     ae0: 2300         	movs	r3, #0x0
     ae2: f020 0001    	bic	r0, r0, #0x1
     ae6: 6030         	str	r0, [r6]
     ae8: 6830         	ldr	r0, [r6]
     aea: f040 0004    	orr	r0, r0, #0x4
     aee: 6030         	str	r0, [r6]
     af0: f242 30ff    	movw	r0, #0x23ff
     af4: f2c0 00f4    	movt	r0, #0xf4
     af8: 6070         	str	r0, [r6, #0x4]
     afa: f240 500c    	movw	r0, #0x50c
     afe: f2c5 0000    	movt	r0, #0x5000
     b02: 6001         	str	r1, [r0]
     b04: 2103         	movs	r1, #0x3
     b06: f8c0 1228    	str.w	r1, [r0, #0x228]
     b0a: 6830         	ldr	r0, [r6]
     b0c: f3c0 4500    	ubfx	r5, r0, #0x10, #0x1
     b10: a802         	add	r0, sp, #0x8
     b12: 1d2a         	adds	r2, r5, #0x4
     b14: e9cd 2400    	strd	r2, r4, [sp]
     b18: f7ff fcf3    	bl	0x502 <rtic_bare7d::app::__rtic_internal_blink_MyMono_spawn_at::h5d56e084ae887668> @ imm = #-0x61a
     b1c: 9802         	ldr	r0, [sp, #0x8]
     b1e: b9e0         	cbnz	r0, 0xb5a <rtic_bare7d::app::rtic_ext::main::__rtic_init_resources::h7b481745fdf278f9+0x160> @ imm = #0x38
     b20: 60b4         	str	r4, [r6, #0x8]
     b22: f240 4198    	movw	r1, #0x498
     b26: 6830         	ldr	r0, [r6]
     b28: f2c2 0100    	movt	r1, #0x2000
     b2c: f881 8000    	strb.w	r8, [r1]
     b30: f040 0001    	orr	r0, r0, #0x1
     b34: 6030         	str	r0, [r6]
     b36: 2001         	movs	r0, #0x1
     b38: e9c9 5404    	strd	r5, r4, [r9, #16]
     b3c: f889 0000    	strb.w	r0, [r9]
     b40: b662         	cpsie i
     b42: b008         	add	sp, #0x20
     b44: e8bd 0b00    	pop.w	{r8, r9, r11}
     b48: bdf0         	pop	{r4, r5, r6, r7, pc}
     b4a: f000 fc1a    	bl	0x1382 <core::panicking::panic::h570881559fde6c15> @ imm = #0x834
     b4e: f243 305c    	movw	r0, #0x335c
     b52: f2c0 0000    	movt	r0, #0x0
     b56: f001 fa6b    	bl	0x2030 <core::cell::panic_already_borrowed::h855985b225273df1> @ imm = #0x14d6
     b5a: e9dd 0104    	ldrd	r0, r1, [sp, #16]
     b5e: e9cd 0106    	strd	r0, r1, [sp, #24]
     b62: f243 0194    	movw	r1, #0x3094
     b66: a806         	add	r0, sp, #0x18
     b68: f2c0 0100    	movt	r1, #0x0
     b6c: f001 fa82    	bl	0x2074 <core::result::unwrap_failed::h7d9f4b8669bb5e40> @ imm = #0x1504

00000b70 <rtic_bare7d::led::led_on::h808275ab66bf54f9>:
     b70: b5d0         	push	{r4, r6, r7, lr}
     b72: af02         	add	r7, sp, #0x8
     b74: 4604         	mov	r4, r0
     b76: f243 1000    	movw	r0, #0x3100
     b7a: f2c0 0000    	movt	r0, #0x0
     b7e: 2107         	movs	r1, #0x7
     b80: f001 fd39    	bl	0x25f6 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c> @ imm = #0x1a72
     b84: 06a1         	lsls	r1, r4, #0x1a
     b86: f240 500c    	movw	r0, #0x50c
     b8a: f004 011f    	and	r1, r4, #0x1f
     b8e: f2c5 0000    	movt	r0, #0x5000
     b92: f04f 0201    	mov.w	r2, #0x1
     b96: f500 7040    	add.w	r0, r0, #0x300
     b9a: fa02 f101    	lsl.w	r1, r2, r1
     b9e: bf5c         	itt	pl
     ba0: f240 500c    	movwpl	r0, #0x50c
     ba4: f2c5 0000    	movtpl	r0, #0x5000
     ba8: 6001         	str	r1, [r0]
     baa: bdd0         	pop	{r4, r6, r7, pc}

00000bac <rtic_bare7d::led::led_off::he4377f9fdc2d123d>:
     bac: b5d0         	push	{r4, r6, r7, lr}
     bae: af02         	add	r7, sp, #0x8
     bb0: 4604         	mov	r4, r0
     bb2: f243 1007    	movw	r0, #0x3107
     bb6: f2c0 0000    	movt	r0, #0x0
     bba: 2108         	movs	r1, #0x8
     bbc: f001 fd1b    	bl	0x25f6 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c> @ imm = #0x1a36
     bc0: 06a1         	lsls	r1, r4, #0x1a
     bc2: f240 5008    	movw	r0, #0x508
     bc6: f004 011f    	and	r1, r4, #0x1f
     bca: f2c5 0000    	movt	r0, #0x5000
     bce: f04f 0201    	mov.w	r2, #0x1
     bd2: f500 7040    	add.w	r0, r0, #0x300
     bd6: fa02 f101    	lsl.w	r1, r2, r1
     bda: bf5c         	itt	pl
     bdc: f240 5008    	movwpl	r0, #0x508
     be0: f2c5 0000    	movtpl	r0, #0x5000
     be4: 6001         	str	r1, [r0]
     be6: bdd0         	pop	{r4, r6, r7, pc}

00000be8 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d>:
     be8: b5f0         	push	{r4, r5, r6, r7, lr}
     bea: af03         	add	r7, sp, #0xc
     bec: f84d 8d04    	str	r8, [sp, #-4]!
     bf0: b086         	sub	sp, #0x18
     bf2: 688a         	ldr	r2, [r1, #0x8]
     bf4: 0193         	lsls	r3, r2, #0x6
     bf6: d408         	bmi	0xc0a <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x22> @ imm = #0x10
     bf8: 0152         	lsls	r2, r2, #0x5
     bfa: d449         	bmi	0xc90 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0xa8> @ imm = #0x92
     bfc: b006         	add	sp, #0x18
     bfe: f85d 8b04    	ldr	r8, [sp], #4
     c02: e8bd 40f0    	pop.w	{r4, r5, r6, r7, lr}
     c06: f000 bf88    	b.w	0x1b1a <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216> @ imm = #0xf10
     c0a: e9d0 0300    	ldrd	r0, r3, [r0]
     c0e: f243 283c    	movw	r8, #0x323c
     c12: f10d 0c08    	add.w	r12, sp, #0x8
     c16: f04f 0e10    	mov.w	lr, #0x10
     c1a: 2211         	movs	r2, #0x11
     c1c: f2c0 0800    	movt	r8, #0x0
     c20: f000 050f    	and	r5, r0, #0xf
     c24: f818 6005    	ldrb.w	r6, [r8, r5]
     c28: eb0c 0502    	add.w	r5, r12, r2
     c2c: f805 6c02    	strb	r6, [r5, #-2]
     c30: 0906         	lsrs	r6, r0, #0x4
     c32: ea46 7603    	orr.w	r6, r6, r3, lsl #28
     c36: ea56 1413    	orrs.w	r4, r6, r3, lsr #4
     c3a: d06c         	beq	0xd16 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x12e> @ imm = #0xd8
     c3c: f006 040f    	and	r4, r6, #0xf
     c40: f818 4004    	ldrb.w	r4, [r8, r4]
     c44: f805 4c03    	strb	r4, [r5, #-3]
     c48: 0a04         	lsrs	r4, r0, #0x8
     c4a: ea44 6603    	orr.w	r6, r4, r3, lsl #24
     c4e: ea56 2413    	orrs.w	r4, r6, r3, lsr #8
     c52: d064         	beq	0xd1e <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x136> @ imm = #0xc8
     c54: f006 040f    	and	r4, r6, #0xf
     c58: f818 4004    	ldrb.w	r4, [r8, r4]
     c5c: f805 4c04    	strb	r4, [r5, #-4]
     c60: 0b04         	lsrs	r4, r0, #0xc
     c62: ea44 5603    	orr.w	r6, r4, r3, lsl #20
     c66: ea56 3413    	orrs.w	r4, r6, r3, lsr #12
     c6a: d05c         	beq	0xd26 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x13e> @ imm = #0xb8
     c6c: f006 040f    	and	r4, r6, #0xf
     c70: 0c00         	lsrs	r0, r0, #0x10
     c72: ea40 4003    	orr.w	r0, r0, r3, lsl #16
     c76: 3a04         	subs	r2, #0x4
     c78: f818 4004    	ldrb.w	r4, [r8, r4]
     c7c: f1ae 0e04    	sub.w	lr, lr, #0x4
     c80: f805 4c05    	strb	r4, [r5, #-5]
     c84: ea50 4413    	orrs.w	r4, r0, r3, lsr #16
     c88: ea4f 4313    	lsr.w	r3, r3, #0x10
     c8c: d1c8         	bne	0xc20 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x38> @ imm = #-0x70
     c8e: e04d         	b	0xd2c <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x144> @ imm = #0x9a
     c90: e9d0 0300    	ldrd	r0, r3, [r0]
     c94: f243 282c    	movw	r8, #0x322c
     c98: f10d 0c08    	add.w	r12, sp, #0x8
     c9c: f04f 0e10    	mov.w	lr, #0x10
     ca0: 2211         	movs	r2, #0x11
     ca2: f2c0 0800    	movt	r8, #0x0
     ca6: f000 050f    	and	r5, r0, #0xf
     caa: f818 6005    	ldrb.w	r6, [r8, r5]
     cae: eb0c 0502    	add.w	r5, r12, r2
     cb2: f805 6c02    	strb	r6, [r5, #-2]
     cb6: 0906         	lsrs	r6, r0, #0x4
     cb8: ea46 7603    	orr.w	r6, r6, r3, lsl #28
     cbc: ea56 1413    	orrs.w	r4, r6, r3, lsr #4
     cc0: d029         	beq	0xd16 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x12e> @ imm = #0x52
     cc2: f006 040f    	and	r4, r6, #0xf
     cc6: f818 4004    	ldrb.w	r4, [r8, r4]
     cca: f805 4c03    	strb	r4, [r5, #-3]
     cce: 0a04         	lsrs	r4, r0, #0x8
     cd0: ea44 6603    	orr.w	r6, r4, r3, lsl #24
     cd4: ea56 2413    	orrs.w	r4, r6, r3, lsr #8
     cd8: d021         	beq	0xd1e <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x136> @ imm = #0x42
     cda: f006 040f    	and	r4, r6, #0xf
     cde: f818 4004    	ldrb.w	r4, [r8, r4]
     ce2: f805 4c04    	strb	r4, [r5, #-4]
     ce6: 0b04         	lsrs	r4, r0, #0xc
     ce8: ea44 5603    	orr.w	r6, r4, r3, lsl #20
     cec: ea56 3413    	orrs.w	r4, r6, r3, lsr #12
     cf0: d019         	beq	0xd26 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x13e> @ imm = #0x32
     cf2: f006 040f    	and	r4, r6, #0xf
     cf6: 0c00         	lsrs	r0, r0, #0x10
     cf8: ea40 4003    	orr.w	r0, r0, r3, lsl #16
     cfc: 3a04         	subs	r2, #0x4
     cfe: f818 4004    	ldrb.w	r4, [r8, r4]
     d02: f1ae 0e04    	sub.w	lr, lr, #0x4
     d06: f805 4c05    	strb	r4, [r5, #-5]
     d0a: ea50 4413    	orrs.w	r4, r0, r3, lsr #16
     d0e: ea4f 4313    	lsr.w	r3, r3, #0x10
     d12: d1c8         	bne	0xca6 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0xbe> @ imm = #-0x70
     d14: e00a         	b	0xd2c <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x144> @ imm = #0x14
     d16: f1a2 0e02    	sub.w	lr, r2, #0x2
     d1a: 3a01         	subs	r2, #0x1
     d1c: e006         	b	0xd2c <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x144> @ imm = #0xc
     d1e: f1ae 0e02    	sub.w	lr, lr, #0x2
     d22: 3a02         	subs	r2, #0x2
     d24: e002         	b	0xd2c <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d+0x144> @ imm = #0x4
     d26: f1ae 0e03    	sub.w	lr, lr, #0x3
     d2a: 3a03         	subs	r2, #0x3
     d2c: f1c2 0011    	rsb.w	r0, r2, #0x11
     d30: f243 225c    	movw	r2, #0x325c
     d34: eb0c 030e    	add.w	r3, r12, lr
     d38: f2c0 0200    	movt	r2, #0x0
     d3c: 9000         	str	r0, [sp]
     d3e: 4608         	mov	r0, r1
     d40: 4611         	mov	r1, r2
     d42: 2202         	movs	r2, #0x2
     d44: f000 f9f8    	bl	0x1138 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43> @ imm = #0x3f0
     d48: b006         	add	sp, #0x18
     d4a: f85d 8b04    	ldr	r8, [sp], #4
     d4e: bdf0         	pop	{r4, r5, r6, r7, pc}

00000d50 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46>:
     d50: b5b0         	push	{r4, r5, r7, lr}
     d52: af02         	add	r7, sp, #0x8
     d54: b084         	sub	sp, #0x10
     d56: 688a         	ldr	r2, [r1, #0x8]
     d58: 6800         	ldr	r0, [r0]
     d5a: 0193         	lsls	r3, r2, #0x6
     d5c: d406         	bmi	0xd6c <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0x1c> @ imm = #0xc
     d5e: 0152         	lsls	r2, r2, #0x5
     d60: d432         	bmi	0xdc8 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0x78> @ imm = #0x64
     d62: b004         	add	sp, #0x10
     d64: e8bd 40b0    	pop.w	{r4, r5, r7, lr}
     d68: f000 be53    	b.w	0x1a12 <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13> @ imm = #0xca6
     d6c: 6803         	ldr	r3, [r0]
     d6e: f243 2e3c    	movw	lr, #0x323c
     d72: f10d 0c08    	add.w	r12, sp, #0x8
     d76: 2008         	movs	r0, #0x8
     d78: 2209         	movs	r2, #0x9
     d7a: f2c0 0e00    	movt	lr, #0x0
     d7e: f003 040f    	and	r4, r3, #0xf
     d82: f81e 5004    	ldrb.w	r5, [lr, r4]
     d86: eb0c 0402    	add.w	r4, r12, r2
     d8a: f804 5c02    	strb	r5, [r4, #-2]
     d8e: 091d         	lsrs	r5, r3, #0x4
     d90: d048         	beq	0xe24 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xd4> @ imm = #0x90
     d92: f005 050f    	and	r5, r5, #0xf
     d96: f81e 5005    	ldrb.w	r5, [lr, r5]
     d9a: f804 5c03    	strb	r5, [r4, #-3]
     d9e: 0a1d         	lsrs	r5, r3, #0x8
     da0: d043         	beq	0xe2a <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xda> @ imm = #0x86
     da2: f005 050f    	and	r5, r5, #0xf
     da6: f81e 5005    	ldrb.w	r5, [lr, r5]
     daa: f804 5c04    	strb	r5, [r4, #-4]
     dae: 0b1d         	lsrs	r5, r3, #0xc
     db0: d03e         	beq	0xe30 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xe0> @ imm = #0x7c
     db2: f005 050f    	and	r5, r5, #0xf
     db6: 3a04         	subs	r2, #0x4
     db8: 3804         	subs	r0, #0x4
     dba: 0c1b         	lsrs	r3, r3, #0x10
     dbc: f81e 5005    	ldrb.w	r5, [lr, r5]
     dc0: f804 5c05    	strb	r5, [r4, #-5]
     dc4: d1db         	bne	0xd7e <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0x2e> @ imm = #-0x4a
     dc6: e035         	b	0xe34 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xe4> @ imm = #0x6a
     dc8: 6803         	ldr	r3, [r0]
     dca: f243 2e2c    	movw	lr, #0x322c
     dce: f10d 0c08    	add.w	r12, sp, #0x8
     dd2: 2008         	movs	r0, #0x8
     dd4: 2209         	movs	r2, #0x9
     dd6: f2c0 0e00    	movt	lr, #0x0
     dda: f003 040f    	and	r4, r3, #0xf
     dde: f81e 5004    	ldrb.w	r5, [lr, r4]
     de2: eb0c 0402    	add.w	r4, r12, r2
     de6: f804 5c02    	strb	r5, [r4, #-2]
     dea: 091d         	lsrs	r5, r3, #0x4
     dec: d01a         	beq	0xe24 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xd4> @ imm = #0x34
     dee: f005 050f    	and	r5, r5, #0xf
     df2: f81e 5005    	ldrb.w	r5, [lr, r5]
     df6: f804 5c03    	strb	r5, [r4, #-3]
     dfa: 0a1d         	lsrs	r5, r3, #0x8
     dfc: d015         	beq	0xe2a <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xda> @ imm = #0x2a
     dfe: f005 050f    	and	r5, r5, #0xf
     e02: f81e 5005    	ldrb.w	r5, [lr, r5]
     e06: f804 5c04    	strb	r5, [r4, #-4]
     e0a: 0b1d         	lsrs	r5, r3, #0xc
     e0c: d010         	beq	0xe30 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xe0> @ imm = #0x20
     e0e: f005 050f    	and	r5, r5, #0xf
     e12: 3a04         	subs	r2, #0x4
     e14: 3804         	subs	r0, #0x4
     e16: 0c1b         	lsrs	r3, r3, #0x10
     e18: f81e 5005    	ldrb.w	r5, [lr, r5]
     e1c: f804 5c05    	strb	r5, [r4, #-5]
     e20: d1db         	bne	0xdda <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0x8a> @ imm = #-0x4a
     e22: e007         	b	0xe34 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xe4> @ imm = #0xe
     e24: 1e90         	subs	r0, r2, #0x2
     e26: 3a01         	subs	r2, #0x1
     e28: e004         	b	0xe34 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xe4> @ imm = #0x8
     e2a: 3802         	subs	r0, #0x2
     e2c: 3a02         	subs	r2, #0x2
     e2e: e001         	b	0xe34 <<&mut T as core::fmt::Debug>::fmt::hbb33b4c7987d2e46+0xe4> @ imm = #0x2
     e30: 3803         	subs	r0, #0x3
     e32: 3a03         	subs	r2, #0x3
     e34: f1c2 0209    	rsb.w	r2, r2, #0x9
     e38: 9200         	str	r2, [sp]
     e3a: f243 225c    	movw	r2, #0x325c
     e3e: eb0c 0300    	add.w	r3, r12, r0
     e42: f2c0 0200    	movt	r2, #0x0
     e46: 4608         	mov	r0, r1
     e48: 4611         	mov	r1, r2
     e4a: 2202         	movs	r2, #0x2
     e4c: f000 f974    	bl	0x1138 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43> @ imm = #0x2e8
     e50: b004         	add	sp, #0x10
     e52: bdb0         	pop	{r4, r5, r7, pc}

00000e54 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b>:
     e54: b5f0         	push	{r4, r5, r6, r7, lr}
     e56: af03         	add	r7, sp, #0xc
     e58: e92d 0b00    	push.w	{r8, r9, r11}
     e5c: b088         	sub	sp, #0x20
     e5e: e9d1 6400    	ldrd	r6, r4, [r1]
     e62: 4689         	mov	r9, r1
     e64: f243 1140    	movw	r1, #0x3140
     e68: 68e5         	ldr	r5, [r4, #0xc]
     e6a: 4680         	mov	r8, r0
     e6c: f2c0 0100    	movt	r1, #0x0
     e70: 4630         	mov	r0, r6
     e72: 2207         	movs	r2, #0x7
     e74: 47a8         	blx	r5
     e76: b120         	cbz	r0, 0xe82 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0x2e> @ imm = #0x8
     e78: 2001         	movs	r0, #0x1
     e7a: b008         	add	sp, #0x20
     e7c: e8bd 0b00    	pop.w	{r8, r9, r11}
     e80: bdf0         	pop	{r4, r5, r6, r7, pc}
     e82: f899 000a    	ldrb.w	r0, [r9, #0xa]
     e86: 0600         	lsls	r0, r0, #0x18
     e88: d40d         	bmi	0xea6 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0x52> @ imm = #0x1a
     e8a: f243 2178    	movw	r1, #0x3278
     e8e: 4630         	mov	r0, r6
     e90: f2c0 0100    	movt	r1, #0x0
     e94: 2203         	movs	r2, #0x3
     e96: 47a8         	blx	r5
     e98: 2800         	cmp	r0, #0x0
     e9a: d046         	beq	0xf2a <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0xd6> @ imm = #0x8c
     e9c: 2001         	movs	r0, #0x1
     e9e: b008         	add	sp, #0x20
     ea0: e8bd 0b00    	pop.w	{r8, r9, r11}
     ea4: bdf0         	pop	{r4, r5, r6, r7, pc}
     ea6: f243 217d    	movw	r1, #0x327d
     eaa: 4630         	mov	r0, r6
     eac: f2c0 0100    	movt	r1, #0x0
     eb0: 2203         	movs	r2, #0x3
     eb2: 47a8         	blx	r5
     eb4: 4601         	mov	r1, r0
     eb6: 2001         	movs	r0, #0x1
     eb8: 2900         	cmp	r1, #0x0
     eba: d1de         	bne	0xe7a <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0x26> @ imm = #-0x44
     ebc: f1a7 0129    	sub.w	r1, r7, #0x29
     ec0: f807 0c29    	strb	r0, [r7, #-41]
     ec4: f243 2060    	movw	r0, #0x3260
     ec8: 9600         	str	r6, [sp]
     eca: e9cd 4101    	strd	r4, r1, [sp, #4]
     ece: f2c0 0000    	movt	r0, #0x0
     ed2: e9d9 6102    	ldrd	r6, r1, [r9, #8]
     ed6: 2205         	movs	r2, #0x5
     ed8: e9cd 6106    	strd	r6, r1, [sp, #24]
     edc: f243 1147    	movw	r1, #0x3147
     ee0: 9005         	str	r0, [sp, #0x14]
     ee2: 4668         	mov	r0, sp
     ee4: f2c0 0100    	movt	r1, #0x0
     ee8: 9004         	str	r0, [sp, #0x10]
     eea: f000 ff40    	bl	0x1d6e <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7> @ imm = #0xe80
     eee: b9b8         	cbnz	r0, 0xf20 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0xcc> @ imm = #0x2e
     ef0: f243 217b    	movw	r1, #0x327b
     ef4: 4668         	mov	r0, sp
     ef6: f2c0 0100    	movt	r1, #0x0
     efa: 2202         	movs	r2, #0x2
     efc: f000 ff37    	bl	0x1d6e <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7> @ imm = #0xe6e
     f00: b970         	cbnz	r0, 0xf20 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0xcc> @ imm = #0x1c
     f02: a904         	add	r1, sp, #0x10
     f04: 4640         	mov	r0, r8
     f06: f7ff fe6f    	bl	0xbe8 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d> @ imm = #-0x322
     f0a: b948         	cbnz	r0, 0xf20 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0xcc> @ imm = #0x12
     f0c: e9dd 0104    	ldrd	r0, r1, [sp, #16]
     f10: 2202         	movs	r2, #0x2
     f12: 68cb         	ldr	r3, [r1, #0xc]
     f14: f243 215e    	movw	r1, #0x325e
     f18: f2c0 0100    	movt	r1, #0x0
     f1c: 4798         	blx	r3
     f1e: b350         	cbz	r0, 0xf76 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0x122> @ imm = #0x54
     f20: 2001         	movs	r0, #0x1
     f22: b008         	add	sp, #0x20
     f24: e8bd 0b00    	pop.w	{r8, r9, r11}
     f28: bdf0         	pop	{r4, r5, r6, r7, pc}
     f2a: f243 1147    	movw	r1, #0x3147
     f2e: 4630         	mov	r0, r6
     f30: f2c0 0100    	movt	r1, #0x0
     f34: 2205         	movs	r2, #0x5
     f36: 47a8         	blx	r5
     f38: b120         	cbz	r0, 0xf44 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0xf0> @ imm = #0x8
     f3a: 2001         	movs	r0, #0x1
     f3c: b008         	add	sp, #0x20
     f3e: e8bd 0b00    	pop.w	{r8, r9, r11}
     f42: bdf0         	pop	{r4, r5, r6, r7, pc}
     f44: f243 217b    	movw	r1, #0x327b
     f48: 4630         	mov	r0, r6
     f4a: f2c0 0100    	movt	r1, #0x0
     f4e: 2202         	movs	r2, #0x2
     f50: 47a8         	blx	r5
     f52: b120         	cbz	r0, 0xf5e <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0x10a> @ imm = #0x8
     f54: 2001         	movs	r0, #0x1
     f56: b008         	add	sp, #0x20
     f58: e8bd 0b00    	pop.w	{r8, r9, r11}
     f5c: bdf0         	pop	{r4, r5, r6, r7, pc}
     f5e: 4640         	mov	r0, r8
     f60: 4649         	mov	r1, r9
     f62: f7ff fe41    	bl	0xbe8 <<&T as core::fmt::Debug>::fmt::hca24753d61db7a5d> @ imm = #-0x37e
     f66: b120         	cbz	r0, 0xf72 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0x11e> @ imm = #0x8
     f68: 2001         	movs	r0, #0x1
     f6a: b008         	add	sp, #0x20
     f6c: e8bd 0b00    	pop.w	{r8, r9, r11}
     f70: bdf0         	pop	{r4, r5, r6, r7, pc}
     f72: f8d9 6008    	ldr.w	r6, [r9, #0x8]
     f76: 0230         	lsls	r0, r6, #0x8
     f78: d40c         	bmi	0xf94 <<fugit::instant::Instant<T,_,_> as core::fmt::Debug>::fmt::haaeafd4910e9cc0b+0x140> @ imm = #0x18
     f7a: e9d9 0100    	ldrd	r0, r1, [r9]
     f7e: 2202         	movs	r2, #0x2
     f80: 68cb         	ldr	r3, [r1, #0xc]
     f82: f243 2181    	movw	r1, #0x3281
     f86: f2c0 0100    	movt	r1, #0x0
     f8a: 4798         	blx	r3
     f8c: b008         	add	sp, #0x20
     f8e: e8bd 0b00    	pop.w	{r8, r9, r11}
     f92: bdf0         	pop	{r4, r5, r6, r7, pc}
     f94: e9d9 0100    	ldrd	r0, r1, [r9]
     f98: 2201         	movs	r2, #0x1
     f9a: 68cb         	ldr	r3, [r1, #0xc]
     f9c: f243 2180    	movw	r1, #0x3280
     fa0: f2c0 0100    	movt	r1, #0x0
     fa4: 4798         	blx	r3
     fa6: b008         	add	sp, #0x20
     fa8: e8bd 0b00    	pop.w	{r8, r9, r11}
     fac: bdf0         	pop	{r4, r5, r6, r7, pc}

00000fae <<fugit::duration::Duration<u64,_,_> as core::fmt::Display>::fmt::h7ab3bfc65e51b64a>:
     fae: b580         	push	{r7, lr}
     fb0: 466f         	mov	r7, sp
     fb2: b082         	sub	sp, #0x8
     fb4: f641 321b    	movw	r2, #0x1b1b
     fb8: e9d1 c100    	ldrd	r12, r1, [r1]
     fbc: f2c0 0200    	movt	r2, #0x0
     fc0: 466b         	mov	r3, sp
     fc2: e9cd 0200    	strd	r0, r2, [sp]
     fc6: f243 0243    	movw	r2, #0x3043
     fca: f2c0 0200    	movt	r2, #0x0
     fce: 4660         	mov	r0, r12
     fd0: f000 f82b    	bl	0x102a <core::fmt::write::h47398c8a992ac39d> @ imm = #0x56
     fd4: b002         	add	sp, #0x8
     fd6: bd80         	pop	{r7, pc}

00000fd8 <main>:
     fd8: b580         	push	{r7, lr}
     fda: 466f         	mov	r7, sp
     fdc: f240 4050    	movw	r0, #0x450
     fe0: b672         	cpsid i
     fe2: f2c2 0000    	movt	r0, #0x2000
     fe6: 2300         	movs	r3, #0x0
     fe8: 6a81         	ldr	r1, [r0, #0x28]
     fea: 1842         	adds	r2, r0, r1
     fec: f081 0101    	eor	r1, r1, #0x1
     ff0: f882 302c    	strb.w	r3, [r2, #0x2c]
     ff4: f3bf 8f5f    	dmb	sy
     ff8: 6281         	str	r1, [r0, #0x28]
     ffa: f24e 0010    	movw	r0, #0xe010
     ffe: 21e0         	movs	r1, #0xe0
    1000: f2ce 0000    	movt	r0, #0xe000
    1004: f880 13f8    	strb.w	r1, [r0, #0x3f8]
    1008: f44f 7180    	mov.w	r1, #0x100
    100c: f8c0 10f0    	str.w	r1, [r0, #0xf0]
    1010: f64e 5123    	movw	r1, #0xed23
    1014: f2ce 0100    	movt	r1, #0xe000
    1018: 700b         	strb	r3, [r1]
    101a: 6801         	ldr	r1, [r0]
    101c: f041 0102    	orr	r1, r1, #0x2
    1020: 6001         	str	r1, [r0]
    1022: f7ff fcea    	bl	0x9fa <rtic_bare7d::app::rtic_ext::main::__rtic_init_resources::h7b481745fdf278f9> @ imm = #-0x62c
    1026: f7ff fb71    	bl	0x70c <rtic_bare7d::app::idle::h6711758c5946a6c6> @ imm = #-0x91e

0000102a <core::fmt::write::h47398c8a992ac39d>:
    102a: b5f0         	push	{r4, r5, r6, r7, lr}
    102c: af03         	add	r7, sp, #0xc
    102e: e92d 0f00    	push.w	{r8, r9, r10, r11}
    1032: b085         	sub	sp, #0x14
    1034: 4606         	mov	r6, r0
    1036: 469b         	mov	r11, r3
    1038: 468a         	mov	r10, r1
    103a: 07d8         	lsls	r0, r3, #0x1f
    103c: d164         	bne	0x1108 <core::fmt::write::h47398c8a992ac39d+0xde> @ imm = #0xc8
    103e: 7815         	ldrb	r5, [r2]
    1040: 2000         	movs	r0, #0x0
    1042: 2d00         	cmp	r5, #0x0
    1044: d06e         	beq	0x1124 <core::fmt::write::h47398c8a992ac39d+0xfa> @ imm = #0xdc
    1046: f8da 900c    	ldr.w	r9, [r10, #0xc]
    104a: f04f 0800    	mov.w	r8, #0x0
    104e: e002         	b	0x1056 <core::fmt::write::h47398c8a992ac39d+0x2c> @ imm = #0x4
    1050: 7815         	ldrb	r5, [r2]
    1052: 2d00         	cmp	r5, #0x0
    1054: d06a         	beq	0x112c <core::fmt::write::h47398c8a992ac39d+0x102> @ imm = #0xd4
    1056: 1c54         	adds	r4, r2, #0x1
    1058: b268         	sxtb	r0, r5
    105a: f1b0 3fff    	cmp.w	r0, #0xffffffff
    105e: dd07         	ble	0x1070 <core::fmt::write::h47398c8a992ac39d+0x46> @ imm = #0xe
    1060: 4630         	mov	r0, r6
    1062: 4621         	mov	r1, r4
    1064: 462a         	mov	r2, r5
    1066: 47c8         	blx	r9
    1068: 2800         	cmp	r0, #0x0
    106a: d15a         	bne	0x1122 <core::fmt::write::h47398c8a992ac39d+0xf8> @ imm = #0xb4
    106c: 1962         	adds	r2, r4, r5
    106e: e7ef         	b	0x1050 <core::fmt::write::h47398c8a992ac39d+0x26> @ imm = #-0x22
    1070: 2d80         	cmp	r5, #0x80
    1072: d009         	beq	0x1088 <core::fmt::write::h47398c8a992ac39d+0x5e> @ imm = #0x12
    1074: 2dc0         	cmp	r5, #0xc0
    1076: d112         	bne	0x109e <core::fmt::write::h47398c8a992ac39d+0x74> @ imm = #0x24
    1078: f85b 0038    	ldr.w	r0, [r11, r8, lsl #3]
    107c: 2100         	movs	r1, #0x0
    107e: 9104         	str	r1, [sp, #0x10]
    1080: 2120         	movs	r1, #0x20
    1082: f2c6 0100    	movt	r1, #0x6000
    1086: e031         	b	0x10ec <core::fmt::write::h47398c8a992ac39d+0xc2> @ imm = #0x62
    1088: f8b2 4001    	ldrh.w	r4, [r2, #0x1]
    108c: 1cd5         	adds	r5, r2, #0x3
    108e: 4630         	mov	r0, r6
    1090: 4629         	mov	r1, r5
    1092: 4622         	mov	r2, r4
    1094: 47c8         	blx	r9
    1096: 2800         	cmp	r0, #0x0
    1098: d143         	bne	0x1122 <core::fmt::write::h47398c8a992ac39d+0xf8> @ imm = #0x86
    109a: 192a         	adds	r2, r5, r4
    109c: e7d8         	b	0x1050 <core::fmt::write::h47398c8a992ac39d+0x26> @ imm = #-0x50
    109e: 07e8         	lsls	r0, r5, #0x1f
    10a0: d103         	bne	0x10aa <core::fmt::write::h47398c8a992ac39d+0x80> @ imm = #0x6
    10a2: 2120         	movs	r1, #0x20
    10a4: f2c6 0100    	movt	r1, #0x6000
    10a8: e002         	b	0x10b0 <core::fmt::write::h47398c8a992ac39d+0x86> @ imm = #0x4
    10aa: f8d2 1001    	ldr.w	r1, [r2, #0x1]
    10ae: 1d54         	adds	r4, r2, #0x5
    10b0: 07a8         	lsls	r0, r5, #0x1e
    10b2: bf4c         	ite	mi
    10b4: f834 2b02    	ldrhmi	r2, [r4], #2
    10b8: 2200         	movpl	r2, #0x0
    10ba: 0768         	lsls	r0, r5, #0x1d
    10bc: bf4c         	ite	mi
    10be: f834 3b02    	ldrhmi	r3, [r4], #2
    10c2: 2300         	movpl	r3, #0x0
    10c4: 0728         	lsls	r0, r5, #0x1c
    10c6: bf48         	it	mi
    10c8: f834 8b02    	ldrhmi	r8, [r4], #2
    10cc: 06e8         	lsls	r0, r5, #0x1b
    10ce: bf44         	itt	mi
    10d0: eb0b 00c2    	addmi.w	r0, r11, r2, lsl #3
    10d4: 8882         	ldrhmi	r2, [r0, #0x4]
    10d6: 06a8         	lsls	r0, r5, #0x1a
    10d8: bf44         	itt	mi
    10da: eb0b 00c3    	addmi.w	r0, r11, r3, lsl #3
    10de: 8883         	ldrhmi	r3, [r0, #0x4]
    10e0: f85b 0038    	ldr.w	r0, [r11, r8, lsl #3]
    10e4: f8ad 3012    	strh.w	r3, [sp, #0x12]
    10e8: f8ad 2010    	strh.w	r2, [sp, #0x10]
    10ec: 9103         	str	r1, [sp, #0xc]
    10ee: eb0b 01c8    	add.w	r1, r11, r8, lsl #3
    10f2: f8cd a008    	str.w	r10, [sp, #0x8]
    10f6: 684a         	ldr	r2, [r1, #0x4]
    10f8: a901         	add	r1, sp, #0x4
    10fa: 9601         	str	r6, [sp, #0x4]
    10fc: 4790         	blx	r2
    10fe: b980         	cbnz	r0, 0x1122 <core::fmt::write::h47398c8a992ac39d+0xf8> @ imm = #0x20
    1100: f108 0801    	add.w	r8, r8, #0x1
    1104: 4622         	mov	r2, r4
    1106: e7a3         	b	0x1050 <core::fmt::write::h47398c8a992ac39d+0x26> @ imm = #-0xba
    1108: ea4f 035b    	lsr.w	r3, r11, #0x1
    110c: 4611         	mov	r1, r2
    110e: f8da c00c    	ldr.w	r12, [r10, #0xc]
    1112: 4630         	mov	r0, r6
    1114: 461a         	mov	r2, r3
    1116: b005         	add	sp, #0x14
    1118: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    111c: e8bd 40f0    	pop.w	{r4, r5, r6, r7, lr}
    1120: 4760         	bx	r12
    1122: 2001         	movs	r0, #0x1
    1124: b005         	add	sp, #0x14
    1126: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    112a: bdf0         	pop	{r4, r5, r6, r7, pc}
    112c: 2000         	movs	r0, #0x0
    112e: b005         	add	sp, #0x14
    1130: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    1134: bdf0         	pop	{r4, r5, r6, r7, pc}
    1136: d4d4         	bmi	0x10e2 <core::fmt::write::h47398c8a992ac39d+0xb8> @ imm = #-0x58

00001138 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43>:
    1138: b5f0         	push	{r4, r5, r6, r7, lr}
    113a: af03         	add	r7, sp, #0xc
    113c: e92d 0f00    	push.w	{r8, r9, r10, r11}
    1140: b087         	sub	sp, #0x1c
    1142: 6886         	ldr	r6, [r0, #0x8]
    1144: 460c         	mov	r4, r1
    1146: f8d7 a008    	ldr.w	r10, [r7, #0x8]
    114a: 4693         	mov	r11, r2
    114c: f416 1100    	ands	r1, r6, #0x200000
    1150: f04f 092b    	mov.w	r9, #0x2b
    1154: bf08         	it	eq
    1156: f44f 1988    	moveq.w	r9, #0x110000
    115a: eb0a 5551    	add.w	r5, r10, r1, lsr #21
    115e: 0231         	lsls	r1, r6, #0x8
    1160: d416         	bmi	0x1190 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x58> @ imm = #0x2c
    1162: 2400         	movs	r4, #0x0
    1164: f8b0 800c    	ldrh.w	r8, [r0, #0xc]
    1168: 4545         	cmp	r5, r8
    116a: d329         	blo	0x11c0 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x88> @ imm = #0x52
    116c: 461d         	mov	r5, r3
    116e: 4623         	mov	r3, r4
    1170: e9d0 4600    	ldrd	r4, r6, [r0]
    1174: 464a         	mov	r2, r9
    1176: 4631         	mov	r1, r6
    1178: f8cd b000    	str.w	r11, [sp]
    117c: 4620         	mov	r0, r4
    117e: f000 f8cf    	bl	0x1320 <core::fmt::Formatter::pad_integral::write_prefix::h84006ed563cb6a22> @ imm = #0x19e
    1182: 2800         	cmp	r0, #0x0
    1184: d04c         	beq	0x1220 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0xe8> @ imm = #0x98
    1186: 2001         	movs	r0, #0x1
    1188: b007         	add	sp, #0x1c
    118a: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    118e: bdf0         	pop	{r4, r5, r6, r7, pc}
    1190: 2100         	movs	r1, #0x0
    1192: f1bb 0f00    	cmp.w	r11, #0x0
    1196: d00e         	beq	0x11b6 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x7e> @ imm = #0x1c
    1198: f994 2000    	ldrsb.w	r2, [r4]
    119c: f112 0f41    	cmn.w	r2, #0x41
    11a0: bfc8         	it	gt
    11a2: 2101         	movgt	r1, #0x1
    11a4: f1bb 0f01    	cmp.w	r11, #0x1
    11a8: d005         	beq	0x11b6 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x7e> @ imm = #0xa
    11aa: f994 2001    	ldrsb.w	r2, [r4, #0x1]
    11ae: f112 0f41    	cmn.w	r2, #0x41
    11b2: bfc8         	it	gt
    11b4: 3101         	addgt	r1, #0x1
    11b6: 440d         	add	r5, r1
    11b8: f8b0 800c    	ldrh.w	r8, [r0, #0xc]
    11bc: 4545         	cmp	r5, r8
    11be: d2d5         	bhs	0x116c <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x34> @ imm = #-0x56
    11c0: 01f1         	lsls	r1, r6, #0x7
    11c2: e9cd a305    	strd	r10, r3, [sp, #20]
    11c6: d40d         	bmi	0x11e4 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0xac> @ imm = #0x1a
    11c8: f3c6 7141    	ubfx	r1, r6, #0x1d, #0x2
    11cc: 9404         	str	r4, [sp, #0x10]
    11ce: eba8 0c05    	sub.w	r12, r8, r5
    11d2: f36f 565f    	bfc	r6, #21, #11
    11d6: 2500         	movs	r5, #0x0
    11d8: e8df f001    	tbb	[pc, r1]
    11dc: 4d 02 4a 02  	.word	0x024a024d
    11e0: 4665         	mov	r5, r12
    11e2: e048         	b	0x1276 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x13e> @ imm = #0x90
    11e4: e9d0 2102    	ldrd	r2, r1, [r0, #8]
    11e8: 4623         	mov	r3, r4
    11ea: e9d0 a600    	ldrd	r10, r6, [r0]
    11ee: 9102         	str	r1, [sp, #0x8]
    11f0: 2100         	movs	r1, #0x0
    11f2: f6c9 71e0    	movt	r1, #0x9fe0
    11f6: 9203         	str	r2, [sp, #0xc]
    11f8: 4011         	ands	r1, r2
    11fa: 9004         	str	r0, [sp, #0x10]
    11fc: f041 5100    	orr	r1, r1, #0x20000000
    1200: 464a         	mov	r2, r9
    1202: f041 0130    	orr	r1, r1, #0x30
    1206: 6081         	str	r1, [r0, #0x8]
    1208: 4650         	mov	r0, r10
    120a: 4631         	mov	r1, r6
    120c: f8cd b000    	str.w	r11, [sp]
    1210: f000 f886    	bl	0x1320 <core::fmt::Formatter::pad_integral::write_prefix::h84006ed563cb6a22> @ imm = #0x10c
    1214: b170         	cbz	r0, 0x1234 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0xfc> @ imm = #0x1c
    1216: 2001         	movs	r0, #0x1
    1218: b007         	add	sp, #0x1c
    121a: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    121e: bdf0         	pop	{r4, r5, r6, r7, pc}
    1220: 68f3         	ldr	r3, [r6, #0xc]
    1222: 4620         	mov	r0, r4
    1224: 4629         	mov	r1, r5
    1226: 4652         	mov	r2, r10
    1228: b007         	add	sp, #0x1c
    122a: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    122e: e8bd 40f0    	pop.w	{r4, r5, r6, r7, lr}
    1232: 4718         	bx	r3
    1234: eba8 0005    	sub.w	r0, r8, r5
    1238: 2500         	movs	r5, #0x0
    123a: b284         	uxth	r4, r0
    123c: b2a8         	uxth	r0, r5
    123e: 42a0         	cmp	r0, r4
    1240: d20b         	bhs	0x125a <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x122> @ imm = #0x16
    1242: 6932         	ldr	r2, [r6, #0x10]
    1244: 4650         	mov	r0, r10
    1246: 2130         	movs	r1, #0x30
    1248: 4790         	blx	r2
    124a: 3501         	adds	r5, #0x1
    124c: 2800         	cmp	r0, #0x0
    124e: d0f5         	beq	0x123c <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x104> @ imm = #-0x16
    1250: 2001         	movs	r0, #0x1
    1252: b007         	add	sp, #0x1c
    1254: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    1258: bdf0         	pop	{r4, r5, r6, r7, pc}
    125a: e9dd 2105    	ldrd	r2, r1, [sp, #20]
    125e: 4650         	mov	r0, r10
    1260: 68f3         	ldr	r3, [r6, #0xc]
    1262: 4798         	blx	r3
    1264: b3d0         	cbz	r0, 0x12dc <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x1a4> @ imm = #0x74
    1266: 2001         	movs	r0, #0x1
    1268: b007         	add	sp, #0x1c
    126a: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    126e: bdf0         	pop	{r4, r5, r6, r7, pc}
    1270: fa1f f18c    	uxth.w	r1, r12
    1274: 084d         	lsrs	r5, r1, #0x1
    1276: e9d0 4800    	ldrd	r4, r8, [r0]
    127a: f04f 0a00    	mov.w	r10, #0x0
    127e: f8cd c00c    	str.w	r12, [sp, #0xc]
    1282: b2a8         	uxth	r0, r5
    1284: fa1f f18a    	uxth.w	r1, r10
    1288: 4281         	cmp	r1, r0
    128a: d20d         	bhs	0x12a8 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x170> @ imm = #0x1a
    128c: f8d8 2010    	ldr.w	r2, [r8, #0x10]
    1290: 4620         	mov	r0, r4
    1292: 4631         	mov	r1, r6
    1294: 4790         	blx	r2
    1296: f10a 0a01    	add.w	r10, r10, #0x1
    129a: 2800         	cmp	r0, #0x0
    129c: d0f1         	beq	0x1282 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x14a> @ imm = #-0x1e
    129e: 2001         	movs	r0, #0x1
    12a0: b007         	add	sp, #0x1c
    12a2: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    12a6: bdf0         	pop	{r4, r5, r6, r7, pc}
    12a8: f8cd b000    	str.w	r11, [sp]
    12ac: 4620         	mov	r0, r4
    12ae: 9b04         	ldr	r3, [sp, #0x10]
    12b0: 4641         	mov	r1, r8
    12b2: 464a         	mov	r2, r9
    12b4: f000 f834    	bl	0x1320 <core::fmt::Formatter::pad_integral::write_prefix::h84006ed563cb6a22> @ imm = #0x68
    12b8: b120         	cbz	r0, 0x12c4 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x18c> @ imm = #0x8
    12ba: 2001         	movs	r0, #0x1
    12bc: b007         	add	sp, #0x1c
    12be: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    12c2: bdf0         	pop	{r4, r5, r6, r7, pc}
    12c4: e9dd 2105    	ldrd	r2, r1, [sp, #20]
    12c8: 4620         	mov	r0, r4
    12ca: f8d8 300c    	ldr.w	r3, [r8, #0xc]
    12ce: 4798         	blx	r3
    12d0: b170         	cbz	r0, 0x12f0 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x1b8> @ imm = #0x1c
    12d2: 2001         	movs	r0, #0x1
    12d4: b007         	add	sp, #0x1c
    12d6: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    12da: bdf0         	pop	{r4, r5, r6, r7, pc}
    12dc: 9804         	ldr	r0, [sp, #0x10]
    12de: e9dd 2102    	ldrd	r2, r1, [sp, #8]
    12e2: e9c0 1202    	strd	r1, r2, [r0, #8]
    12e6: 2000         	movs	r0, #0x0
    12e8: b007         	add	sp, #0x1c
    12ea: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    12ee: bdf0         	pop	{r4, r5, r6, r7, pc}
    12f0: 9803         	ldr	r0, [sp, #0xc]
    12f2: 1b40         	subs	r0, r0, r5
    12f4: 2500         	movs	r5, #0x0
    12f6: fa1f f980    	uxth.w	r9, r0
    12fa: b2a8         	uxth	r0, r5
    12fc: 4548         	cmp	r0, r9
    12fe: d20a         	bhs	0x1316 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x1de> @ imm = #0x14
    1300: f8d8 2010    	ldr.w	r2, [r8, #0x10]
    1304: 4620         	mov	r0, r4
    1306: 4631         	mov	r1, r6
    1308: 4790         	blx	r2
    130a: 3501         	adds	r5, #0x1
    130c: 4601         	mov	r1, r0
    130e: 2001         	movs	r0, #0x1
    1310: 2900         	cmp	r1, #0x0
    1312: d0f2         	beq	0x12fa <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x1c2> @ imm = #-0x1c
    1314: e738         	b	0x1188 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43+0x50> @ imm = #-0x190
    1316: 2000         	movs	r0, #0x0
    1318: b007         	add	sp, #0x1c
    131a: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    131e: bdf0         	pop	{r4, r5, r6, r7, pc}

00001320 <core::fmt::Formatter::pad_integral::write_prefix::h84006ed563cb6a22>:
    1320: b5f0         	push	{r4, r5, r6, r7, lr}
    1322: af03         	add	r7, sp, #0xc
    1324: f84d 8d04    	str	r8, [sp, #-4]!
    1328: f8d7 8008    	ldr.w	r8, [r7, #0x8]
    132c: 461c         	mov	r4, r3
    132e: 460e         	mov	r6, r1
    1330: f5b2 1f88    	cmp.w	r2, #0x110000
    1334: d00a         	beq	0x134c <core::fmt::Formatter::pad_integral::write_prefix::h84006ed563cb6a22+0x2c> @ imm = #0x14
    1336: 6933         	ldr	r3, [r6, #0x10]
    1338: 4611         	mov	r1, r2
    133a: 4605         	mov	r5, r0
    133c: 4798         	blx	r3
    133e: 4601         	mov	r1, r0
    1340: 4628         	mov	r0, r5
    1342: b119         	cbz	r1, 0x134c <core::fmt::Formatter::pad_integral::write_prefix::h84006ed563cb6a22+0x2c> @ imm = #0x6
    1344: 2001         	movs	r0, #0x1
    1346: f85d 8b04    	ldr	r8, [sp], #4
    134a: bdf0         	pop	{r4, r5, r6, r7, pc}
    134c: b13c         	cbz	r4, 0x135e <core::fmt::Formatter::pad_integral::write_prefix::h84006ed563cb6a22+0x3e> @ imm = #0xe
    134e: 68f3         	ldr	r3, [r6, #0xc]
    1350: 4621         	mov	r1, r4
    1352: 4642         	mov	r2, r8
    1354: f85d 8b04    	ldr	r8, [sp], #4
    1358: e8bd 40f0    	pop.w	{r4, r5, r6, r7, lr}
    135c: 4718         	bx	r3
    135e: 2000         	movs	r0, #0x0
    1360: f85d 8b04    	ldr	r8, [sp], #4
    1364: bdf0         	pop	{r4, r5, r6, r7, pc}

00001366 <core::panicking::panic_fmt::ha5c8d1aa6e35ad31>:
    1366: b580         	push	{r7, lr}
    1368: 466f         	mov	r7, sp
    136a: b086         	sub	sp, #0x18
    136c: e9cd 0101    	strd	r0, r1, [sp, #4]
    1370: 2001         	movs	r0, #0x1
    1372: f8ad 0014    	strh.w	r0, [sp, #0x14]
    1376: a801         	add	r0, sp, #0x4
    1378: 9003         	str	r0, [sp, #0xc]
    137a: a803         	add	r0, sp, #0xc
    137c: 9204         	str	r2, [sp, #0x10]
    137e: f000 feb9    	bl	0x20f4 <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind> @ imm = #0xd72

00001382 <core::panicking::panic::h570881559fde6c15>:
    1382: b580         	push	{r7, lr}
    1384: 466f         	mov	r7, sp
    1386: f243 00a4    	movw	r0, #0x30a4
    138a: f243 02d0    	movw	r2, #0x30d0
    138e: f2c0 0000    	movt	r0, #0x0
    1392: f2c0 0200    	movt	r2, #0x0
    1396: 2157         	movs	r1, #0x57
    1398: f7ff ffe5    	bl	0x1366 <core::panicking::panic_fmt::ha5c8d1aa6e35ad31> @ imm = #-0x36

0000139c <<&T as core::fmt::Display>::fmt::h592d00faf32006f8>:
    139c: b580         	push	{r7, lr}
    139e: 466f         	mov	r7, sp
    13a0: 460b         	mov	r3, r1
    13a2: e9d0 1200    	ldrd	r1, r2, [r0]
    13a6: 4618         	mov	r0, r3
    13a8: e8bd 4080    	pop.w	{r7, lr}
    13ac: f000 b800    	b.w	0x13b0 <core::fmt::Formatter::pad::h4e7a8b950cefb40f> @ imm = #0x0

000013b0 <core::fmt::Formatter::pad::h4e7a8b950cefb40f>:
    13b0: b5f0         	push	{r4, r5, r6, r7, lr}
    13b2: af03         	add	r7, sp, #0xc
    13b4: e92d 0f00    	push.w	{r8, r9, r10, r11}
    13b8: b08d         	sub	sp, #0x34
    13ba: f8d0 b008    	ldr.w	r11, [r0, #0x8]
    13be: 4690         	mov	r8, r2
    13c0: 460c         	mov	r4, r1
    13c2: f01b 5fc0    	tst.w	r11, #0x18000000
    13c6: f000 8311    	beq.w	0x19ec <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x63c> @ imm = #0x622
    13ca: ea5f 01cb    	lsls.w	r1, r11, #0x3
    13ce: d43c         	bmi	0x144a <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x9a> @ imm = #0x78
    13d0: f1b8 0f10    	cmp.w	r8, #0x10
    13d4: d25a         	bhs	0x148c <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0xdc> @ imm = #0xb4
    13d6: f1b8 0f00    	cmp.w	r8, #0x0
    13da: d079         	beq	0x14d0 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x120> @ imm = #0xf2
    13dc: f008 0c03    	and	r12, r8, #0x3
    13e0: 4681         	mov	r9, r0
    13e2: ea5f 0198    	lsrs.w	r1, r8, #0x2
    13e6: f04f 0200    	mov.w	r2, #0x0
    13ea: f000 82df    	beq.w	0x19ac <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x5fc> @ imm = #0x5be
    13ee: f001 0103    	and	r1, r1, #0x3
    13f2: 46a6         	mov	lr, r4
    13f4: f06f 0603    	mvn	r6, #0x3
    13f8: 2300         	movs	r3, #0x0
    13fa: eba2 0a81    	sub.w	r10, r2, r1, lsl #2
    13fe: 1c62         	adds	r2, r4, #0x1
    1400: 1991         	adds	r1, r2, r6
    1402: 3604         	adds	r6, #0x4
    1404: f991 4003    	ldrsb.w	r4, [r1, #0x3]
    1408: f991 5006    	ldrsb.w	r5, [r1, #0x6]
    140c: f991 0005    	ldrsb.w	r0, [r1, #0x5]
    1410: f114 0f41    	cmn.w	r4, #0x41
    1414: f991 1004    	ldrsb.w	r1, [r1, #0x4]
    1418: bfc8         	it	gt
    141a: 3301         	addgt	r3, #0x1
    141c: f111 0f41    	cmn.w	r1, #0x41
    1420: bfc8         	it	gt
    1422: 3301         	addgt	r3, #0x1
    1424: f110 0f41    	cmn.w	r0, #0x41
    1428: bfc8         	it	gt
    142a: 3301         	addgt	r3, #0x1
    142c: f115 0f41    	cmn.w	r5, #0x41
    1430: eb0a 0006    	add.w	r0, r10, r6
    1434: bfc8         	it	gt
    1436: 3301         	addgt	r3, #0x1
    1438: 3004         	adds	r0, #0x4
    143a: d1e1         	bne	0x1400 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x50> @ imm = #-0x3e
    143c: 1d32         	adds	r2, r6, #0x4
    143e: 4674         	mov	r4, lr
    1440: f1bc 0f00    	cmp.w	r12, #0x0
    1444: f040 82b6    	bne.w	0x19b4 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x604> @ imm = #0x56c
    1448: e2cc         	b	0x19e4 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x634> @ imm = #0x598
    144a: f8b0 c00e    	ldrh.w	r12, [r0, #0xe]
    144e: f1bc 0f00    	cmp.w	r12, #0x0
    1452: d02c         	beq	0x14ae <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0xfe> @ imm = #0x58
    1454: eb04 0208    	add.w	r2, r4, r8
    1458: f04f 0800    	mov.w	r8, #0x0
    145c: 4626         	mov	r6, r4
    145e: 4661         	mov	r1, r12
    1460: e007         	b	0x1472 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0xc2> @ imm = #0xe
    1462: 2ef0         	cmp	r6, #0xf0
    1464: bf2c         	ite	hs
    1466: 1d1e         	addhs	r6, r3, #0x4
    1468: 1cde         	addlo	r6, r3, #0x3
    146a: 1af3         	subs	r3, r6, r3
    146c: 3901         	subs	r1, #0x1
    146e: 4498         	add	r8, r3
    1470: d01f         	beq	0x14b2 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x102> @ imm = #0x3e
    1472: 4296         	cmp	r6, r2
    1474: d01e         	beq	0x14b4 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x104> @ imm = #0x3c
    1476: 4633         	mov	r3, r6
    1478: f916 5b01    	ldrsb	r5, [r6], #1
    147c: f1b5 3fff    	cmp.w	r5, #0xffffffff
    1480: dcf3         	bgt	0x146a <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0xba> @ imm = #-0x1a
    1482: b2ee         	uxtb	r6, r5
    1484: 2ee0         	cmp	r6, #0xe0
    1486: d2ec         	bhs	0x1462 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0xb2> @ imm = #-0x28
    1488: 1c9e         	adds	r6, r3, #0x2
    148a: e7ee         	b	0x146a <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0xba> @ imm = #-0x24
    148c: 9000         	str	r0, [sp]
    148e: 1ce0         	adds	r0, r4, #0x3
    1490: 4622         	mov	r2, r4
    1492: f020 0403    	bic	r4, r0, #0x3
    1496: ebb4 0e02    	subs.w	lr, r4, r2
    149a: f8cd 800c    	str.w	r8, [sp, #0xc]
    149e: eba8 080e    	sub.w	r8, r8, lr
    14a2: 9201         	str	r2, [sp, #0x4]
    14a4: f008 0c03    	and	r12, r8, #0x3
    14a8: d10b         	bne	0x14c2 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x112> @ imm = #0x16
    14aa: 2100         	movs	r1, #0x0
    14ac: e057         	b	0x155e <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x1ae> @ imm = #0xae
    14ae: f04f 0800    	mov.w	r8, #0x0
    14b2: 2100         	movs	r1, #0x0
    14b4: ebac 0301    	sub.w	r3, r12, r1
    14b8: 8981         	ldrh	r1, [r0, #0xc]
    14ba: 428b         	cmp	r3, r1
    14bc: f0c0 8232    	blo.w	0x1924 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x574> @ imm = #0x464
    14c0: e294         	b	0x19ec <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x63c> @ imm = #0x528
    14c2: 1b11         	subs	r1, r2, r4
    14c4: f111 0f04    	cmn.w	r1, #0x4
    14c8: d90a         	bls	0x14e0 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x130> @ imm = #0x14
    14ca: 2200         	movs	r2, #0x0
    14cc: 2100         	movs	r1, #0x0
    14ce: e02c         	b	0x152a <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x17a> @ imm = #0x58
    14d0: 2300         	movs	r3, #0x0
    14d2: f04f 0800    	mov.w	r8, #0x0
    14d6: 8981         	ldrh	r1, [r0, #0xc]
    14d8: 428b         	cmp	r3, r1
    14da: f0c0 8223    	blo.w	0x1924 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x574> @ imm = #0x446
    14de: e285         	b	0x19ec <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x63c> @ imm = #0x50a
    14e0: f102 0901    	add.w	r9, r2, #0x1
    14e4: 2100         	movs	r1, #0x0
    14e6: f06f 0503    	mvn	r5, #0x3
    14ea: eb09 0205    	add.w	r2, r9, r5
    14ee: f992 6003    	ldrsb.w	r6, [r2, #0x3]
    14f2: f992 0006    	ldrsb.w	r0, [r2, #0x6]
    14f6: f992 3005    	ldrsb.w	r3, [r2, #0x5]
    14fa: f116 0f41    	cmn.w	r6, #0x41
    14fe: f992 2004    	ldrsb.w	r2, [r2, #0x4]
    1502: bfc8         	it	gt
    1504: 3101         	addgt	r1, #0x1
    1506: f112 0f41    	cmn.w	r2, #0x41
    150a: bfc8         	it	gt
    150c: 3101         	addgt	r1, #0x1
    150e: f113 0f41    	cmn.w	r3, #0x41
    1512: bfc8         	it	gt
    1514: 3101         	addgt	r1, #0x1
    1516: f110 0f41    	cmn.w	r0, #0x41
    151a: f105 0004    	add.w	r0, r5, #0x4
    151e: bfc8         	it	gt
    1520: 3101         	addgt	r1, #0x1
    1522: f115 0208    	adds.w	r2, r5, #0x8
    1526: 4605         	mov	r5, r0
    1528: d1df         	bne	0x14ea <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x13a> @ imm = #-0x42
    152a: 9801         	ldr	r0, [sp, #0x4]
    152c: 5680         	ldrsb	r0, [r0, r2]
    152e: f110 0f41    	cmn.w	r0, #0x41
    1532: bfc8         	it	gt
    1534: 3101         	addgt	r1, #0x1
    1536: f1be 0f01    	cmp.w	lr, #0x1
    153a: d010         	beq	0x155e <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x1ae> @ imm = #0x20
    153c: 9801         	ldr	r0, [sp, #0x4]
    153e: 4402         	add	r2, r0
    1540: f992 0001    	ldrsb.w	r0, [r2, #0x1]
    1544: f110 0f41    	cmn.w	r0, #0x41
    1548: bfc8         	it	gt
    154a: 3101         	addgt	r1, #0x1
    154c: f1be 0f02    	cmp.w	lr, #0x2
    1550: d005         	beq	0x155e <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x1ae> @ imm = #0xa
    1552: f992 0002    	ldrsb.w	r0, [r2, #0x2]
    1556: f110 0f41    	cmn.w	r0, #0x41
    155a: bfc8         	it	gt
    155c: 3101         	addgt	r1, #0x1
    155e: f64f 72fc    	movw	r2, #0xfffc
    1562: ea4f 0e98    	lsr.w	lr, r8, #0x2
    1566: f6c1 72ff    	movt	r2, #0x1fff
    156a: 2000         	movs	r0, #0x0
    156c: f1bc 0f00    	cmp.w	r12, #0x0
    1570: d01f         	beq	0x15b2 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x202> @ imm = #0x3e
    1572: f102 42c0    	add.w	r2, r2, #0x60000000
    1576: ea02 0208    	and.w	r2, r2, r8
    157a: 4422         	add	r2, r4
    157c: f992 3000    	ldrsb.w	r3, [r2]
    1580: f113 0f41    	cmn.w	r3, #0x41
    1584: bfc8         	it	gt
    1586: 2001         	movgt	r0, #0x1
    1588: f8dd 800c    	ldr.w	r8, [sp, #0xc]
    158c: f1bc 0f01    	cmp.w	r12, #0x1
    1590: d011         	beq	0x15b6 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x206> @ imm = #0x22
    1592: f992 3001    	ldrsb.w	r3, [r2, #0x1]
    1596: f113 0f41    	cmn.w	r3, #0x41
    159a: bfc8         	it	gt
    159c: 3001         	addgt	r0, #0x1
    159e: f1bc 0f02    	cmp.w	r12, #0x2
    15a2: d008         	beq	0x15b6 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x206> @ imm = #0x10
    15a4: f992 2002    	ldrsb.w	r2, [r2, #0x2]
    15a8: f112 0f41    	cmn.w	r2, #0x41
    15ac: bfc8         	it	gt
    15ae: 3001         	addgt	r0, #0x1
    15b0: e001         	b	0x15b6 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x206> @ imm = #0x2
    15b2: f8dd 800c    	ldr.w	r8, [sp, #0xc]
    15b6: 1843         	adds	r3, r0, r1
    15b8: f8cd b008    	str.w	r11, [sp, #0x8]
    15bc: e014         	b	0x15e8 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x238> @ imm = #0x28
    15be: f04f 0900    	mov.w	r9, #0x0
    15c2: fa3f f189    	uxtb16	r1, r9
    15c6: fa3f f299    	uxtb16	r2, r9, ror #8
    15ca: 4411         	add	r1, r2
    15cc: 9d07         	ldr	r5, [sp, #0x1c]
    15ce: 9b08         	ldr	r3, [sp, #0x20]
    15d0: eb01 4101    	add.w	r1, r1, r1, lsl #16
    15d4: ebae 0e05    	sub.w	lr, lr, r5
    15d8: eb0c 0485    	add.w	r4, r12, r5, lsl #2
    15dc: f015 0003    	ands	r0, r5, #0x3
    15e0: eb03 4311    	add.w	r3, r3, r1, lsr #16
    15e4: f040 816c    	bne.w	0x18c0 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x510> @ imm = #0x2d8
    15e8: f1be 0f00    	cmp.w	lr, #0x0
    15ec: f000 8166    	beq.w	0x18bc <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x50c> @ imm = #0x2cc
    15f0: f1be 0fc0    	cmp.w	lr, #0xc0
    15f4: 4671         	mov	r1, lr
    15f6: f44f 707c    	mov.w	r0, #0x3f0
    15fa: 9308         	str	r3, [sp, #0x20]
    15fc: bf28         	it	hs
    15fe: 21c0         	movhs	r1, #0xc0
    1600: ea10 0081    	ands.w	r0, r0, r1, lsl #2
    1604: 46a4         	mov	r12, r4
    1606: 9107         	str	r1, [sp, #0x1c]
    1608: d0d9         	beq	0x15be <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x20e> @ imm = #-0x4e
    160a: eb0c 0400    	add.w	r4, r12, r0
    160e: 0088         	lsls	r0, r1, #0x2
    1610: 3810         	subs	r0, #0x10
    1612: 2101         	movs	r1, #0x1
    1614: f10c 0a10    	add.w	r10, r12, #0x10
    1618: f8cd e018    	str.w	lr, [sp, #0x18]
    161c: eb01 1110    	add.w	r1, r1, r0, lsr #4
    1620: 2830         	cmp	r0, #0x30
    1622: e9cd 1c04    	strd	r1, r12, [sp, #16]
    1626: d203         	bhs	0x1630 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x280> @ imm = #0x6
    1628: f04f 0900    	mov.w	r9, #0x0
    162c: 4663         	mov	r3, r12
    162e: e0c5         	b	0x17bc <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x40c> @ imm = #0x18a
    1630: f64f 70fc    	movw	r0, #0xfffc
    1634: f04f 0900    	mov.w	r9, #0x0
    1638: f6c1 70ff    	movt	r0, #0x1fff
    163c: ea01 0e00    	and.w	lr, r1, r0
    1640: 46d0         	mov	r8, r10
    1642: 4666         	mov	r6, r12
    1644: 9409         	str	r4, [sp, #0x24]
    1646: 4645         	mov	r5, r8
    1648: 45a0         	cmp	r8, r4
    164a: bf18         	it	ne
    164c: 3510         	addne	r5, #0x10
    164e: 462a         	mov	r2, r5
    1650: 42a5         	cmp	r5, r4
    1652: bf18         	it	ne
    1654: 3210         	addne	r2, #0x10
    1656: 4613         	mov	r3, r2
    1658: 42a2         	cmp	r2, r4
    165a: bf18         	it	ne
    165c: 3310         	addne	r3, #0x10
    165e: 469a         	mov	r10, r3
    1660: 42a3         	cmp	r3, r4
    1662: bf18         	it	ne
    1664: f10a 0a10    	addne.w	r10, r10, #0x10
    1668: e9d2 4c00    	ldrd	r4, r12, [r2]
    166c: f1be 0e04    	subs.w	lr, lr, #0x4
    1670: 6890         	ldr	r0, [r2, #0x8]
    1672: 900b         	str	r0, [sp, #0x2c]
    1674: 68d0         	ldr	r0, [r2, #0xc]
    1676: ea6f 0204    	mvn.w	r2, r4
    167a: ea4f 12d2    	lsr.w	r2, r2, #0x7
    167e: 900c         	str	r0, [sp, #0x30]
    1680: ea42 1294    	orr.w	r2, r2, r4, lsr #6
    1684: f022 30fe    	bic	r0, r2, #0xfefefefe
    1688: e9d6 2400    	ldrd	r2, r4, [r6]
    168c: 900a         	str	r0, [sp, #0x28]
    168e: e9d6 0602    	ldrd	r0, r6, [r6, #8]
    1692: ea6f 0b02    	mvn.w	r11, r2
    1696: ea4f 11db    	lsr.w	r1, r11, #0x7
    169a: ea41 1192    	orr.w	r1, r1, r2, lsr #6
    169e: ea6f 0204    	mvn.w	r2, r4
    16a2: ea4f 12d2    	lsr.w	r2, r2, #0x7
    16a6: f021 31fe    	bic	r1, r1, #0xfefefefe
    16aa: ea42 1294    	orr.w	r2, r2, r4, lsr #6
    16ae: 4449         	add	r1, r9
    16b0: f022 32fe    	bic	r2, r2, #0xfefefefe
    16b4: 4411         	add	r1, r2
    16b6: ea6f 0200    	mvn.w	r2, r0
    16ba: ea4f 12d2    	lsr.w	r2, r2, #0x7
    16be: ea42 1090    	orr.w	r0, r2, r0, lsr #6
    16c2: f020 30fe    	bic	r0, r0, #0xfefefefe
    16c6: 4408         	add	r0, r1
    16c8: ea6f 0106    	mvn.w	r1, r6
    16cc: ea4f 11d1    	lsr.w	r1, r1, #0x7
    16d0: ea41 1196    	orr.w	r1, r1, r6, lsr #6
    16d4: f021 31fe    	bic	r1, r1, #0xfefefefe
    16d8: eb01 0900    	add.w	r9, r1, r0
    16dc: e898 0056    	ldm.w	r8, {r1, r2, r4, r6}
    16e0: 46d0         	mov	r8, r10
    16e2: ea6f 0001    	mvn.w	r0, r1
    16e6: ea4f 10d0    	lsr.w	r0, r0, #0x7
    16ea: ea40 1091    	orr.w	r0, r0, r1, lsr #6
    16ee: ea6f 0102    	mvn.w	r1, r2
    16f2: ea4f 11d1    	lsr.w	r1, r1, #0x7
    16f6: f020 30fe    	bic	r0, r0, #0xfefefefe
    16fa: ea41 1192    	orr.w	r1, r1, r2, lsr #6
    16fe: 4448         	add	r0, r9
    1700: f021 31fe    	bic	r1, r1, #0xfefefefe
    1704: 4408         	add	r0, r1
    1706: ea6f 0104    	mvn.w	r1, r4
    170a: ea4f 11d1    	lsr.w	r1, r1, #0x7
    170e: ea41 1194    	orr.w	r1, r1, r4, lsr #6
    1712: f021 31fe    	bic	r1, r1, #0xfefefefe
    1716: 4408         	add	r0, r1
    1718: ea6f 0106    	mvn.w	r1, r6
    171c: ea4f 11d1    	lsr.w	r1, r1, #0x7
    1720: ea41 1196    	orr.w	r1, r1, r6, lsr #6
    1724: f021 31fe    	bic	r1, r1, #0xfefefefe
    1728: 4408         	add	r0, r1
    172a: cd36         	ldm	r5, {r1, r2, r4, r5}
    172c: ea6f 0601    	mvn.w	r6, r1
    1730: ea4f 16d6    	lsr.w	r6, r6, #0x7
    1734: ea46 1191    	orr.w	r1, r6, r1, lsr #6
    1738: f021 31fe    	bic	r1, r1, #0xfefefefe
    173c: 461e         	mov	r6, r3
    173e: 4408         	add	r0, r1
    1740: ea6f 0102    	mvn.w	r1, r2
    1744: ea4f 11d1    	lsr.w	r1, r1, #0x7
    1748: ea41 1192    	orr.w	r1, r1, r2, lsr #6
    174c: 9a0b         	ldr	r2, [sp, #0x2c]
    174e: f021 31fe    	bic	r1, r1, #0xfefefefe
    1752: 4408         	add	r0, r1
    1754: ea6f 0104    	mvn.w	r1, r4
    1758: ea4f 11d1    	lsr.w	r1, r1, #0x7
    175c: ea41 1194    	orr.w	r1, r1, r4, lsr #6
    1760: 9c09         	ldr	r4, [sp, #0x24]
    1762: f021 31fe    	bic	r1, r1, #0xfefefefe
    1766: 4408         	add	r0, r1
    1768: ea6f 0105    	mvn.w	r1, r5
    176c: ea4f 11d1    	lsr.w	r1, r1, #0x7
    1770: ea41 1195    	orr.w	r1, r1, r5, lsr #6
    1774: f021 31fe    	bic	r1, r1, #0xfefefefe
    1778: 4408         	add	r0, r1
    177a: 990a         	ldr	r1, [sp, #0x28]
    177c: 4408         	add	r0, r1
    177e: ea6f 010c    	mvn.w	r1, r12
    1782: ea4f 11d1    	lsr.w	r1, r1, #0x7
    1786: ea41 119c    	orr.w	r1, r1, r12, lsr #6
    178a: f021 31fe    	bic	r1, r1, #0xfefefefe
    178e: 4408         	add	r0, r1
    1790: ea6f 0102    	mvn.w	r1, r2
    1794: ea4f 11d1    	lsr.w	r1, r1, #0x7
    1798: ea41 1192    	orr.w	r1, r1, r2, lsr #6
    179c: 9a0c         	ldr	r2, [sp, #0x30]
    179e: f021 31fe    	bic	r1, r1, #0xfefefefe
    17a2: 4408         	add	r0, r1
    17a4: ea6f 0102    	mvn.w	r1, r2
    17a8: ea4f 11d1    	lsr.w	r1, r1, #0x7
    17ac: ea41 1192    	orr.w	r1, r1, r2, lsr #6
    17b0: f021 31fe    	bic	r1, r1, #0xfefefefe
    17b4: eb01 0900    	add.w	r9, r1, r0
    17b8: f47f af45    	bne.w	0x1646 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x296> @ imm = #-0x176
    17bc: 9804         	ldr	r0, [sp, #0x10]
    17be: e9dd b802    	ldrd	r11, r8, [sp, #8]
    17c2: e9dd ce05    	ldrd	r12, lr, [sp, #20]
    17c6: f010 0003    	ands	r0, r0, #0x3
    17ca: f43f aefa    	beq.w	0x15c2 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x212> @ imm = #-0x20c
    17ce: e893 0046    	ldm.w	r3, {r1, r2, r6}
    17d2: 45a2         	cmp	r10, r4
    17d4: 68db         	ldr	r3, [r3, #0xc]
    17d6: ea6f 0501    	mvn.w	r5, r1
    17da: ea4f 15d5    	lsr.w	r5, r5, #0x7
    17de: ea45 1191    	orr.w	r1, r5, r1, lsr #6
    17e2: ea6f 0502    	mvn.w	r5, r2
    17e6: f021 31fe    	bic	r1, r1, #0xfefefefe
    17ea: ea4f 15d5    	lsr.w	r5, r5, #0x7
    17ee: ea45 1292    	orr.w	r2, r5, r2, lsr #6
    17f2: 4449         	add	r1, r9
    17f4: f022 32fe    	bic	r2, r2, #0xfefefefe
    17f8: 4411         	add	r1, r2
    17fa: ea6f 0206    	mvn.w	r2, r6
    17fe: ea4f 12d2    	lsr.w	r2, r2, #0x7
    1802: ea42 1296    	orr.w	r2, r2, r6, lsr #6
    1806: 4656         	mov	r6, r10
    1808: f022 32fe    	bic	r2, r2, #0xfefefefe
    180c: bf18         	it	ne
    180e: 3610         	addne	r6, #0x10
    1810: 4411         	add	r1, r2
    1812: 43da         	mvns	r2, r3
    1814: 09d2         	lsrs	r2, r2, #0x7
    1816: 2801         	cmp	r0, #0x1
    1818: ea42 1293    	orr.w	r2, r2, r3, lsr #6
    181c: f022 32fe    	bic	r2, r2, #0xfefefefe
    1820: eb02 0901    	add.w	r9, r2, r1
    1824: f43f aecd    	beq.w	0x15c2 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x212> @ imm = #-0x266
    1828: e89a 002e    	ldm.w	r10, {r1, r2, r3, r5}
    182c: 2802         	cmp	r0, #0x2
    182e: ea6f 0401    	mvn.w	r4, r1
    1832: ea4f 14d4    	lsr.w	r4, r4, #0x7
    1836: ea44 1191    	orr.w	r1, r4, r1, lsr #6
    183a: ea6f 0402    	mvn.w	r4, r2
    183e: f021 31fe    	bic	r1, r1, #0xfefefefe
    1842: ea4f 14d4    	lsr.w	r4, r4, #0x7
    1846: ea44 1292    	orr.w	r2, r4, r2, lsr #6
    184a: 4449         	add	r1, r9
    184c: f022 32fe    	bic	r2, r2, #0xfefefefe
    1850: 4411         	add	r1, r2
    1852: ea6f 0203    	mvn.w	r2, r3
    1856: ea4f 12d2    	lsr.w	r2, r2, #0x7
    185a: ea42 1293    	orr.w	r2, r2, r3, lsr #6
    185e: f022 32fe    	bic	r2, r2, #0xfefefefe
    1862: 4411         	add	r1, r2
    1864: ea6f 0205    	mvn.w	r2, r5
    1868: ea4f 12d2    	lsr.w	r2, r2, #0x7
    186c: ea42 1295    	orr.w	r2, r2, r5, lsr #6
    1870: f022 32fe    	bic	r2, r2, #0xfefefefe
    1874: eb02 0901    	add.w	r9, r2, r1
    1878: f43f aea3    	beq.w	0x15c2 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x212> @ imm = #-0x2ba
    187c: e896 000f    	ldm.w	r6, {r0, r1, r2, r3}
    1880: 43c6         	mvns	r6, r0
    1882: 09f6         	lsrs	r6, r6, #0x7
    1884: ea46 1090    	orr.w	r0, r6, r0, lsr #6
    1888: 43ce         	mvns	r6, r1
    188a: f020 30fe    	bic	r0, r0, #0xfefefefe
    188e: 09f6         	lsrs	r6, r6, #0x7
    1890: ea46 1191    	orr.w	r1, r6, r1, lsr #6
    1894: 4448         	add	r0, r9
    1896: f021 31fe    	bic	r1, r1, #0xfefefefe
    189a: 4408         	add	r0, r1
    189c: 43d1         	mvns	r1, r2
    189e: 09c9         	lsrs	r1, r1, #0x7
    18a0: ea41 1192    	orr.w	r1, r1, r2, lsr #6
    18a4: f021 31fe    	bic	r1, r1, #0xfefefefe
    18a8: 4408         	add	r0, r1
    18aa: 43d9         	mvns	r1, r3
    18ac: 09c9         	lsrs	r1, r1, #0x7
    18ae: ea41 1193    	orr.w	r1, r1, r3, lsr #6
    18b2: f021 31fe    	bic	r1, r1, #0xfefefefe
    18b6: eb01 0900    	add.w	r9, r1, r0
    18ba: e682         	b	0x15c2 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x212> @ imm = #-0x2fc
    18bc: 9c01         	ldr	r4, [sp, #0x4]
    18be: e02d         	b	0x191c <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x56c> @ imm = #0x5a
    18c0: f005 06fc    	and	r6, r5, #0xfc
    18c4: 9c01         	ldr	r4, [sp, #0x4]
    18c6: 2801         	cmp	r0, #0x1
    18c8: f85c 1026    	ldr.w	r1, [r12, r6, lsl #2]
    18cc: ea6f 0201    	mvn.w	r2, r1
    18d0: ea4f 12d2    	lsr.w	r2, r2, #0x7
    18d4: ea42 1191    	orr.w	r1, r2, r1, lsr #6
    18d8: f021 32fe    	bic	r2, r1, #0xfefefefe
    18dc: d015         	beq	0x190a <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x55a> @ imm = #0x2a
    18de: eb0c 0586    	add.w	r5, r12, r6, lsl #2
    18e2: 2802         	cmp	r0, #0x2
    18e4: 6869         	ldr	r1, [r5, #0x4]
    18e6: ea6f 0601    	mvn.w	r6, r1
    18ea: ea4f 16d6    	lsr.w	r6, r6, #0x7
    18ee: ea46 1191    	orr.w	r1, r6, r1, lsr #6
    18f2: f021 31fe    	bic	r1, r1, #0xfefefefe
    18f6: 440a         	add	r2, r1
    18f8: d007         	beq	0x190a <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x55a> @ imm = #0xe
    18fa: 68a8         	ldr	r0, [r5, #0x8]
    18fc: 43c1         	mvns	r1, r0
    18fe: 09c9         	lsrs	r1, r1, #0x7
    1900: ea41 1090    	orr.w	r0, r1, r0, lsr #6
    1904: f020 30fe    	bic	r0, r0, #0xfefefefe
    1908: 4402         	add	r2, r0
    190a: fa3f f082    	uxtb16	r0, r2
    190e: fa3f f192    	uxtb16	r1, r2, ror #8
    1912: 4408         	add	r0, r1
    1914: eb00 4000    	add.w	r0, r0, r0, lsl #16
    1918: eb03 4310    	add.w	r3, r3, r0, lsr #16
    191c: 9800         	ldr	r0, [sp]
    191e: 8981         	ldrh	r1, [r0, #0xc]
    1920: 428b         	cmp	r3, r1
    1922: d263         	bhs	0x19ec <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x63c> @ imm = #0xc6
    1924: f3cb 7241    	ubfx	r2, r11, #0x1d, #0x2
    1928: f8cd 800c    	str.w	r8, [sp, #0xc]
    192c: eba1 0803    	sub.w	r8, r1, r3
    1930: f36f 5b5f    	bfc	r11, #21, #11
    1934: f04f 0900    	mov.w	r9, #0x0
    1938: 46a2         	mov	r10, r4
    193a: e8df f002    	tbb	[pc, r2]
    193e: 08 02 04 08  	.word	0x08040208
    1942: 46c1         	mov	r9, r8
    1944: e003         	b	0x194e <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x59e> @ imm = #0x6
    1946: fa1f f188    	uxth.w	r1, r8
    194a: ea4f 0951    	lsr.w	r9, r1, #0x1
    194e: e9d0 5600    	ldrd	r5, r6, [r0]
    1952: 2400         	movs	r4, #0x0
    1954: fa1f f089    	uxth.w	r0, r9
    1958: b2a1         	uxth	r1, r4
    195a: 4281         	cmp	r1, r0
    195c: d207         	bhs	0x196e <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x5be> @ imm = #0xe
    195e: 6932         	ldr	r2, [r6, #0x10]
    1960: 4628         	mov	r0, r5
    1962: 4659         	mov	r1, r11
    1964: 4790         	blx	r2
    1966: 3401         	adds	r4, #0x1
    1968: 2800         	cmp	r0, #0x0
    196a: d0f3         	beq	0x1954 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x5a4> @ imm = #-0x1a
    196c: e014         	b	0x1998 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x5e8> @ imm = #0x28
    196e: 9a03         	ldr	r2, [sp, #0xc]
    1970: 4628         	mov	r0, r5
    1972: 68f3         	ldr	r3, [r6, #0xc]
    1974: 4651         	mov	r1, r10
    1976: 4798         	blx	r3
    1978: b970         	cbnz	r0, 0x1998 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x5e8> @ imm = #0x1c
    197a: eba8 0009    	sub.w	r0, r8, r9
    197e: 2400         	movs	r4, #0x0
    1980: fa1f f880    	uxth.w	r8, r0
    1984: b2a0         	uxth	r0, r4
    1986: 4540         	cmp	r0, r8
    1988: d20b         	bhs	0x19a2 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x5f2> @ imm = #0x16
    198a: 6932         	ldr	r2, [r6, #0x10]
    198c: 4628         	mov	r0, r5
    198e: 4659         	mov	r1, r11
    1990: 4790         	blx	r2
    1992: 3401         	adds	r4, #0x1
    1994: 2800         	cmp	r0, #0x0
    1996: d0f5         	beq	0x1984 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x5d4> @ imm = #-0x16
    1998: 2001         	movs	r0, #0x1
    199a: b00d         	add	sp, #0x34
    199c: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    19a0: bdf0         	pop	{r4, r5, r6, r7, pc}
    19a2: 2000         	movs	r0, #0x0
    19a4: b00d         	add	sp, #0x34
    19a6: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    19aa: bdf0         	pop	{r4, r5, r6, r7, pc}
    19ac: 2300         	movs	r3, #0x0
    19ae: f1bc 0f00    	cmp.w	r12, #0x0
    19b2: d017         	beq	0x19e4 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x634> @ imm = #0x2e
    19b4: 56a0         	ldrsb	r0, [r4, r2]
    19b6: f110 0f41    	cmn.w	r0, #0x41
    19ba: bfc8         	it	gt
    19bc: 3301         	addgt	r3, #0x1
    19be: f1bc 0f01    	cmp.w	r12, #0x1
    19c2: d00f         	beq	0x19e4 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x634> @ imm = #0x1e
    19c4: 4422         	add	r2, r4
    19c6: f992 0001    	ldrsb.w	r0, [r2, #0x1]
    19ca: f110 0f41    	cmn.w	r0, #0x41
    19ce: bfc8         	it	gt
    19d0: 3301         	addgt	r3, #0x1
    19d2: f1bc 0f02    	cmp.w	r12, #0x2
    19d6: d005         	beq	0x19e4 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x634> @ imm = #0xa
    19d8: f992 0002    	ldrsb.w	r0, [r2, #0x2]
    19dc: f110 0f41    	cmn.w	r0, #0x41
    19e0: bfc8         	it	gt
    19e2: 3301         	addgt	r3, #0x1
    19e4: 4648         	mov	r0, r9
    19e6: 8981         	ldrh	r1, [r0, #0xc]
    19e8: 428b         	cmp	r3, r1
    19ea: d39b         	blo	0x1924 <core::fmt::Formatter::pad::h4e7a8b950cefb40f+0x574> @ imm = #-0xca
    19ec: e9d0 0100    	ldrd	r0, r1, [r0]
    19f0: 4642         	mov	r2, r8
    19f2: 68cb         	ldr	r3, [r1, #0xc]
    19f4: 4621         	mov	r1, r4
    19f6: b00d         	add	sp, #0x34
    19f8: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    19fc: e8bd 40f0    	pop.w	{r4, r5, r6, r7, lr}
    1a00: 4718         	bx	r3

00001a02 <<&T as core::fmt::Debug>::fmt::he706c4d17782b3d4>:
    1a02: b580         	push	{r7, lr}
    1a04: 466f         	mov	r7, sp
    1a06: e9d0 0200    	ldrd	r0, r2, [r0]
    1a0a: 68d2         	ldr	r2, [r2, #0xc]
    1a0c: e8bd 4080    	pop.w	{r7, lr}
    1a10: 4710         	bx	r2

00001a12 <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13>:
    1a12: b5f0         	push	{r4, r5, r6, r7, lr}
    1a14: af03         	add	r7, sp, #0xc
    1a16: f84d bd04    	str	r11, [sp, #-4]!
    1a1a: b084         	sub	sp, #0x10
    1a1c: 468c         	mov	r12, r1
    1a1e: 6801         	ldr	r1, [r0]
    1a20: f243 1e64    	movw	lr, #0x3164
    1a24: f2c0 0e00    	movt	lr, #0x0
    1a28: 08c8         	lsrs	r0, r1, #0x3
    1a2a: 287c         	cmp	r0, #0x7c
    1a2c: d943         	bls	0x1ab6 <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xa4> @ imm = #0x86
    1a2e: f241 7059    	movw	r0, #0x1759
    1a32: f2cd 10b7    	movt	r0, #0xd1b7
    1a36: fba1 0200    	umull	r0, r2, r1, r0
    1a3a: f242 7010    	movw	r0, #0x2710
    1a3e: 0b52         	lsrs	r2, r2, #0xd
    1a40: fb02 1510    	mls	r5, r2, r0, r1
    1a44: b2ab         	uxth	r3, r5
    1a46: 089c         	lsrs	r4, r3, #0x2
    1a48: f241 437b    	movw	r3, #0x147b
    1a4c: 435c         	muls	r4, r3, r4
    1a4e: 0c66         	lsrs	r6, r4, #0x11
    1a50: 2464         	movs	r4, #0x64
    1a52: fb06 5514    	mls	r5, r6, r4, r5
    1a56: f83e 6016    	ldrh.w	r6, [lr, r6, lsl #1]
    1a5a: f827 6c14    	strh	r6, [r7, #-20]
    1a5e: b2ad         	uxth	r5, r5
    1a60: f83e 5015    	ldrh.w	r5, [lr, r5, lsl #1]
    1a64: f827 5c12    	strh	r5, [r7, #-18]
    1a68: f249 657f    	movw	r5, #0x967f
    1a6c: f2c0 0598    	movt	r5, #0x98
    1a70: 42a9         	cmp	r1, r5
    1a72: d936         	bls	0x1ae2 <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xd0> @ imm = #0x6c
    1a74: f648 55b9    	movw	r5, #0x8db9
    1a78: f2c0 0506    	movt	r5, #0x6
    1a7c: fba2 5605    	umull	r5, r6, r2, r5
    1a80: fb06 2010    	mls	r0, r6, r0, r2
    1a84: fb00 f203    	mul	r2, r0, r3
    1a88: f643 3389    	movw	r3, #0x3b89
    1a8c: f2c5 53e6    	movt	r3, #0x55e6
    1a90: 0cd2         	lsrs	r2, r2, #0x13
    1a92: fb02 0014    	mls	r0, r2, r4, r0
    1a96: f83e 2012    	ldrh.w	r2, [lr, r2, lsl #1]
    1a9a: fba1 3403    	umull	r3, r4, r1, r3
    1a9e: f827 2c18    	strh	r2, [r7, #-24]
    1aa2: 2302         	movs	r3, #0x2
    1aa4: b280         	uxth	r0, r0
    1aa6: f83e 0010    	ldrh.w	r0, [lr, r0, lsl #1]
    1aaa: 0e62         	lsrs	r2, r4, #0x19
    1aac: f827 0c16    	strh	r0, [r7, #-22]
    1ab0: 2a09         	cmp	r2, #0x9
    1ab2: d804         	bhi	0x1abe <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xac> @ imm = #0x8
    1ab4: e018         	b	0x1ae8 <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xd6> @ imm = #0x30
    1ab6: 230a         	movs	r3, #0xa
    1ab8: 460a         	mov	r2, r1
    1aba: 2a09         	cmp	r2, #0x9
    1abc: d914         	bls	0x1ae8 <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xd6> @ imm = #0x28
    1abe: b290         	uxth	r0, r2
    1ac0: f241 447b    	movw	r4, #0x147b
    1ac4: 0880         	lsrs	r0, r0, #0x2
    1ac6: 3b02         	subs	r3, #0x2
    1ac8: 4360         	muls	r0, r4, r0
    1aca: 2464         	movs	r4, #0x64
    1acc: 0c40         	lsrs	r0, r0, #0x11
    1ace: fb00 2214    	mls	r2, r0, r4, r2
    1ad2: f1a7 041a    	sub.w	r4, r7, #0x1a
    1ad6: b292         	uxth	r2, r2
    1ad8: f83e 2012    	ldrh.w	r2, [lr, r2, lsl #1]
    1adc: 52e2         	strh	r2, [r4, r3]
    1ade: b929         	cbnz	r1, 0x1aec <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xda> @ imm = #0xa
    1ae0: e005         	b	0x1aee <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xdc> @ imm = #0xa
    1ae2: 2306         	movs	r3, #0x6
    1ae4: 2a09         	cmp	r2, #0x9
    1ae6: d8ea         	bhi	0x1abe <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xac> @ imm = #-0x2c
    1ae8: 4610         	mov	r0, r2
    1aea: b101         	cbz	r1, 0x1aee <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xdc> @ imm = #0x0
    1aec: b130         	cbz	r0, 0x1afc <core::fmt::num::imp::<impl core::fmt::Display for u32>::fmt::hf6a4bfbde2c99e13+0xea> @ imm = #0xc
    1aee: eb0e 0040    	add.w	r0, lr, r0, lsl #1
    1af2: 3b01         	subs	r3, #0x1
    1af4: f1a7 011a    	sub.w	r1, r7, #0x1a
    1af8: 7840         	ldrb	r0, [r0, #0x1]
    1afa: 54c8         	strb	r0, [r1, r3]
    1afc: f1c3 000a    	rsb.w	r0, r3, #0xa
    1b00: 9000         	str	r0, [sp]
    1b02: f1a7 001a    	sub.w	r0, r7, #0x1a
    1b06: 2101         	movs	r1, #0x1
    1b08: 4403         	add	r3, r0
    1b0a: 4660         	mov	r0, r12
    1b0c: 2200         	movs	r2, #0x0
    1b0e: f7ff fb13    	bl	0x1138 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43> @ imm = #-0x9da
    1b12: b004         	add	sp, #0x10
    1b14: f85d bb04    	ldr	r11, [sp], #4
    1b18: bdf0         	pop	{r4, r5, r6, r7, pc}

00001b1a <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216>:
    1b1a: b5f0         	push	{r4, r5, r6, r7, lr}
    1b1c: af03         	add	r7, sp, #0xc
    1b1e: e92d 0f00    	push.w	{r8, r9, r10, r11}
    1b22: b087         	sub	sp, #0x1c
    1b24: e9d0 5600    	ldrd	r5, r6, [r0]
    1b28: 4688         	mov	r8, r1
    1b2a: f04f 0a00    	mov.w	r10, #0x0
    1b2e: 08e8         	lsrs	r0, r5, #0x3
    1b30: ea40 7046    	orr.w	r0, r0, r6, lsl #29
    1b34: f1d0 007c    	rsbs.w	r0, r0, #0x7c
    1b38: eb7a 00d6    	sbcs.w	r0, r10, r6, lsr #3
    1b3c: f080 80bd    	bhs.w	0x1cba <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x1a0> @ imm = #0x17a
    1b40: 4628         	mov	r0, r5
    1b42: 4631         	mov	r1, r6
    1b44: f242 7210    	movw	r2, #0x2710
    1b48: 2300         	movs	r3, #0x0
    1b4a: f242 7410    	movw	r4, #0x2710
    1b4e: f000 ffb1    	bl	0x2ab4 <__aeabi_uldivmod> @ imm = #0xf62
    1b52: fb00 5214    	mls	r2, r0, r4, r5
    1b56: f241 4b7b    	movw	r11, #0x147b
    1b5a: 2464         	movs	r4, #0x64
    1b5c: f243 1964    	movw	r9, #0x3164
    1b60: f2c0 0900    	movt	r9, #0x0
    1b64: b293         	uxth	r3, r2
    1b66: 089b         	lsrs	r3, r3, #0x2
    1b68: fb03 f30b    	mul	r3, r3, r11
    1b6c: 0c5b         	lsrs	r3, r3, #0x11
    1b6e: fb03 2214    	mls	r2, r3, r4, r2
    1b72: f839 3013    	ldrh.w	r3, [r9, r3, lsl #1]
    1b76: f8ad 3018    	strh.w	r3, [sp, #0x18]
    1b7a: b292         	uxth	r2, r2
    1b7c: f839 2012    	ldrh.w	r2, [r9, r2, lsl #1]
    1b80: f8ad 201a    	strh.w	r2, [sp, #0x1a]
    1b84: f249 627f    	movw	r2, #0x967f
    1b88: f2c0 0298    	movt	r2, #0x98
    1b8c: 1b52         	subs	r2, r2, r5
    1b8e: eb7a 0206    	sbcs.w	r2, r10, r6
    1b92: f080 809b    	bhs.w	0x1ccc <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x1b2> @ imm = #0x136
    1b96: f242 7210    	movw	r2, #0x2710
    1b9a: 2300         	movs	r3, #0x0
    1b9c: f000 ff8a    	bl	0x2ab4 <__aeabi_uldivmod> @ imm = #0xf14
    1ba0: fb02 f00b    	mul	r0, r2, r11
    1ba4: 2300         	movs	r3, #0x0
    1ba6: 0cc0         	lsrs	r0, r0, #0x13
    1ba8: fb00 2114    	mls	r1, r0, r4, r2
    1bac: f839 0010    	ldrh.w	r0, [r9, r0, lsl #1]
    1bb0: f24e 1200    	movw	r2, #0xe100
    1bb4: f8ad 0014    	strh.w	r0, [sp, #0x14]
    1bb8: f2c0 52f5    	movt	r2, #0x5f5
    1bbc: 4628         	mov	r0, r5
    1bbe: b289         	uxth	r1, r1
    1bc0: f839 1011    	ldrh.w	r1, [r9, r1, lsl #1]
    1bc4: f8ad 1016    	strh.w	r1, [sp, #0x16]
    1bc8: 4631         	mov	r1, r6
    1bca: f000 ff73    	bl	0x2ab4 <__aeabi_uldivmod> @ imm = #0xee6
    1bce: f64e 0200    	movw	r2, #0xe800
    1bd2: f6c4 0276    	movt	r2, #0x4876
    1bd6: 1aaa         	subs	r2, r5, r2
    1bd8: f176 0217    	sbcs	r2, r6, #0x17
    1bdc: d37d         	blo	0x1cda <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x1c0> @ imm = #0xfa
    1bde: f242 7210    	movw	r2, #0x2710
    1be2: 2300         	movs	r3, #0x0
    1be4: f000 ff66    	bl	0x2ab4 <__aeabi_uldivmod> @ imm = #0xecc
    1be8: f241 447b    	movw	r4, #0x147b
    1bec: f04f 0b64    	mov.w	r11, #0x64
    1bf0: fb02 f004    	mul	r0, r2, r4
    1bf4: 23e8         	movs	r3, #0xe8
    1bf6: 0cc0         	lsrs	r0, r0, #0x13
    1bf8: fb00 211b    	mls	r1, r0, r11, r2
    1bfc: f839 0010    	ldrh.w	r0, [r9, r0, lsl #1]
    1c00: f241 0200    	movw	r2, #0x1000
    1c04: f8ad 0010    	strh.w	r0, [sp, #0x10]
    1c08: f2cd 42a5    	movt	r2, #0xd4a5
    1c0c: 4628         	mov	r0, r5
    1c0e: b289         	uxth	r1, r1
    1c10: f839 1011    	ldrh.w	r1, [r9, r1, lsl #1]
    1c14: f8ad 1012    	strh.w	r1, [sp, #0x12]
    1c18: 4631         	mov	r1, r6
    1c1a: f000 ff4b    	bl	0x2ab4 <__aeabi_uldivmod> @ imm = #0xe96
    1c1e: f248 0300    	movw	r3, #0x8000
    1c22: f648 527e    	movw	r2, #0x8d7e
    1c26: f2ca 43c6    	movt	r3, #0xa4c6
    1c2a: f2c0 0203    	movt	r2, #0x3
    1c2e: 1aeb         	subs	r3, r5, r3
    1c30: eb76 0202    	sbcs.w	r2, r6, r2
    1c34: d358         	blo	0x1ce8 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x1ce> @ imm = #0xb0
    1c36: f242 7210    	movw	r2, #0x2710
    1c3a: 2300         	movs	r3, #0x0
    1c3c: f000 ff3a    	bl	0x2ab4 <__aeabi_uldivmod> @ imm = #0xe74
    1c40: fb02 f004    	mul	r0, r2, r4
    1c44: f248 63f2    	movw	r3, #0x86f2
    1c48: f2c0 0323    	movt	r3, #0x23
    1c4c: 0cc0         	lsrs	r0, r0, #0x13
    1c4e: fb00 211b    	mls	r1, r0, r11, r2
    1c52: f839 0010    	ldrh.w	r0, [r9, r0, lsl #1]
    1c56: 2200         	movs	r2, #0x0
    1c58: f8ad 000c    	strh.w	r0, [sp, #0xc]
    1c5c: f6c6 72c1    	movt	r2, #0x6fc1
    1c60: 4628         	mov	r0, r5
    1c62: b289         	uxth	r1, r1
    1c64: f839 1011    	ldrh.w	r1, [r9, r1, lsl #1]
    1c68: f8ad 100e    	strh.w	r1, [sp, #0xe]
    1c6c: 4631         	mov	r1, r6
    1c6e: f000 ff21    	bl	0x2ab4 <__aeabi_uldivmod> @ imm = #0xe42
    1c72: 2300         	movs	r3, #0x0
    1c74: f242 3204    	movw	r2, #0x2304
    1c78: f6c8 13e8    	movt	r3, #0x89e8
    1c7c: f6c8 22c7    	movt	r2, #0x8ac7
    1c80: 1aeb         	subs	r3, r5, r3
    1c82: eb76 0202    	sbcs.w	r2, r6, r2
    1c86: d34d         	blo	0x1d24 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x20a> @ imm = #0x9a
    1c88: b281         	uxth	r1, r0
    1c8a: f241 427b    	movw	r2, #0x147b
    1c8e: 0889         	lsrs	r1, r1, #0x2
    1c90: 2300         	movs	r3, #0x0
    1c92: 4351         	muls	r1, r2, r1
    1c94: 2264         	movs	r2, #0x64
    1c96: 0c49         	lsrs	r1, r1, #0x11
    1c98: fb01 0012    	mls	r0, r1, r2, r0
    1c9c: f839 1011    	ldrh.w	r1, [r9, r1, lsl #1]
    1ca0: f8ad 1008    	strh.w	r1, [sp, #0x8]
    1ca4: 2100         	movs	r1, #0x0
    1ca6: 2200         	movs	r2, #0x0
    1ca8: b280         	uxth	r0, r0
    1caa: f839 0010    	ldrh.w	r0, [r9, r0, lsl #1]
    1cae: f8ad 000a    	strh.w	r0, [sp, #0xa]
    1cb2: ea55 0006    	orrs.w	r0, r5, r6
    1cb6: d13f         	bne	0x1d38 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x21e> @ imm = #0x7e
    1cb8: e041         	b	0x1d3e <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x224> @ imm = #0x82
    1cba: 2214         	movs	r2, #0x14
    1cbc: 4628         	mov	r0, r5
    1cbe: 4631         	mov	r1, r6
    1cc0: f1d0 0309    	rsbs.w	r3, r0, #0x9
    1cc4: eb7a 0301    	sbcs.w	r3, r10, r1
    1cc8: d314         	blo	0x1cf4 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x1da> @ imm = #0x28
    1cca: e031         	b	0x1d30 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x216> @ imm = #0x62
    1ccc: 2210         	movs	r2, #0x10
    1cce: f1d0 0309    	rsbs.w	r3, r0, #0x9
    1cd2: eb7a 0301    	sbcs.w	r3, r10, r1
    1cd6: d30d         	blo	0x1cf4 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x1da> @ imm = #0x1a
    1cd8: e02a         	b	0x1d30 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x216> @ imm = #0x54
    1cda: 220c         	movs	r2, #0xc
    1cdc: f1d0 0309    	rsbs.w	r3, r0, #0x9
    1ce0: eb7a 0301    	sbcs.w	r3, r10, r1
    1ce4: d306         	blo	0x1cf4 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x1da> @ imm = #0xc
    1ce6: e023         	b	0x1d30 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x216> @ imm = #0x46
    1ce8: 2208         	movs	r2, #0x8
    1cea: f1d0 0309    	rsbs.w	r3, r0, #0x9
    1cee: eb7a 0301    	sbcs.w	r3, r10, r1
    1cf2: d21d         	bhs	0x1d30 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x216> @ imm = #0x3a
    1cf4: b281         	uxth	r1, r0
    1cf6: f241 437b    	movw	r3, #0x147b
    1cfa: 0889         	lsrs	r1, r1, #0x2
    1cfc: 3a02         	subs	r2, #0x2
    1cfe: 4359         	muls	r1, r3, r1
    1d00: 0c4b         	lsrs	r3, r1, #0x11
    1d02: 2164         	movs	r1, #0x64
    1d04: fb03 0011    	mls	r0, r3, r1, r0
    1d08: f243 1164    	movw	r1, #0x3164
    1d0c: f2c0 0100    	movt	r1, #0x0
    1d10: b280         	uxth	r0, r0
    1d12: f831 0010    	ldrh.w	r0, [r1, r0, lsl #1]
    1d16: a902         	add	r1, sp, #0x8
    1d18: 5288         	strh	r0, [r1, r2]
    1d1a: 2100         	movs	r1, #0x0
    1d1c: ea55 0006    	orrs.w	r0, r5, r6
    1d20: d10a         	bne	0x1d38 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x21e> @ imm = #0x14
    1d22: e00c         	b	0x1d3e <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x224> @ imm = #0x18
    1d24: 2204         	movs	r2, #0x4
    1d26: f1d0 0309    	rsbs.w	r3, r0, #0x9
    1d2a: eb7a 0301    	sbcs.w	r3, r10, r1
    1d2e: d3e1         	blo	0x1cf4 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x1da> @ imm = #-0x3e
    1d30: 4603         	mov	r3, r0
    1d32: ea55 0006    	orrs.w	r0, r5, r6
    1d36: d002         	beq	0x1d3e <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x224> @ imm = #0x4
    1d38: ea53 0001    	orrs.w	r0, r3, r1
    1d3c: d009         	beq	0x1d52 <core::fmt::num::imp::<impl core::fmt::Display for u64>::fmt::hf2129d9f5489d216+0x238> @ imm = #0x12
    1d3e: f243 1064    	movw	r0, #0x3164
    1d42: 3a01         	subs	r2, #0x1
    1d44: f2c0 0000    	movt	r0, #0x0
    1d48: a902         	add	r1, sp, #0x8
    1d4a: eb00 0043    	add.w	r0, r0, r3, lsl #1
    1d4e: 7840         	ldrb	r0, [r0, #0x1]
    1d50: 5488         	strb	r0, [r1, r2]
    1d52: f1c2 0014    	rsb.w	r0, r2, #0x14
    1d56: 9000         	str	r0, [sp]
    1d58: a802         	add	r0, sp, #0x8
    1d5a: 2101         	movs	r1, #0x1
    1d5c: 1883         	adds	r3, r0, r2
    1d5e: 4640         	mov	r0, r8
    1d60: 2200         	movs	r2, #0x0
    1d62: f7ff f9e9    	bl	0x1138 <core::fmt::Formatter::pad_integral::h7738abc4dcb7ef43> @ imm = #-0xc2e
    1d66: b007         	add	sp, #0x1c
    1d68: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    1d6c: bdf0         	pop	{r4, r5, r6, r7, pc}

00001d6e <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7>:
    1d6e: b5f0         	push	{r4, r5, r6, r7, lr}
    1d70: af03         	add	r7, sp, #0xc
    1d72: e92d 0f00    	push.w	{r8, r9, r10, r11}
    1d76: b089         	sub	sp, #0x24
    1d78: 6803         	ldr	r3, [r0]
    1d7a: f04f 0800    	mov.w	r8, #0x0
    1d7e: 9305         	str	r3, [sp, #0x14]
    1d80: f04f 0900    	mov.w	r9, #0x0
    1d84: 6843         	ldr	r3, [r0, #0x4]
    1d86: f04f 0a00    	mov.w	r10, #0x0
    1d8a: 6880         	ldr	r0, [r0, #0x8]
    1d8c: 9007         	str	r0, [sp, #0x1c]
    1d8e: 1c48         	adds	r0, r1, #0x1
    1d90: 9001         	str	r0, [sp, #0x4]
    1d92: f1c2 0001    	rsb.w	r0, r2, #0x1
    1d96: 9000         	str	r0, [sp]
    1d98: 4250         	rsbs	r0, r2, #0
    1d9a: 9003         	str	r0, [sp, #0xc]
    1d9c: 1e48         	subs	r0, r1, #0x1
    1d9e: 9304         	str	r3, [sp, #0x10]
    1da0: 9108         	str	r1, [sp, #0x20]
    1da2: 9002         	str	r0, [sp, #0x8]
    1da4: 9206         	str	r2, [sp, #0x18]
    1da6: e014         	b	0x1dd2 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x64> @ imm = #0x28
    1da8: 9802         	ldr	r0, [sp, #0x8]
    1daa: 5d00         	ldrb	r0, [r0, r4]
    1dac: 380a         	subs	r0, #0xa
    1dae: fab0 f080    	clz	r0, r0
    1db2: 0940         	lsrs	r0, r0, #0x5
    1db4: 9b04         	ldr	r3, [sp, #0x10]
    1db6: eba4 0208    	sub.w	r2, r4, r8
    1dba: 9e07         	ldr	r6, [sp, #0x1c]
    1dbc: 9908         	ldr	r1, [sp, #0x20]
    1dbe: 68db         	ldr	r3, [r3, #0xc]
    1dc0: 7030         	strb	r0, [r6]
    1dc2: 4441         	add	r1, r8
    1dc4: 9805         	ldr	r0, [sp, #0x14]
    1dc6: 4798         	blx	r3
    1dc8: 9a06         	ldr	r2, [sp, #0x18]
    1dca: 46d8         	mov	r8, r11
    1dcc: 2800         	cmp	r0, #0x0
    1dce: f040 80f8    	bne.w	0x1fc2 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x254> @ imm = #0x1f0
    1dd2: ea5f 70ca    	lsls.w	r0, r10, #0x1f
    1dd6: f040 80ef    	bne.w	0x1fb8 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x24a> @ imm = #0x1de
    1dda: 454a         	cmp	r2, r9
    1ddc: f0c0 80d4    	blo.w	0x1f88 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x21a> @ imm = #0x1a8
    1de0: 9808         	ldr	r0, [sp, #0x20]
    1de2: eba2 0309    	sub.w	r3, r2, r9
    1de6: 2b07         	cmp	r3, #0x7
    1de8: eb00 0a09    	add.w	r10, r0, r9
    1dec: d827         	bhi	0x1e3e <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0xd0> @ imm = #0x4e
    1dee: 454a         	cmp	r2, r9
    1df0: f000 80c9    	beq.w	0x1f86 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x218> @ imm = #0x192
    1df4: 9803         	ldr	r0, [sp, #0xc]
    1df6: eb00 0109    	add.w	r1, r0, r9
    1dfa: 2000         	movs	r0, #0x0
    1dfc: f81a 3000    	ldrb.w	r3, [r10, r0]
    1e00: 2b0a         	cmp	r3, #0xa
    1e02: f000 80ab    	beq.w	0x1f5c <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ee> @ imm = #0x156
    1e06: 180b         	adds	r3, r1, r0
    1e08: 1c5e         	adds	r6, r3, #0x1
    1e0a: f000 80bc    	beq.w	0x1f86 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x218> @ imm = #0x178
    1e0e: eb0a 0600    	add.w	r6, r10, r0
    1e12: 7875         	ldrb	r5, [r6, #0x1]
    1e14: 2d0a         	cmp	r5, #0xa
    1e16: f000 808c    	beq.w	0x1f32 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1c4> @ imm = #0x118
    1e1a: 1c9d         	adds	r5, r3, #0x2
    1e1c: f000 80b3    	beq.w	0x1f86 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x218> @ imm = #0x166
    1e20: 78b5         	ldrb	r5, [r6, #0x2]
    1e22: 2d0a         	cmp	r5, #0xa
    1e24: f000 8087    	beq.w	0x1f36 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1c8> @ imm = #0x10e
    1e28: 3303         	adds	r3, #0x3
    1e2a: f000 80ac    	beq.w	0x1f86 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x218> @ imm = #0x158
    1e2e: 78f3         	ldrb	r3, [r6, #0x3]
    1e30: 2b0a         	cmp	r3, #0xa
    1e32: f000 8082    	beq.w	0x1f3a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1cc> @ imm = #0x104
    1e36: 3004         	adds	r0, #0x4
    1e38: 180b         	adds	r3, r1, r0
    1e3a: d1df         	bne	0x1dfc <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x8e> @ imm = #-0x42
    1e3c: e0a3         	b	0x1f86 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x218> @ imm = #0x146
    1e3e: f10a 0103    	add.w	r1, r10, #0x3
    1e42: f021 0103    	bic	r1, r1, #0x3
    1e46: ebb1 010a    	subs.w	r1, r1, r10
    1e4a: d11c         	bne	0x1e86 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x118> @ imm = #0x38
    1e4c: f240 1000    	movw	r0, #0x100
    1e50: f1a3 0208    	sub.w	r2, r3, #0x8
    1e54: 2100         	movs	r1, #0x0
    1e56: f2c0 1001    	movt	r0, #0x101
    1e5a: f85a 6001    	ldr.w	r6, [r10, r1]
    1e5e: eb0a 0501    	add.w	r5, r10, r1
    1e62: 686d         	ldr	r5, [r5, #0x4]
    1e64: f086 340a    	eor	r4, r6, #0xa0a0a0a
    1e68: 1b04         	subs	r4, r0, r4
    1e6a: 4326         	orrs	r6, r4
    1e6c: f085 340a    	eor	r4, r5, #0xa0a0a0a
    1e70: 1b04         	subs	r4, r0, r4
    1e72: 4325         	orrs	r5, r4
    1e74: 402e         	ands	r6, r5
    1e76: 43f6         	mvns	r6, r6
    1e78: f016 3f80    	tst.w	r6, #0x80808080
    1e7c: d12c         	bne	0x1ed8 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x16a> @ imm = #0x58
    1e7e: 3108         	adds	r1, #0x8
    1e80: 4291         	cmp	r1, r2
    1e82: d9ea         	bls	0x1e5a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0xec> @ imm = #-0x2c
    1e84: e028         	b	0x1ed8 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x16a> @ imm = #0x50
    1e86: f1a1 0e02    	sub.w	lr, r1, #0x2
    1e8a: f1a1 0c03    	sub.w	r12, r1, #0x3
    1e8e: 1e4e         	subs	r6, r1, #0x1
    1e90: 2000         	movs	r0, #0x0
    1e92: f81a 4000    	ldrb.w	r4, [r10, r0]
    1e96: 2c0a         	cmp	r4, #0xa
    1e98: d05f         	beq	0x1f5a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ec> @ imm = #0xbe
    1e9a: 4286         	cmp	r6, r0
    1e9c: d014         	beq	0x1ec8 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x15a> @ imm = #0x28
    1e9e: eb0a 0400    	add.w	r4, r10, r0
    1ea2: 7865         	ldrb	r5, [r4, #0x1]
    1ea4: 2d0a         	cmp	r5, #0xa
    1ea6: d053         	beq	0x1f50 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1e2> @ imm = #0xa6
    1ea8: 4586         	cmp	lr, r0
    1eaa: d00d         	beq	0x1ec8 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x15a> @ imm = #0x1a
    1eac: 78a5         	ldrb	r5, [r4, #0x2]
    1eae: 2d0a         	cmp	r5, #0xa
    1eb0: d050         	beq	0x1f54 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1e6> @ imm = #0xa0
    1eb2: 4584         	cmp	r12, r0
    1eb4: d008         	beq	0x1ec8 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x15a> @ imm = #0x10
    1eb6: 78e4         	ldrb	r4, [r4, #0x3]
    1eb8: 2c0a         	cmp	r4, #0xa
    1eba: d04d         	beq	0x1f58 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ea> @ imm = #0x9a
    1ebc: 3004         	adds	r0, #0x4
    1ebe: f81a 4000    	ldrb.w	r4, [r10, r0]
    1ec2: 2c0a         	cmp	r4, #0xa
    1ec4: d1e9         	bne	0x1e9a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x12c> @ imm = #-0x2e
    1ec6: e048         	b	0x1f5a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ec> @ imm = #0x90
    1ec8: f240 1000    	movw	r0, #0x100
    1ecc: f1a3 0208    	sub.w	r2, r3, #0x8
    1ed0: f2c0 1001    	movt	r0, #0x101
    1ed4: 4291         	cmp	r1, r2
    1ed6: d9c0         	bls	0x1e5a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0xec> @ imm = #-0x80
    1ed8: 1a5b         	subs	r3, r3, r1
    1eda: d053         	beq	0x1f84 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x216> @ imm = #0xa6
    1edc: 9801         	ldr	r0, [sp, #0x4]
    1ede: eb01 0209    	add.w	r2, r1, r9
    1ee2: eb00 0e02    	add.w	lr, r0, r2
    1ee6: 9800         	ldr	r0, [sp]
    1ee8: eb02 0c00    	add.w	r12, r2, r0
    1eec: 9803         	ldr	r0, [sp, #0xc]
    1eee: 1816         	adds	r6, r2, r0
    1ef0: 2203         	movs	r2, #0x3
    1ef2: eb0e 0402    	add.w	r4, lr, r2
    1ef6: f814 5c04    	ldrb	r5, [r4, #-4]
    1efa: 2d0a         	cmp	r5, #0xa
    1efc: d01f         	beq	0x1f3e <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1d0> @ imm = #0x3e
    1efe: eb0c 0502    	add.w	r5, r12, r2
    1f02: 2d03         	cmp	r5, #0x3
    1f04: d03e         	beq	0x1f84 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x216> @ imm = #0x7c
    1f06: f814 5c03    	ldrb	r5, [r4, #-3]
    1f0a: 2d0a         	cmp	r5, #0xa
    1f0c: d01a         	beq	0x1f44 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1d6> @ imm = #0x34
    1f0e: 18b5         	adds	r5, r6, r2
    1f10: 2d01         	cmp	r5, #0x1
    1f12: d037         	beq	0x1f84 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x216> @ imm = #0x6e
    1f14: f814 5c02    	ldrb	r5, [r4, #-2]
    1f18: 2d0a         	cmp	r5, #0xa
    1f1a: d016         	beq	0x1f4a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1dc> @ imm = #0x2c
    1f1c: 4293         	cmp	r3, r2
    1f1e: d031         	beq	0x1f84 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x216> @ imm = #0x62
    1f20: f814 4c01    	ldrb	r4, [r4, #-1]
    1f24: 2c0a         	cmp	r4, #0xa
    1f26: d00b         	beq	0x1f40 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1d2> @ imm = #0x16
    1f28: 3204         	adds	r2, #0x4
    1f2a: 18b4         	adds	r4, r6, r2
    1f2c: 2c03         	cmp	r4, #0x3
    1f2e: d1e0         	bne	0x1ef2 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x184> @ imm = #-0x40
    1f30: e028         	b	0x1f84 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x216> @ imm = #0x50
    1f32: 3001         	adds	r0, #0x1
    1f34: e012         	b	0x1f5c <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ee> @ imm = #0x24
    1f36: 3002         	adds	r0, #0x2
    1f38: e010         	b	0x1f5c <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ee> @ imm = #0x20
    1f3a: 3003         	adds	r0, #0x3
    1f3c: e00e         	b	0x1f5c <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ee> @ imm = #0x1c
    1f3e: 3a03         	subs	r2, #0x3
    1f40: 1850         	adds	r0, r2, r1
    1f42: e00a         	b	0x1f5a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ec> @ imm = #0x14
    1f44: 3a02         	subs	r2, #0x2
    1f46: 1850         	adds	r0, r2, r1
    1f48: e007         	b	0x1f5a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ec> @ imm = #0xe
    1f4a: 3a01         	subs	r2, #0x1
    1f4c: 1850         	adds	r0, r2, r1
    1f4e: e004         	b	0x1f5a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ec> @ imm = #0x8
    1f50: 3001         	adds	r0, #0x1
    1f52: e002         	b	0x1f5a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ec> @ imm = #0x4
    1f54: 3002         	adds	r0, #0x2
    1f56: e000         	b	0x1f5a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x1ec> @ imm = #0x0
    1f58: 3003         	adds	r0, #0x3
    1f5a: 9a06         	ldr	r2, [sp, #0x18]
    1f5c: eb09 0100    	add.w	r1, r9, r0
    1f60: f101 0901    	add.w	r9, r1, #0x1
    1f64: 4291         	cmp	r1, r2
    1f66: f4bf af38    	bhs.w	0x1dda <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x6c> @ imm = #-0x190
    1f6a: f81a 0000    	ldrb.w	r0, [r10, r0]
    1f6e: 280a         	cmp	r0, #0xa
    1f70: f47f af33    	bne.w	0x1dda <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x6c> @ imm = #-0x19a
    1f74: f04f 0a00    	mov.w	r10, #0x0
    1f78: 46cb         	mov	r11, r9
    1f7a: 464c         	mov	r4, r9
    1f7c: 9807         	ldr	r0, [sp, #0x1c]
    1f7e: 7800         	ldrb	r0, [r0]
    1f80: b1a8         	cbz	r0, 0x1fae <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x240> @ imm = #0x2a
    1f82: e00a         	b	0x1f9a <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x22c> @ imm = #0x14
    1f84: 9a06         	ldr	r2, [sp, #0x18]
    1f86: 4691         	mov	r9, r2
    1f88: 4542         	cmp	r2, r8
    1f8a: d015         	beq	0x1fb8 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x24a> @ imm = #0x2a
    1f8c: f04f 0a01    	mov.w	r10, #0x1
    1f90: 46c3         	mov	r11, r8
    1f92: 4614         	mov	r4, r2
    1f94: 9807         	ldr	r0, [sp, #0x1c]
    1f96: 7800         	ldrb	r0, [r0]
    1f98: b148         	cbz	r0, 0x1fae <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x240> @ imm = #0x12
    1f9a: 9804         	ldr	r0, [sp, #0x10]
    1f9c: f243 21d8    	movw	r1, #0x32d8
    1fa0: f2c0 0100    	movt	r1, #0x0
    1fa4: 2204         	movs	r2, #0x4
    1fa6: 68c3         	ldr	r3, [r0, #0xc]
    1fa8: 9805         	ldr	r0, [sp, #0x14]
    1faa: 4798         	blx	r3
    1fac: b948         	cbnz	r0, 0x1fc2 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x254> @ imm = #0x12
    1fae: 4544         	cmp	r4, r8
    1fb0: f47f aefa    	bne.w	0x1da8 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x3a> @ imm = #-0x20c
    1fb4: 2000         	movs	r0, #0x0
    1fb6: e6fd         	b	0x1db4 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str::h3f1b7ae39157a9e7+0x46> @ imm = #-0x206
    1fb8: 2000         	movs	r0, #0x0
    1fba: b009         	add	sp, #0x24
    1fbc: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    1fc0: bdf0         	pop	{r4, r5, r6, r7, pc}
    1fc2: 2001         	movs	r0, #0x1
    1fc4: b009         	add	sp, #0x24
    1fc6: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    1fca: bdf0         	pop	{r4, r5, r6, r7, pc}

00001fcc <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_char::h1910910b745549e8>:
    1fcc: b5f0         	push	{r4, r5, r6, r7, lr}
    1fce: af03         	add	r7, sp, #0xc
    1fd0: f84d 8d04    	str	r8, [sp, #-4]!
    1fd4: 6885         	ldr	r5, [r0, #0x8]
    1fd6: e9d0 4600    	ldrd	r4, r6, [r0]
    1fda: 7828         	ldrb	r0, [r5]
    1fdc: b178         	cbz	r0, 0x1ffe <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_char::h1910910b745549e8+0x32> @ imm = #0x1e
    1fde: f243 22d8    	movw	r2, #0x32d8
    1fe2: 68f3         	ldr	r3, [r6, #0xc]
    1fe4: f2c0 0200    	movt	r2, #0x0
    1fe8: 4688         	mov	r8, r1
    1fea: 4611         	mov	r1, r2
    1fec: 4620         	mov	r0, r4
    1fee: 2204         	movs	r2, #0x4
    1ff0: 4798         	blx	r3
    1ff2: 4641         	mov	r1, r8
    1ff4: b118         	cbz	r0, 0x1ffe <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_char::h1910910b745549e8+0x32> @ imm = #0x6
    1ff6: 2001         	movs	r0, #0x1
    1ff8: f85d 8b04    	ldr	r8, [sp], #4
    1ffc: bdf0         	pop	{r4, r5, r6, r7, pc}
    1ffe: f1a1 000a    	sub.w	r0, r1, #0xa
    2002: 6932         	ldr	r2, [r6, #0x10]
    2004: fab0 f080    	clz	r0, r0
    2008: 0940         	lsrs	r0, r0, #0x5
    200a: 7028         	strb	r0, [r5]
    200c: 4620         	mov	r0, r4
    200e: f85d 8b04    	ldr	r8, [sp], #4
    2012: e8bd 40f0    	pop.w	{r4, r5, r6, r7, lr}
    2016: 4710         	bx	r2

00002018 <core::fmt::Write::write_fmt::hacddee8258da12f6>:
    2018: b580         	push	{r7, lr}
    201a: 466f         	mov	r7, sp
    201c: 4613         	mov	r3, r2
    201e: 460a         	mov	r2, r1
    2020: f243 2160    	movw	r1, #0x3260
    2024: f2c0 0100    	movt	r1, #0x0
    2028: e8bd 4080    	pop.w	{r7, lr}
    202c: f7fe bffd    	b.w	0x102a <core::fmt::write::h47398c8a992ac39d> @ imm = #-0x1006

00002030 <core::cell::panic_already_borrowed::h855985b225273df1>:
    2030: b580         	push	{r7, lr}
    2032: 466f         	mov	r7, sp
    2034: f000 f800    	bl	0x2038 <core::cell::panic_already_borrowed::do_panic::runtime::h0997781599857a77> @ imm = #0x0

00002038 <core::cell::panic_already_borrowed::do_panic::runtime::h0997781599857a77>:
    2038: b580         	push	{r7, lr}
    203a: 466f         	mov	r7, sp
    203c: b084         	sub	sp, #0x10
    203e: 4602         	mov	r2, r0
    2040: f242 005d    	movw	r0, #0x205d
    2044: f2c0 0000    	movt	r0, #0x0
    2048: a901         	add	r1, sp, #0x4
    204a: 9002         	str	r0, [sp, #0x8]
    204c: 1e78         	subs	r0, r7, #0x1
    204e: 9001         	str	r0, [sp, #0x4]
    2050: f642 60e9    	movw	r0, #0x2ee9
    2054: f2c0 0000    	movt	r0, #0x0
    2058: f7ff f985    	bl	0x1366 <core::panicking::panic_fmt::ha5c8d1aa6e35ad31> @ imm = #-0xcf6

0000205c <<core::cell::BorrowMutError as core::fmt::Display>::fmt::h779f758d54b6c704>:
    205c: b580         	push	{r7, lr}
    205e: 466f         	mov	r7, sp
    2060: 4608         	mov	r0, r1
    2062: f243 21c0    	movw	r1, #0x32c0
    2066: f2c0 0100    	movt	r1, #0x0
    206a: 2218         	movs	r2, #0x18
    206c: e8bd 4080    	pop.w	{r7, lr}
    2070: f7ff b99e    	b.w	0x13b0 <core::fmt::Formatter::pad::h4e7a8b950cefb40f> @ imm = #-0xcc4

00002074 <core::result::unwrap_failed::h7d9f4b8669bb5e40>:
    2074: b580         	push	{r7, lr}
    2076: 466f         	mov	r7, sp
    2078: b088         	sub	sp, #0x20
    207a: 460a         	mov	r2, r1
    207c: f243 0168    	movw	r1, #0x3068
    2080: f2c0 0100    	movt	r1, #0x0
    2084: 9100         	str	r1, [sp]
    2086: f243 0158    	movw	r1, #0x3058
    208a: f2c0 0100    	movt	r1, #0x0
    208e: 9103         	str	r1, [sp, #0xc]
    2090: 212b         	movs	r1, #0x2b
    2092: e9cd 1001    	strd	r1, r0, [sp, #4]
    2096: f641 2003    	movw	r0, #0x1a03
    209a: f2c0 0000    	movt	r0, #0x0
    209e: a904         	add	r1, sp, #0x10
    20a0: 9007         	str	r0, [sp, #0x1c]
    20a2: a802         	add	r0, sp, #0x8
    20a4: 9006         	str	r0, [sp, #0x18]
    20a6: f241 309d    	movw	r0, #0x139d
    20aa: f2c0 0000    	movt	r0, #0x0
    20ae: 9005         	str	r0, [sp, #0x14]
    20b0: 4668         	mov	r0, sp
    20b2: 9004         	str	r0, [sp, #0x10]
    20b4: f642 606a    	movw	r0, #0x2e6a
    20b8: f2c0 0000    	movt	r0, #0x0
    20bc: f7ff f953    	bl	0x1366 <core::panicking::panic_fmt::ha5c8d1aa6e35ad31> @ imm = #-0xd5a

000020c0 <core::panicking::panic_const::panic_const_add_overflow::h4ff4e8f08191f960>:
    20c0: b580         	push	{r7, lr}
    20c2: 466f         	mov	r7, sp
    20c4: 4602         	mov	r2, r0
    20c6: f243 2083    	movw	r0, #0x3283
    20ca: f2c0 0000    	movt	r0, #0x0
    20ce: 2139         	movs	r1, #0x39
    20d0: f7ff f949    	bl	0x1366 <core::panicking::panic_fmt::ha5c8d1aa6e35ad31> @ imm = #-0xd6e

000020d4 <core::panicking::panic_const::panic_const_sub_overflow::hba89adce49baa796>:
    20d4: b580         	push	{r7, lr}
    20d6: 466f         	mov	r7, sp
    20d8: 4602         	mov	r2, r0
    20da: f243 209f    	movw	r0, #0x329f
    20de: f2c0 0000    	movt	r0, #0x0
    20e2: 2143         	movs	r1, #0x43
    20e4: f7ff f93f    	bl	0x1366 <core::panicking::panic_fmt::ha5c8d1aa6e35ad31> @ imm = #-0xd82

000020e8 <WDT>:
    20e8: b580         	push	{r7, lr}
    20ea: 466f         	mov	r7, sp
    20ec: e7fe         	b	0x20ec <WDT+0x4>        @ imm = #-0x4

000020ee <rtt_init_must_not_be_called_multiple_times>:
    20ee: b580         	push	{r7, lr}
    20f0: 466f         	mov	r7, sp
    20f2: bd80         	pop	{r7, pc}

000020f4 <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind>:
    20f4: b580         	push	{r7, lr}
    20f6: 466f         	mov	r7, sp
    20f8: b08c         	sub	sp, #0x30
    20fa: f240 4550    	movw	r5, #0x450
    20fe: 9001         	str	r0, [sp, #0x4]
    2100: f3ef 8010    	mrs	r0, primask
    2104: f2c2 0500    	movt	r5, #0x2000
    2108: b672         	cpsid i
    210a: f3ef 8410    	mrs	r4, primask
    210e: b672         	cpsid i
    2110: 6b28         	ldr	r0, [r5, #0x30]
    2112: 2800         	cmp	r0, #0x0
    2114: f040 8083    	bne.w	0x221e <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0x12a> @ imm = #0x106
    2118: 6b69         	ldr	r1, [r5, #0x34]
    211a: f04f 30ff    	mov.w	r0, #0xffffffff
    211e: 6328         	str	r0, [r5, #0x30]
    2120: 2901         	cmp	r1, #0x1
    2122: d176         	bne	0x2212 <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0x11e> @ imm = #0xec
    2124: 6ba8         	ldr	r0, [r5, #0x38]
    2126: 2202         	movs	r2, #0x2
    2128: 6941         	ldr	r1, [r0, #0x14]
    212a: f3bf 8f5f    	dmb	sy
    212e: f3bf 8f5f    	dmb	sy
    2132: f362 0101    	bfi	r1, r2, #0, #2
    2136: 6141         	str	r1, [r0, #0x14]
    2138: f3bf 8f5f    	dmb	sy
    213c: 6ba8         	ldr	r0, [r5, #0x38]
    213e: 68c1         	ldr	r1, [r0, #0xc]
    2140: f3bf 8f5f    	dmb	sy
    2144: 6902         	ldr	r2, [r0, #0x10]
    2146: f3bf 8f5f    	dmb	sy
    214a: 6883         	ldr	r3, [r0, #0x8]
    214c: 4299         	cmp	r1, r3
    214e: bf38         	it	lo
    2150: 429a         	cmplo	r2, r3
    2152: d30a         	blo	0x216a <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0x76> @ imm = #0x14
    2154: 2100         	movs	r1, #0x0
    2156: f3bf 8f5f    	dmb	sy
    215a: 60c1         	str	r1, [r0, #0xc]
    215c: f3bf 8f5f    	dmb	sy
    2160: f3bf 8f5f    	dmb	sy
    2164: 6101         	str	r1, [r0, #0x10]
    2166: f3bf 8f5f    	dmb	sy
    216a: f895 203c    	ldrb.w	r2, [r5, #0x3c]
    216e: 2600         	movs	r6, #0x0
    2170: f88d 602c    	strb.w	r6, [sp, #0x2c]
    2174: 960a         	str	r6, [sp, #0x28]
    2176: e9cd 0108    	strd	r0, r1, [sp, #32]
    217a: b19a         	cbz	r2, 0x21a4 <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0xb0> @ imm = #0x26
    217c: 6ba8         	ldr	r0, [r5, #0x38]
    217e: f243 01ff    	movw	r1, #0x30ff
    2182: aa02         	add	r2, sp, #0x8
    2184: 2302         	movs	r3, #0x2
    2186: 6940         	ldr	r0, [r0, #0x14]
    2188: f3bf 8f5f    	dmb	sy
    218c: f8ad 1008    	strh.w	r1, [sp, #0x8]
    2190: f000 0103    	and	r1, r0, #0x3
    2194: a808         	add	r0, sp, #0x20
    2196: 2902         	cmp	r1, #0x2
    2198: bf18         	it	ne
    219a: 2100         	movne	r1, #0x0
    219c: f000 f909    	bl	0x23b2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538> @ imm = #0x212
    21a0: f885 603c    	strb.w	r6, [r5, #0x3c]
    21a4: ab08         	add	r3, sp, #0x20
    21a6: f10d 0c0c    	add.w	r12, sp, #0xc
    21aa: f88d 601c    	strb.w	r6, [sp, #0x1c]
    21ae: cb0f         	ldm	r3, {r0, r1, r2, r3}
    21b0: e88c 000f    	stm.w	r12, {r0, r1, r2, r3}
    21b4: f105 003c    	add.w	r0, r5, #0x3c
    21b8: f243 21ec    	movw	r1, #0x32ec
    21bc: 9002         	str	r0, [sp, #0x8]
    21be: f242 202b    	movw	r0, #0x222b
    21c2: f2c0 0000    	movt	r0, #0x0
    21c6: f642 6270    	movw	r2, #0x2e70
    21ca: 9009         	str	r0, [sp, #0x24]
    21cc: a801         	add	r0, sp, #0x4
    21ce: 9008         	str	r0, [sp, #0x20]
    21d0: a802         	add	r0, sp, #0x8
    21d2: ab08         	add	r3, sp, #0x20
    21d4: f2c0 0100    	movt	r1, #0x0
    21d8: f2c0 0200    	movt	r2, #0x0
    21dc: f7fe ff25    	bl	0x102a <core::fmt::write::h47398c8a992ac39d> @ imm = #-0x11b6
    21e0: f89d 0018    	ldrb.w	r0, [sp, #0x18]
    21e4: 2802         	cmp	r0, #0x2
    21e6: d107         	bne	0x21f8 <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0x104> @ imm = #0xe
    21e8: 9802         	ldr	r0, [sp, #0x8]
    21ea: f89d 101c    	ldrb.w	r1, [sp, #0x1c]
    21ee: 7001         	strb	r1, [r0]
    21f0: f89d 0018    	ldrb.w	r0, [sp, #0x18]
    21f4: 2801         	cmp	r0, #0x1
    21f6: d806         	bhi	0x2206 <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0x112> @ imm = #0xc
    21f8: e9dd 0103    	ldrd	r0, r1, [sp, #12]
    21fc: f3bf 8f5f    	dmb	sy
    2200: 60c1         	str	r1, [r0, #0xc]
    2202: f3bf 8f5f    	dmb	sy
    2206: 6b28         	ldr	r0, [r5, #0x30]
    2208: 3001         	adds	r0, #0x1
    220a: 6328         	str	r0, [r5, #0x30]
    220c: 07e0         	lsls	r0, r4, #0x1f
    220e: d004         	beq	0x221a <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0x126> @ imm = #0x8
    2210: e004         	b	0x221c <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0x128> @ imm = #0x8
    2212: 2000         	movs	r0, #0x0
    2214: 6328         	str	r0, [r5, #0x30]
    2216: 07e0         	lsls	r0, r4, #0x1f
    2218: d100         	bne	0x221c <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0x128> @ imm = #0x0
    221a: b662         	cpsie i
    221c: e7fe         	b	0x221c <_RNvCshXwFllX56pT_7___rustc17rust_begin_unwind+0x128> @ imm = #-0x4
    221e: f243 306c    	movw	r0, #0x336c
    2222: f2c0 0000    	movt	r0, #0x0
    2226: f7ff ff03    	bl	0x2030 <core::cell::panic_already_borrowed::h855985b225273df1> @ imm = #-0x1fa

0000222a <<&T as core::fmt::Display>::fmt::h6401ac074059d81b>:
    222a: b5f0         	push	{r4, r5, r6, r7, lr}
    222c: af03         	add	r7, sp, #0xc
    222e: e92d 0b00    	push.w	{r8, r9, r11}
    2232: b088         	sub	sp, #0x20
    2234: e9d1 5400    	ldrd	r5, r4, [r1]
    2238: f243 21dc    	movw	r1, #0x32dc
    223c: 6800         	ldr	r0, [r0]
    223e: f2c0 0100    	movt	r1, #0x0
    2242: f8d4 900c    	ldr.w	r9, [r4, #0xc]
    2246: 220c         	movs	r2, #0xc
    2248: e9d0 8600    	ldrd	r8, r6, [r0]
    224c: 4628         	mov	r0, r5
    224e: 47c8         	blx	r9
    2250: b120         	cbz	r0, 0x225c <<&T as core::fmt::Display>::fmt::h6401ac074059d81b+0x32> @ imm = #0x8
    2252: 2001         	movs	r0, #0x1
    2254: b008         	add	sp, #0x20
    2256: e8bd 0b00    	pop.w	{r8, r9, r11}
    225a: bdf0         	pop	{r4, r5, r6, r7, pc}
    225c: e9d6 0100    	ldrd	r0, r1, [r6]
    2260: f243 023b    	movw	r2, #0x303b
    2264: e9cd 0100    	strd	r0, r1, [sp]
    2268: f641 2013    	movw	r0, #0x1a13
    226c: f106 010c    	add.w	r1, r6, #0xc
    2270: f2c0 0000    	movt	r0, #0x0
    2274: 9007         	str	r0, [sp, #0x1c]
    2276: ab02         	add	r3, sp, #0x8
    2278: e9cd 0105    	strd	r0, r1, [sp, #20]
    227c: f106 0008    	add.w	r0, r6, #0x8
    2280: 9004         	str	r0, [sp, #0x10]
    2282: f241 309d    	movw	r0, #0x139d
    2286: f2c0 0000    	movt	r0, #0x0
    228a: f2c0 0200    	movt	r2, #0x0
    228e: 9003         	str	r0, [sp, #0xc]
    2290: 4668         	mov	r0, sp
    2292: 9002         	str	r0, [sp, #0x8]
    2294: 4628         	mov	r0, r5
    2296: 4621         	mov	r1, r4
    2298: f7fe fec7    	bl	0x102a <core::fmt::write::h47398c8a992ac39d> @ imm = #-0x1272
    229c: b120         	cbz	r0, 0x22a8 <<&T as core::fmt::Display>::fmt::h6401ac074059d81b+0x7e> @ imm = #0x8
    229e: 2001         	movs	r0, #0x1
    22a0: b008         	add	sp, #0x20
    22a2: e8bd 0b00    	pop.w	{r8, r9, r11}
    22a6: bdf0         	pop	{r4, r5, r6, r7, pc}
    22a8: f243 21e8    	movw	r1, #0x32e8
    22ac: 4628         	mov	r0, r5
    22ae: f2c0 0100    	movt	r1, #0x0
    22b2: 2202         	movs	r2, #0x2
    22b4: 47c8         	blx	r9
    22b6: b120         	cbz	r0, 0x22c2 <<&T as core::fmt::Display>::fmt::h6401ac074059d81b+0x98> @ imm = #0x8
    22b8: 2001         	movs	r0, #0x1
    22ba: b008         	add	sp, #0x20
    22bc: e8bd 0b00    	pop.w	{r8, r9, r11}
    22c0: bdf0         	pop	{r4, r5, r6, r7, pc}
    22c2: e9d8 2300    	ldrd	r2, r3, [r8]
    22c6: 4628         	mov	r0, r5
    22c8: 4621         	mov	r1, r4
    22ca: f7fe feae    	bl	0x102a <core::fmt::write::h47398c8a992ac39d> @ imm = #-0x12a4
    22ce: b008         	add	sp, #0x20
    22d0: e8bd 0b00    	pop.w	{r8, r9, r11}
    22d4: bdf0         	pop	{r4, r5, r6, r7, pc}

000022d6 <core::ptr::drop_in_place<rtt_target::TerminalWriter>::h783da4987a8eb506>:
    22d6: b580         	push	{r7, lr}
    22d8: 466f         	mov	r7, sp
    22da: 7c01         	ldrb	r1, [r0, #0x10]
    22dc: 2902         	cmp	r1, #0x2
    22de: d103         	bne	0x22e8 <core::ptr::drop_in_place<rtt_target::TerminalWriter>::h783da4987a8eb506+0x12> @ imm = #0x6
    22e0: 6801         	ldr	r1, [r0]
    22e2: 7d00         	ldrb	r0, [r0, #0x14]
    22e4: 7008         	strb	r0, [r1]
    22e6: bd80         	pop	{r7, pc}
    22e8: e9d0 1201    	ldrd	r1, r2, [r0, #4]
    22ec: f3bf 8f5f    	dmb	sy
    22f0: 60ca         	str	r2, [r1, #0xc]
    22f2: 2102         	movs	r1, #0x2
    22f4: f3bf 8f5f    	dmb	sy
    22f8: 7401         	strb	r1, [r0, #0x10]
    22fa: bd80         	pop	{r7, pc}

000022fc <core::fmt::Write::write_char::h4c8ebdc074a16fea>:
    22fc: b5d0         	push	{r4, r6, r7, lr}
    22fe: af02         	add	r7, sp, #0x8
    2300: b082         	sub	sp, #0x8
    2302: 2200         	movs	r2, #0x0
    2304: 2980         	cmp	r1, #0x80
    2306: 9201         	str	r2, [sp, #0x4]
    2308: d203         	bhs	0x2312 <core::fmt::Write::write_char::h4c8ebdc074a16fea+0x16> @ imm = #0x6
    230a: f88d 1004    	strb.w	r1, [sp, #0x4]
    230e: 2301         	movs	r3, #0x1
    2310: e030         	b	0x2374 <core::fmt::Write::write_char::h4c8ebdc074a16fea+0x78> @ imm = #0x60
    2312: f64f 7cfe    	movw	r12, #0xfffe
    2316: 460b         	mov	r3, r1
    2318: f2c0 3cff    	movt	r12, #0x3ff
    231c: 098a         	lsrs	r2, r1, #0x6
    231e: f36c 139f    	bfi	r3, r12, #6, #26
    2322: f5b1 6f00    	cmp.w	r1, #0x800
    2326: d207         	bhs	0x2338 <core::fmt::Write::write_char::h4c8ebdc074a16fea+0x3c> @ imm = #0xe
    2328: f88d 3005    	strb.w	r3, [sp, #0x5]
    232c: f042 01c0    	orr	r1, r2, #0xc0
    2330: f88d 1004    	strb.w	r1, [sp, #0x4]
    2334: 2302         	movs	r3, #0x2
    2336: e01d         	b	0x2374 <core::fmt::Write::write_char::h4c8ebdc074a16fea+0x78> @ imm = #0x3a
    2338: f36c 129f    	bfi	r2, r12, #6, #26
    233c: ea4f 3e11    	lsr.w	lr, r1, #0xc
    2340: f5b1 3f80    	cmp.w	r1, #0x10000
    2344: d207         	bhs	0x2356 <core::fmt::Write::write_char::h4c8ebdc074a16fea+0x5a> @ imm = #0xe
    2346: f88d 3006    	strb.w	r3, [sp, #0x6]
    234a: 2303         	movs	r3, #0x3
    234c: f04e 01e0    	orr	r1, lr, #0xe0
    2350: f88d 2005    	strb.w	r2, [sp, #0x5]
    2354: e00c         	b	0x2370 <core::fmt::Write::write_char::h4c8ebdc074a16fea+0x74> @ imm = #0x18
    2356: f06f 040f    	mvn	r4, #0xf
    235a: ea44 4191    	orr.w	r1, r4, r1, lsr #18
    235e: f36c 1e9f    	bfi	lr, r12, #6, #26
    2362: f88d 3007    	strb.w	r3, [sp, #0x7]
    2366: f88d 2006    	strb.w	r2, [sp, #0x6]
    236a: 2304         	movs	r3, #0x4
    236c: f88d e005    	strb.w	lr, [sp, #0x5]
    2370: f88d 1004    	strb.w	r1, [sp, #0x4]
    2374: f850 1f04    	ldr	r1, [r0, #4]!
    2378: f243 224c    	movw	r2, #0x324c
    237c: f2c0 0200    	movt	r2, #0x0
    2380: 6949         	ldr	r1, [r1, #0x14]
    2382: f3bf 8f5f    	dmb	sy
    2386: f001 0103    	and	r1, r1, #0x3
    238a: f852 1021    	ldr.w	r1, [r2, r1, lsl #2]
    238e: aa01         	add	r2, sp, #0x4
    2390: f000 f80f    	bl	0x23b2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538> @ imm = #0x1e
    2394: 2000         	movs	r0, #0x0
    2396: b002         	add	sp, #0x8
    2398: bdd0         	pop	{r4, r6, r7, pc}

0000239a <core::fmt::Write::write_fmt::hd97e300230ebddf6>:
    239a: b580         	push	{r7, lr}
    239c: 466f         	mov	r7, sp
    239e: 4613         	mov	r3, r2
    23a0: 460a         	mov	r2, r1
    23a2: f243 21ec    	movw	r1, #0x32ec
    23a6: f2c0 0100    	movt	r1, #0x0
    23aa: e8bd 4080    	pop.w	{r7, lr}
    23ae: f7fe be3c    	b.w	0x102a <core::fmt::write::h47398c8a992ac39d> @ imm = #-0x1388

000023b2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538>:
    23b2: b5f0         	push	{r4, r5, r6, r7, lr}
    23b4: af03         	add	r7, sp, #0xc
    23b6: e92d 0f00    	push.w	{r8, r9, r10, r11}
    23ba: b081         	sub	sp, #0x4
    23bc: 4605         	mov	r5, r0
    23be: 7b00         	ldrb	r0, [r0, #0xc]
    23c0: 2800         	cmp	r0, #0x0
    23c2: d178         	bne	0x24b6 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x104> @ imm = #0xf0
    23c4: 2b00         	cmp	r3, #0x0
    23c6: d076         	beq	0x24b6 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x104> @ imm = #0xec
    23c8: f8d5 8000    	ldr.w	r8, [r5]
    23cc: 4689         	mov	r9, r1
    23ce: 2600         	movs	r6, #0x0
    23d0: f8d8 400c    	ldr.w	r4, [r8, #0xc]
    23d4: f3bf 8f5f    	dmb	sy
    23d8: f8d8 1010    	ldr.w	r1, [r8, #0x10]
    23dc: f3bf 8f5f    	dmb	sy
    23e0: f8d8 0008    	ldr.w	r0, [r8, #0x8]
    23e4: 4284         	cmp	r4, r0
    23e6: bf38         	it	lo
    23e8: 4281         	cmplo	r1, r0
    23ea: d315         	blo	0x2418 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x66> @ imm = #0x2a
    23ec: f3bf 8f5f    	dmb	sy
    23f0: f8c8 600c    	str.w	r6, [r8, #0xc]
    23f4: f3bf 8f5f    	dmb	sy
    23f8: f3bf 8f5f    	dmb	sy
    23fc: f8c8 6010    	str.w	r6, [r8, #0x10]
    2400: f3bf 8f5f    	dmb	sy
    2404: f8d5 a004    	ldr.w	r10, [r5, #0x4]
    2408: 4550         	cmp	r0, r10
    240a: d358         	blo	0x24be <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x10c> @ imm = #0xb0
    240c: d057         	beq	0x24be <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x10c> @ imm = #0xae
    240e: ea6f 010a    	mvn.w	r1, r10
    2412: 1844         	adds	r4, r0, r1
    2414: b144         	cbz	r4, 0x2428 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x76> @ imm = #0x10
    2416: e01e         	b	0x2456 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0xa4> @ imm = #0x3c
    2418: f8d5 a004    	ldr.w	r10, [r5, #0x4]
    241c: 4551         	cmp	r1, r10
    241e: d912         	bls	0x2446 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x94> @ imm = #0x24
    2420: ea6f 000a    	mvn.w	r0, r10
    2424: 180c         	adds	r4, r1, r0
    2426: b9b4         	cbnz	r4, 0x2456 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0xa4> @ imm = #0x2c
    2428: f1b9 0f02    	cmp.w	r9, #0x2
    242c: d119         	bne	0x2462 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0xb0> @ imm = #0x32
    242e: f8d5 8000    	ldr.w	r8, [r5]
    2432: f3bf 8f5f    	dmb	sy
    2436: f8c8 a00c    	str.w	r10, [r8, #0xc]
    243a: f3bf 8f5f    	dmb	sy
    243e: 7b28         	ldrb	r0, [r5, #0xc]
    2440: 2800         	cmp	r0, #0x0
    2442: d0c5         	beq	0x23d0 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x1e> @ imm = #-0x76
    2444: e037         	b	0x24b6 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x104> @ imm = #0x6e
    2446: 2900         	cmp	r1, #0x0
    2448: d0de         	beq	0x2408 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x56> @ imm = #-0x44
    244a: 4550         	cmp	r0, r10
    244c: d33d         	blo	0x24ca <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x118> @ imm = #0x7a
    244e: eba0 040a    	sub.w	r4, r0, r10
    2452: 2c00         	cmp	r4, #0x0
    2454: d0e8         	beq	0x2428 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x76> @ imm = #-0x30
    2456: 2600         	movs	r6, #0x0
    2458: 42a3         	cmp	r3, r4
    245a: 9300         	str	r3, [sp]
    245c: bf38         	it	lo
    245e: 461c         	movlo	r4, r3
    2460: e007         	b	0x2472 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0xc0> @ imm = #0xe
    2462: f1b9 0f00    	cmp.w	r9, #0x0
    2466: d024         	beq	0x24b2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x100> @ imm = #0x48
    2468: 2001         	movs	r0, #0x1
    246a: 9300         	str	r3, [sp]
    246c: 2600         	movs	r6, #0x0
    246e: 7328         	strb	r0, [r5, #0xc]
    2470: 2400         	movs	r4, #0x0
    2472: f8d5 8000    	ldr.w	r8, [r5]
    2476: 4693         	mov	r11, r2
    2478: 4611         	mov	r1, r2
    247a: 4622         	mov	r2, r4
    247c: f8d8 0004    	ldr.w	r0, [r8, #0x4]
    2480: 4450         	add	r0, r10
    2482: f000 f99e    	bl	0x27c2 <__aeabi_memcpy> @ imm = #0x33c
    2486: eb1a 0004    	adds.w	r0, r10, r4
    248a: d224         	bhs	0x24d6 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x124> @ imm = #0x48
    248c: 68a9         	ldr	r1, [r5, #0x8]
    248e: 6068         	str	r0, [r5, #0x4]
    2490: 1909         	adds	r1, r1, r4
    2492: d226         	bhs	0x24e2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x130> @ imm = #0x4c
    2494: f8d8 2008    	ldr.w	r2, [r8, #0x8]
    2498: 60a9         	str	r1, [r5, #0x8]
    249a: 4290         	cmp	r0, r2
    249c: 9b00         	ldr	r3, [sp]
    249e: bf28         	it	hs
    24a0: 606e         	strhs	r6, [r5, #0x4]
    24a2: 465a         	mov	r2, r11
    24a4: 7b28         	ldrb	r0, [r5, #0xc]
    24a6: b930         	cbnz	r0, 0x24b6 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x104> @ imm = #0xc
    24a8: 4422         	add	r2, r4
    24aa: 1b1b         	subs	r3, r3, r4
    24ac: f47f af90    	bne.w	0x23d0 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x1e> @ imm = #-0xe0
    24b0: e001         	b	0x24b6 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538+0x104> @ imm = #0x2
    24b2: 2002         	movs	r0, #0x2
    24b4: 7328         	strb	r0, [r5, #0xc]
    24b6: b001         	add	sp, #0x4
    24b8: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    24bc: bdf0         	pop	{r4, r5, r6, r7, pc}
    24be: f243 3034    	movw	r0, #0x3334
    24c2: f2c0 0000    	movt	r0, #0x0
    24c6: f7ff fe05    	bl	0x20d4 <core::panicking::panic_const::panic_const_sub_overflow::hba89adce49baa796> @ imm = #-0x3f6
    24ca: f243 3024    	movw	r0, #0x3324
    24ce: f2c0 0000    	movt	r0, #0x0
    24d2: f7ff fdff    	bl	0x20d4 <core::panicking::panic_const::panic_const_sub_overflow::hba89adce49baa796> @ imm = #-0x402
    24d6: f243 3004    	movw	r0, #0x3304
    24da: f2c0 0000    	movt	r0, #0x0
    24de: f7ff fdef    	bl	0x20c0 <core::panicking::panic_const::panic_const_add_overflow::h4ff4e8f08191f960> @ imm = #-0x422
    24e2: f243 3014    	movw	r0, #0x3314
    24e6: f2c0 0000    	movt	r0, #0x0
    24ea: f7ff fde9    	bl	0x20c0 <core::panicking::panic_const::panic_const_add_overflow::h4ff4e8f08191f960> @ imm = #-0x42e

000024ee <core::ptr::drop_in_place<rtt_target::TerminalWriter>::h1150aecd9db9fd68>:
    24ee: b580         	push	{r7, lr}
    24f0: 466f         	mov	r7, sp
    24f2: 7c01         	ldrb	r1, [r0, #0x10]
    24f4: 2902         	cmp	r1, #0x2
    24f6: d103         	bne	0x2500 <core::ptr::drop_in_place<rtt_target::TerminalWriter>::h1150aecd9db9fd68+0x12> @ imm = #0x6
    24f8: 6801         	ldr	r1, [r0]
    24fa: 7d00         	ldrb	r0, [r0, #0x14]
    24fc: 7008         	strb	r0, [r1]
    24fe: bd80         	pop	{r7, pc}
    2500: e9d0 1201    	ldrd	r1, r2, [r0, #4]
    2504: f3bf 8f5f    	dmb	sy
    2508: 60ca         	str	r2, [r1, #0xc]
    250a: 2102         	movs	r1, #0x2
    250c: f3bf 8f5f    	dmb	sy
    2510: 7401         	strb	r1, [r0, #0x10]
    2512: bd80         	pop	{r7, pc}

00002514 <<rtt_target::TerminalWriter as core::fmt::Write>::write_str::h4e59a78db6600d93>:
    2514: b580         	push	{r7, lr}
    2516: 466f         	mov	r7, sp
    2518: 4694         	mov	r12, r2
    251a: 460a         	mov	r2, r1
    251c: f850 1f04    	ldr	r1, [r0, #4]!
    2520: f243 234c    	movw	r3, #0x324c
    2524: f2c0 0300    	movt	r3, #0x0
    2528: 6949         	ldr	r1, [r1, #0x14]
    252a: f001 0103    	and	r1, r1, #0x3
    252e: f853 1021    	ldr.w	r1, [r3, r1, lsl #2]
    2532: 4663         	mov	r3, r12
    2534: f3bf 8f5f    	dmb	sy
    2538: f7ff ff3b    	bl	0x23b2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538> @ imm = #-0x18a
    253c: 2000         	movs	r0, #0x0
    253e: bd80         	pop	{r7, pc}

00002540 <core::fmt::Write::write_char::hc9328ad6813ab49c>:
    2540: b5d0         	push	{r4, r6, r7, lr}
    2542: af02         	add	r7, sp, #0x8
    2544: b082         	sub	sp, #0x8
    2546: 2200         	movs	r2, #0x0
    2548: 2980         	cmp	r1, #0x80
    254a: 9201         	str	r2, [sp, #0x4]
    254c: d203         	bhs	0x2556 <core::fmt::Write::write_char::hc9328ad6813ab49c+0x16> @ imm = #0x6
    254e: f88d 1004    	strb.w	r1, [sp, #0x4]
    2552: 2301         	movs	r3, #0x1
    2554: e030         	b	0x25b8 <core::fmt::Write::write_char::hc9328ad6813ab49c+0x78> @ imm = #0x60
    2556: f64f 7cfe    	movw	r12, #0xfffe
    255a: 460b         	mov	r3, r1
    255c: f2c0 3cff    	movt	r12, #0x3ff
    2560: 098a         	lsrs	r2, r1, #0x6
    2562: f36c 139f    	bfi	r3, r12, #6, #26
    2566: f5b1 6f00    	cmp.w	r1, #0x800
    256a: d207         	bhs	0x257c <core::fmt::Write::write_char::hc9328ad6813ab49c+0x3c> @ imm = #0xe
    256c: f88d 3005    	strb.w	r3, [sp, #0x5]
    2570: f042 01c0    	orr	r1, r2, #0xc0
    2574: f88d 1004    	strb.w	r1, [sp, #0x4]
    2578: 2302         	movs	r3, #0x2
    257a: e01d         	b	0x25b8 <core::fmt::Write::write_char::hc9328ad6813ab49c+0x78> @ imm = #0x3a
    257c: f36c 129f    	bfi	r2, r12, #6, #26
    2580: ea4f 3e11    	lsr.w	lr, r1, #0xc
    2584: f5b1 3f80    	cmp.w	r1, #0x10000
    2588: d207         	bhs	0x259a <core::fmt::Write::write_char::hc9328ad6813ab49c+0x5a> @ imm = #0xe
    258a: f88d 3006    	strb.w	r3, [sp, #0x6]
    258e: 2303         	movs	r3, #0x3
    2590: f04e 01e0    	orr	r1, lr, #0xe0
    2594: f88d 2005    	strb.w	r2, [sp, #0x5]
    2598: e00c         	b	0x25b4 <core::fmt::Write::write_char::hc9328ad6813ab49c+0x74> @ imm = #0x18
    259a: f06f 040f    	mvn	r4, #0xf
    259e: ea44 4191    	orr.w	r1, r4, r1, lsr #18
    25a2: f36c 1e9f    	bfi	lr, r12, #6, #26
    25a6: f88d 3007    	strb.w	r3, [sp, #0x7]
    25aa: f88d 2006    	strb.w	r2, [sp, #0x6]
    25ae: 2304         	movs	r3, #0x4
    25b0: f88d e005    	strb.w	lr, [sp, #0x5]
    25b4: f88d 1004    	strb.w	r1, [sp, #0x4]
    25b8: f850 1f04    	ldr	r1, [r0, #4]!
    25bc: f243 224c    	movw	r2, #0x324c
    25c0: f2c0 0200    	movt	r2, #0x0
    25c4: 6949         	ldr	r1, [r1, #0x14]
    25c6: f3bf 8f5f    	dmb	sy
    25ca: f001 0103    	and	r1, r1, #0x3
    25ce: f852 1021    	ldr.w	r1, [r2, r1, lsl #2]
    25d2: aa01         	add	r2, sp, #0x4
    25d4: f7ff feed    	bl	0x23b2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538> @ imm = #-0x226
    25d8: 2000         	movs	r0, #0x0
    25da: b002         	add	sp, #0x8
    25dc: bdd0         	pop	{r4, r6, r7, pc}

000025de <core::fmt::Write::write_fmt::h9e5590775ab9acb3>:
    25de: b580         	push	{r7, lr}
    25e0: 466f         	mov	r7, sp
    25e2: 4613         	mov	r3, r2
    25e4: 460a         	mov	r2, r1
    25e6: f243 3144    	movw	r1, #0x3344
    25ea: f2c0 0100    	movt	r1, #0x0
    25ee: e8bd 4080    	pop.w	{r7, lr}
    25f2: f7fe bd1a    	b.w	0x102a <core::fmt::write::h47398c8a992ac39d> @ imm = #-0x15cc

000025f6 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c>:
    25f6: b5f0         	push	{r4, r5, r6, r7, lr}
    25f8: af03         	add	r7, sp, #0xc
    25fa: e92d 0700    	push.w	{r8, r9, r10}
    25fe: b08a         	sub	sp, #0x28
    2600: f240 4450    	movw	r4, #0x450
    2604: f3ef 8a10    	mrs	r10, primask
    2608: b672         	cpsid i
    260a: 4681         	mov	r9, r0
    260c: f2c2 0400    	movt	r4, #0x2000
    2610: 6b20         	ldr	r0, [r4, #0x30]
    2612: 2800         	cmp	r0, #0x0
    2614: d178         	bne	0x2708 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c+0x112> @ imm = #0xf0
    2616: 4688         	mov	r8, r1
    2618: 6b61         	ldr	r1, [r4, #0x34]
    261a: f04f 30ff    	mov.w	r0, #0xffffffff
    261e: 2901         	cmp	r1, #0x1
    2620: 6320         	str	r0, [r4, #0x30]
    2622: d159         	bne	0x26d8 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c+0xe2> @ imm = #0xb2
    2624: 6ba0         	ldr	r0, [r4, #0x38]
    2626: 68c1         	ldr	r1, [r0, #0xc]
    2628: f3bf 8f5f    	dmb	sy
    262c: 6902         	ldr	r2, [r0, #0x10]
    262e: f3bf 8f5f    	dmb	sy
    2632: 6883         	ldr	r3, [r0, #0x8]
    2634: 4299         	cmp	r1, r3
    2636: bf38         	it	lo
    2638: 429a         	cmplo	r2, r3
    263a: d30a         	blo	0x2652 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c+0x5c> @ imm = #0x14
    263c: 2100         	movs	r1, #0x0
    263e: f3bf 8f5f    	dmb	sy
    2642: 60c1         	str	r1, [r0, #0xc]
    2644: f3bf 8f5f    	dmb	sy
    2648: f3bf 8f5f    	dmb	sy
    264c: 6101         	str	r1, [r0, #0x10]
    264e: f3bf 8f5f    	dmb	sy
    2652: f894 203c    	ldrb.w	r2, [r4, #0x3c]
    2656: 2500         	movs	r5, #0x0
    2658: f88d 5024    	strb.w	r5, [sp, #0x24]
    265c: 9508         	str	r5, [sp, #0x20]
    265e: e9cd 0106    	strd	r0, r1, [sp, #24]
    2662: b19a         	cbz	r2, 0x268c <rtt_target::print::print_impl::write_str::h819933bc62d8f74c+0x96> @ imm = #0x26
    2664: 6ba0         	ldr	r0, [r4, #0x38]
    2666: f243 01ff    	movw	r1, #0x30ff
    266a: 466a         	mov	r2, sp
    266c: 2302         	movs	r3, #0x2
    266e: 6940         	ldr	r0, [r0, #0x14]
    2670: f3bf 8f5f    	dmb	sy
    2674: f8ad 1000    	strh.w	r1, [sp]
    2678: f000 0103    	and	r1, r0, #0x3
    267c: a806         	add	r0, sp, #0x18
    267e: 2902         	cmp	r1, #0x2
    2680: bf18         	it	ne
    2682: 2100         	movne	r1, #0x0
    2684: f7ff fe95    	bl	0x23b2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538> @ imm = #-0x2d6
    2688: f884 503c    	strb.w	r5, [r4, #0x3c]
    268c: ab06         	add	r3, sp, #0x18
    268e: f10d 0c08    	add.w	r12, sp, #0x8
    2692: f104 063c    	add.w	r6, r4, #0x3c
    2696: f88d 5014    	strb.w	r5, [sp, #0x14]
    269a: cb0f         	ldm	r3, {r0, r1, r2, r3}
    269c: e88c 000e    	stm.w	r12, {r1, r2, r3}
    26a0: f243 214c    	movw	r1, #0x324c
    26a4: f2c0 0100    	movt	r1, #0x0
    26a8: e9cd 6000    	strd	r6, r0, [sp]
    26ac: 464a         	mov	r2, r9
    26ae: 6940         	ldr	r0, [r0, #0x14]
    26b0: f3bf 8f5f    	dmb	sy
    26b4: 4643         	mov	r3, r8
    26b6: f000 0003    	and	r0, r0, #0x3
    26ba: f851 1020    	ldr.w	r1, [r1, r0, lsl #2]
    26be: 4668         	mov	r0, sp
    26c0: 3004         	adds	r0, #0x4
    26c2: f7ff fe76    	bl	0x23b2 <rtt_target::rtt::RttWriter::write_with_mode::h9719a476be336538> @ imm = #-0x314
    26c6: f89d 0010    	ldrb.w	r0, [sp, #0x10]
    26ca: 2802         	cmp	r0, #0x2
    26cc: d10a         	bne	0x26e4 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c+0xee> @ imm = #0x14
    26ce: 9800         	ldr	r0, [sp]
    26d0: f89d 1014    	ldrb.w	r1, [sp, #0x14]
    26d4: 7001         	strb	r1, [r0]
    26d6: e00c         	b	0x26f2 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c+0xfc> @ imm = #0x18
    26d8: 2000         	movs	r0, #0x0
    26da: 6320         	str	r0, [r4, #0x30]
    26dc: ea5f 70ca    	lsls.w	r0, r10, #0x1f
    26e0: d00d         	beq	0x26fe <rtt_target::print::print_impl::write_str::h819933bc62d8f74c+0x108> @ imm = #0x1a
    26e2: e00d         	b	0x2700 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c+0x10a> @ imm = #0x1a
    26e4: e9dd 0101    	ldrd	r0, r1, [sp, #4]
    26e8: f3bf 8f5f    	dmb	sy
    26ec: 60c1         	str	r1, [r0, #0xc]
    26ee: f3bf 8f5f    	dmb	sy
    26f2: 6b20         	ldr	r0, [r4, #0x30]
    26f4: 3001         	adds	r0, #0x1
    26f6: 6320         	str	r0, [r4, #0x30]
    26f8: ea5f 70ca    	lsls.w	r0, r10, #0x1f
    26fc: d100         	bne	0x2700 <rtt_target::print::print_impl::write_str::h819933bc62d8f74c+0x10a> @ imm = #0x0
    26fe: b662         	cpsie i
    2700: b00a         	add	sp, #0x28
    2702: e8bd 0700    	pop.w	{r8, r9, r10}
    2706: bdf0         	pop	{r4, r5, r6, r7, pc}
    2708: f243 306c    	movw	r0, #0x336c
    270c: f2c0 0000    	movt	r0, #0x0
    2710: f7ff fc8e    	bl	0x2030 <core::cell::panic_already_borrowed::h855985b225273df1> @ imm = #-0x6e4

00002714 <__aeabi_memclr4>:
    2714: b580         	push	{r7, lr}
    2716: 466f         	mov	r7, sp
    2718: 2904         	cmp	r1, #0x4
    271a: d305         	blo	0x2728 <__aeabi_memclr4+0x14> @ imm = #0xa
    271c: 1f0b         	subs	r3, r1, #0x4
    271e: 43da         	mvns	r2, r3
    2720: f012 0f0c    	tst.w	r2, #0xc
    2724: d102         	bne	0x272c <__aeabi_memclr4+0x18> @ imm = #0x4
    2726: e01a         	b	0x275e <__aeabi_memclr4+0x4a> @ imm = #0x34
    2728: 4602         	mov	r2, r0
    272a: e024         	b	0x2776 <__aeabi_memclr4+0x62> @ imm = #0x48
    272c: f04f 0c00    	mov.w	r12, #0x0
    2730: 4602         	mov	r2, r0
    2732: f842 cb04    	str	r12, [r2], #4
    2736: f013 0f0c    	tst.w	r3, #0xc
    273a: d008         	beq	0x274e <__aeabi_memclr4+0x3a> @ imm = #0x10
    273c: f003 020c    	and	r2, r3, #0xc
    2740: f8c0 c004    	str.w	r12, [r0, #0x4]
    2744: 2a04         	cmp	r2, #0x4
    2746: d105         	bne	0x2754 <__aeabi_memclr4+0x40> @ imm = #0xa
    2748: 3908         	subs	r1, #0x8
    274a: 3008         	adds	r0, #0x8
    274c: e006         	b	0x275c <__aeabi_memclr4+0x48> @ imm = #0xc
    274e: 4619         	mov	r1, r3
    2750: 4610         	mov	r0, r2
    2752: e004         	b	0x275e <__aeabi_memclr4+0x4a> @ imm = #0x8
    2754: 2200         	movs	r2, #0x0
    2756: 390c         	subs	r1, #0xc
    2758: 6082         	str	r2, [r0, #0x8]
    275a: 300c         	adds	r0, #0xc
    275c: 4602         	mov	r2, r0
    275e: 2b0c         	cmp	r3, #0xc
    2760: d309         	blo	0x2776 <__aeabi_memclr4+0x62> @ imm = #0x12
    2762: 2300         	movs	r3, #0x0
    2764: 4602         	mov	r2, r0
    2766: 3910         	subs	r1, #0x10
    2768: e9c2 3300    	strd	r3, r3, [r2]
    276c: e9c2 3302    	strd	r3, r3, [r2, #8]
    2770: 3210         	adds	r2, #0x10
    2772: 2903         	cmp	r1, #0x3
    2774: d8f7         	bhi	0x2766 <__aeabi_memclr4+0x52> @ imm = #-0x12
    2776: 1850         	adds	r0, r2, r1
    2778: 4282         	cmp	r2, r0
    277a: d221         	bhs	0x27c0 <__aeabi_memclr4+0xac> @ imm = #0x42
    277c: f1a1 0c01    	sub.w	r12, r1, #0x1
    2780: f011 0303    	ands	r3, r1, #0x3
    2784: d00c         	beq	0x27a0 <__aeabi_memclr4+0x8c> @ imm = #0x18
    2786: f04f 0e00    	mov.w	lr, #0x0
    278a: 4611         	mov	r1, r2
    278c: f801 eb01    	strb	lr, [r1], #1
    2790: 2b01         	cmp	r3, #0x1
    2792: d00a         	beq	0x27aa <__aeabi_memclr4+0x96> @ imm = #0x14
    2794: 2b02         	cmp	r3, #0x2
    2796: f882 e001    	strb.w	lr, [r2, #0x1]
    279a: d103         	bne	0x27a4 <__aeabi_memclr4+0x90> @ imm = #0x6
    279c: 1c91         	adds	r1, r2, #0x2
    279e: e004         	b	0x27aa <__aeabi_memclr4+0x96> @ imm = #0x8
    27a0: 4611         	mov	r1, r2
    27a2: e002         	b	0x27aa <__aeabi_memclr4+0x96> @ imm = #0x4
    27a4: 2100         	movs	r1, #0x0
    27a6: 7091         	strb	r1, [r2, #0x2]
    27a8: 1cd1         	adds	r1, r2, #0x3
    27aa: f1bc 0f03    	cmp.w	r12, #0x3
    27ae: bf38         	it	lo
    27b0: bd80         	poplo	{r7, pc}
    27b2: 3904         	subs	r1, #0x4
    27b4: 2200         	movs	r2, #0x0
    27b6: f841 2f04    	str	r2, [r1, #4]!
    27ba: 1d0b         	adds	r3, r1, #0x4
    27bc: 4283         	cmp	r3, r0
    27be: d1fa         	bne	0x27b6 <__aeabi_memclr4+0xa2> @ imm = #-0xc
    27c0: bd80         	pop	{r7, pc}

000027c2 <__aeabi_memcpy>:
    27c2: b580         	push	{r7, lr}
    27c4: 466f         	mov	r7, sp
    27c6: e8bd 4080    	pop.w	{r7, lr}
    27ca: f000 b800    	b.w	0x27ce <compiler_builtins::mem::memcpy::h76d83c5a68c1995d> @ imm = #0x0

000027ce <compiler_builtins::mem::memcpy::h76d83c5a68c1995d>:
    27ce: b5f0         	push	{r4, r5, r6, r7, lr}
    27d0: af03         	add	r7, sp, #0xc
    27d2: e92d 0f00    	push.w	{r8, r9, r10, r11}
    27d6: b08c         	sub	sp, #0x30
    27d8: 2a10         	cmp	r2, #0x10
    27da: d31e         	blo	0x281a <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x4c> @ imm = #0x3c
    27dc: 4243         	rsbs	r3, r0, #0
    27de: f003 0803    	and	r8, r3, #0x3
    27e2: eb00 0308    	add.w	r3, r0, r8
    27e6: 4298         	cmp	r0, r3
    27e8: d233         	bhs	0x2852 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x84> @ imm = #0x66
    27ea: f1a8 0c01    	sub.w	r12, r8, #0x1
    27ee: 4606         	mov	r6, r0
    27f0: 460c         	mov	r4, r1
    27f2: f1b8 0f00    	cmp.w	r8, #0x0
    27f6: d01a         	beq	0x282e <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x60> @ imm = #0x34
    27f8: 460c         	mov	r4, r1
    27fa: 4606         	mov	r6, r0
    27fc: f814 eb01    	ldrb	lr, [r4], #1
    2800: f1b8 0f01    	cmp.w	r8, #0x1
    2804: f806 eb01    	strb	lr, [r6], #1
    2808: d011         	beq	0x282e <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x60> @ imm = #0x22
    280a: 784e         	ldrb	r6, [r1, #0x1]
    280c: f1b8 0f02    	cmp.w	r8, #0x2
    2810: 7046         	strb	r6, [r0, #0x1]
    2812: d108         	bne	0x2826 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x58> @ imm = #0x10
    2814: 1c8c         	adds	r4, r1, #0x2
    2816: 1c86         	adds	r6, r0, #0x2
    2818: e009         	b	0x282e <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x60> @ imm = #0x12
    281a: 4684         	mov	r12, r0
    281c: eb0c 0302    	add.w	r3, r12, r2
    2820: 459c         	cmp	r12, r3
    2822: d340         	blo	0x28a6 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0xd8> @ imm = #0x80
    2824: e06c         	b	0x2900 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x132> @ imm = #0xd8
    2826: 788e         	ldrb	r6, [r1, #0x2]
    2828: 1ccc         	adds	r4, r1, #0x3
    282a: 7086         	strb	r6, [r0, #0x2]
    282c: 1cc6         	adds	r6, r0, #0x3
    282e: f1bc 0f03    	cmp.w	r12, #0x3
    2832: d30e         	blo	0x2852 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x84> @ imm = #0x1c
    2834: 3c04         	subs	r4, #0x4
    2836: 3e04         	subs	r6, #0x4
    2838: f814 5f04    	ldrb	r5, [r4, #4]!
    283c: f806 5f04    	strb	r5, [r6, #4]!
    2840: 7865         	ldrb	r5, [r4, #0x1]
    2842: 7075         	strb	r5, [r6, #0x1]
    2844: 78a5         	ldrb	r5, [r4, #0x2]
    2846: 70b5         	strb	r5, [r6, #0x2]
    2848: 78e5         	ldrb	r5, [r4, #0x3]
    284a: 70f5         	strb	r5, [r6, #0x3]
    284c: 1d35         	adds	r5, r6, #0x4
    284e: 429d         	cmp	r5, r3
    2850: d1f2         	bne	0x2838 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x6a> @ imm = #-0x1c
    2852: eba2 0e08    	sub.w	lr, r2, r8
    2856: eb01 0408    	add.w	r4, r1, r8
    285a: f02e 0203    	bic	r2, lr, #0x3
    285e: f014 0603    	ands	r6, r4, #0x3
    2862: eb03 0c02    	add.w	r12, r3, r2
    2866: d159         	bne	0x291c <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x14e> @ imm = #0xb2
    2868: 4563         	cmp	r3, r12
    286a: d215         	bhs	0x2898 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0xca> @ imm = #0x2a
    286c: 4621         	mov	r1, r4
    286e: 680d         	ldr	r5, [r1]
    2870: f843 5b04    	str	r5, [r3], #4
    2874: 4563         	cmp	r3, r12
    2876: d20f         	bhs	0x2898 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0xca> @ imm = #0x1e
    2878: 684d         	ldr	r5, [r1, #0x4]
    287a: f843 5b04    	str	r5, [r3], #4
    287e: 4563         	cmp	r3, r12
    2880: bf3e         	ittt	lo
    2882: 688d         	ldrlo	r5, [r1, #0x8]
    2884: f843 5b04    	strlo	r5, [r3], #4
    2888: 4563         	cmplo	r3, r12
    288a: d205         	bhs	0x2898 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0xca> @ imm = #0xa
    288c: 68cd         	ldr	r5, [r1, #0xc]
    288e: 3110         	adds	r1, #0x10
    2890: f843 5b04    	str	r5, [r3], #4
    2894: 4563         	cmp	r3, r12
    2896: d3ea         	blo	0x286e <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0xa0> @ imm = #-0x2c
    2898: 18a1         	adds	r1, r4, r2
    289a: f00e 0203    	and	r2, lr, #0x3
    289e: eb0c 0302    	add.w	r3, r12, r2
    28a2: 459c         	cmp	r12, r3
    28a4: d22c         	bhs	0x2900 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x132> @ imm = #0x58
    28a6: f1a2 0e01    	sub.w	lr, r2, #0x1
    28aa: f012 0403    	ands	r4, r2, #0x3
    28ae: d013         	beq	0x28d8 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x10a> @ imm = #0x26
    28b0: 460a         	mov	r2, r1
    28b2: 4665         	mov	r5, r12
    28b4: f812 6b01    	ldrb	r6, [r2], #1
    28b8: 2c01         	cmp	r4, #0x1
    28ba: f805 6b01    	strb	r6, [r5], #1
    28be: d00d         	beq	0x28dc <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x10e> @ imm = #0x1a
    28c0: 784a         	ldrb	r2, [r1, #0x1]
    28c2: 2c02         	cmp	r4, #0x2
    28c4: f88c 2001    	strb.w	r2, [r12, #0x1]
    28c8: d11e         	bne	0x2908 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x13a> @ imm = #0x3c
    28ca: 1c8a         	adds	r2, r1, #0x2
    28cc: f10c 0502    	add.w	r5, r12, #0x2
    28d0: f1be 0f03    	cmp.w	lr, #0x3
    28d4: d205         	bhs	0x28e2 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x114> @ imm = #0xa
    28d6: e013         	b	0x2900 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x132> @ imm = #0x26
    28d8: 4665         	mov	r5, r12
    28da: 460a         	mov	r2, r1
    28dc: f1be 0f03    	cmp.w	lr, #0x3
    28e0: d30e         	blo	0x2900 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x132> @ imm = #0x1c
    28e2: 1f11         	subs	r1, r2, #0x4
    28e4: 1f2a         	subs	r2, r5, #0x4
    28e6: f811 6f04    	ldrb	r6, [r1, #4]!
    28ea: f802 6f04    	strb	r6, [r2, #4]!
    28ee: 784e         	ldrb	r6, [r1, #0x1]
    28f0: 7056         	strb	r6, [r2, #0x1]
    28f2: 788e         	ldrb	r6, [r1, #0x2]
    28f4: 7096         	strb	r6, [r2, #0x2]
    28f6: 78ce         	ldrb	r6, [r1, #0x3]
    28f8: 70d6         	strb	r6, [r2, #0x3]
    28fa: 1d16         	adds	r6, r2, #0x4
    28fc: 429e         	cmp	r6, r3
    28fe: d1f2         	bne	0x28e6 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x118> @ imm = #-0x1c
    2900: b00c         	add	sp, #0x30
    2902: e8bd 0f00    	pop.w	{r8, r9, r10, r11}
    2906: bdf0         	pop	{r4, r5, r6, r7, pc}
    2908: 788a         	ldrb	r2, [r1, #0x2]
    290a: f10c 0503    	add.w	r5, r12, #0x3
    290e: f88c 2002    	strb.w	r2, [r12, #0x2]
    2912: 1cca         	adds	r2, r1, #0x3
    2914: f1be 0f03    	cmp.w	lr, #0x3
    2918: d2e3         	bhs	0x28e2 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x114> @ imm = #-0x3a
    291a: e7f1         	b	0x2900 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x132> @ imm = #-0x1e
    291c: f04f 0900    	mov.w	r9, #0x0
    2920: f1c6 0a04    	rsb.w	r10, r6, #0x4
    2924: ad0b         	add	r5, sp, #0x2c
    2926: f8cd 902c    	str.w	r9, [sp, #0x2c]
    292a: eb05 0b06    	add.w	r11, r5, r6
    292e: ea5f 75ca    	lsls.w	r5, r10, #0x1f
    2932: bf1e         	ittt	ne
    2934: 7825         	ldrbne	r5, [r4]
    2936: f88b 5000    	strbne.w	r5, [r11]
    293a: f04f 0901    	movne.w	r9, #0x1
    293e: 1ba5         	subs	r5, r4, r6
    2940: 9507         	str	r5, [sp, #0x1c]
    2942: 00f5         	lsls	r5, r6, #0x3
    2944: 9501         	str	r5, [sp, #0x4]
    2946: ea5f 758a    	lsls.w	r5, r10, #0x1e
    294a: bf44         	itt	mi
    294c: f834 5009    	ldrhmi.w	r5, [r4, r9]
    2950: f82b 5009    	strhmi.w	r5, [r11, r9]
    2954: 1d1d         	adds	r5, r3, #0x4
    2956: f8dd b02c    	ldr.w	r11, [sp, #0x2c]
    295a: 4565         	cmp	r5, r12
    295c: 9d01         	ldr	r5, [sp, #0x4]
    295e: 46aa         	mov	r10, r5
    2960: f1c5 0500    	rsb.w	r5, r5, #0x0
    2964: d25c         	bhs	0x2a20 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x252> @ imm = #0xb8
    2966: 4273         	rsbs	r3, r6, #0
    2968: 9500         	str	r5, [sp]
    296a: eb01 0903    	add.w	r9, r1, r3
    296e: f005 0118    	and	r1, r5, #0x18
    2972: 4605         	mov	r5, r0
    2974: 9107         	str	r1, [sp, #0x1c]
    2976: f8cd 9010    	str.w	r9, [sp, #0x10]
    297a: 44c1         	add	r9, r8
    297c: 9b07         	ldr	r3, [sp, #0x1c]
    297e: fa2b fb0a    	lsr.w	r11, r11, r10
    2982: f8d9 1004    	ldr.w	r1, [r9, #0x4]
    2986: 9108         	str	r1, [sp, #0x20]
    2988: fa01 f303    	lsl.w	r3, r1, r3
    298c: eb05 0108    	add.w	r1, r5, r8
    2990: ea43 030b    	orr.w	r3, r3, r11
    2994: 468b         	mov	r11, r1
    2996: f84b 3b08    	str	r3, [r11], #8
    299a: 45e3         	cmp	r11, r12
    299c: d242         	bhs	0x2a24 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x256> @ imm = #0x84
    299e: 9b08         	ldr	r3, [sp, #0x20]
    29a0: 9503         	str	r5, [sp, #0xc]
    29a2: f8cd 9018    	str.w	r9, [sp, #0x18]
    29a6: fa23 f50a    	lsr.w	r5, r3, r10
    29aa: f8d9 9008    	ldr.w	r9, [r9, #0x8]
    29ae: 9b07         	ldr	r3, [sp, #0x1c]
    29b0: 9105         	str	r1, [sp, #0x14]
    29b2: fa09 f303    	lsl.w	r3, r9, r3
    29b6: 432b         	orrs	r3, r5
    29b8: 604b         	str	r3, [r1, #0x4]
    29ba: f101 030c    	add.w	r3, r1, #0xc
    29be: 4563         	cmp	r3, r12
    29c0: d236         	bhs	0x2a30 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x262> @ imm = #0x6c
    29c2: 9d06         	ldr	r5, [sp, #0x18]
    29c4: 68ed         	ldr	r5, [r5, #0xc]
    29c6: 9508         	str	r5, [sp, #0x20]
    29c8: fa29 f50a    	lsr.w	r5, r9, r10
    29cc: 9502         	str	r5, [sp, #0x8]
    29ce: e9dd 5107    	ldrd	r5, r1, [sp, #28]
    29d2: fa01 f905    	lsl.w	r9, r1, r5
    29d6: 9905         	ldr	r1, [sp, #0x14]
    29d8: 9d02         	ldr	r5, [sp, #0x8]
    29da: 3110         	adds	r1, #0x10
    29dc: ea45 0509    	orr.w	r5, r5, r9
    29e0: 4561         	cmp	r1, r12
    29e2: f8cb 5000    	str.w	r5, [r11]
    29e6: d22d         	bhs	0x2a44 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x276> @ imm = #0x5a
    29e8: 9906         	ldr	r1, [sp, #0x18]
    29ea: 9d07         	ldr	r5, [sp, #0x1c]
    29ec: f8dd 9010    	ldr.w	r9, [sp, #0x10]
    29f0: f8d1 b010    	ldr.w	r11, [r1, #0x10]
    29f4: 9908         	ldr	r1, [sp, #0x20]
    29f6: f109 0910    	add.w	r9, r9, #0x10
    29fa: fa0b f505    	lsl.w	r5, r11, r5
    29fe: fa21 f10a    	lsr.w	r1, r1, r10
    2a02: 4329         	orrs	r1, r5
    2a04: 9d03         	ldr	r5, [sp, #0xc]
    2a06: 6019         	str	r1, [r3]
    2a08: 3510         	adds	r5, #0x10
    2a0a: eb05 0308    	add.w	r3, r5, r8
    2a0e: 1d19         	adds	r1, r3, #0x4
    2a10: 4561         	cmp	r1, r12
    2a12: d3b0         	blo	0x2976 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x1a8> @ imm = #-0xa0
    2a14: eb09 0108    	add.w	r1, r9, r8
    2a18: 9107         	str	r1, [sp, #0x1c]
    2a1a: f8dd a000    	ldr.w	r10, [sp]
    2a1e: e018         	b	0x2a52 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x284> @ imm = #0x30
    2a20: 46aa         	mov	r10, r5
    2a22: e016         	b	0x2a52 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x284> @ imm = #0x2c
    2a24: 460b         	mov	r3, r1
    2a26: f109 0104    	add.w	r1, r9, #0x4
    2a2a: 9107         	str	r1, [sp, #0x1c]
    2a2c: 3304         	adds	r3, #0x4
    2a2e: e00c         	b	0x2a4a <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x27c> @ imm = #0x18
    2a30: 9906         	ldr	r1, [sp, #0x18]
    2a32: 46cb         	mov	r11, r9
    2a34: f8dd a000    	ldr.w	r10, [sp]
    2a38: 3108         	adds	r1, #0x8
    2a3a: 9107         	str	r1, [sp, #0x1c]
    2a3c: 9905         	ldr	r1, [sp, #0x14]
    2a3e: f101 0308    	add.w	r3, r1, #0x8
    2a42: e006         	b	0x2a52 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x284> @ imm = #0xc
    2a44: 9906         	ldr	r1, [sp, #0x18]
    2a46: 310c         	adds	r1, #0xc
    2a48: 9107         	str	r1, [sp, #0x1c]
    2a4a: f8dd a000    	ldr.w	r10, [sp]
    2a4e: f8dd b020    	ldr.w	r11, [sp, #0x20]
    2a52: 2500         	movs	r5, #0x0
    2a54: 2e01         	cmp	r6, #0x1
    2a56: f88d 5028    	strb.w	r5, [sp, #0x28]
    2a5a: f807 5c26    	strb	r5, [r7, #-38]
    2a5e: d105         	bne	0x2a6c <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x29e> @ imm = #0xa
    2a60: f10d 0828    	add.w	r8, sp, #0x28
    2a64: f04f 0900    	mov.w	r9, #0x0
    2a68: 2100         	movs	r1, #0x0
    2a6a: e009         	b	0x2a80 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x2b2> @ imm = #0x12
    2a6c: 9907         	ldr	r1, [sp, #0x1c]
    2a6e: f1a7 0826    	sub.w	r8, r7, #0x26
    2a72: 790d         	ldrb	r5, [r1, #0x4]
    2a74: 7949         	ldrb	r1, [r1, #0x5]
    2a76: f88d 5028    	strb.w	r5, [sp, #0x28]
    2a7a: ea4f 2901    	lsl.w	r9, r1, #0x8
    2a7e: 2102         	movs	r1, #0x2
    2a80: 07e6         	lsls	r6, r4, #0x1f
    2a82: d101         	bne	0x2a88 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x2ba> @ imm = #0x2
    2a84: 2100         	movs	r1, #0x0
    2a86: e009         	b	0x2a9c <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0x2ce> @ imm = #0x12
    2a88: 9d07         	ldr	r5, [sp, #0x1c]
    2a8a: 3504         	adds	r5, #0x4
    2a8c: 5c69         	ldrb	r1, [r5, r1]
    2a8e: f888 1000    	strb.w	r1, [r8]
    2a92: f817 1c26    	ldrb	r1, [r7, #-38]
    2a96: f89d 5028    	ldrb.w	r5, [sp, #0x28]
    2a9a: 0409         	lsls	r1, r1, #0x10
    2a9c: ea41 0109    	orr.w	r1, r1, r9
    2aa0: 9e01         	ldr	r6, [sp, #0x4]
    2aa2: 4329         	orrs	r1, r5
    2aa4: f00a 0518    	and	r5, r10, #0x18
    2aa8: 40a9         	lsls	r1, r5
    2aaa: fa2b f606    	lsr.w	r6, r11, r6
    2aae: 4331         	orrs	r1, r6
    2ab0: 6019         	str	r1, [r3]
    2ab2: e6f1         	b	0x2898 <compiler_builtins::mem::memcpy::h76d83c5a68c1995d+0xca> @ imm = #-0x21e

00002ab4 <__aeabi_uldivmod>:
    2ab4: b510         	push	{r4, lr}
    2ab6: b084         	sub	sp, #0x10
    2ab8: ac02         	add	r4, sp, #0x8
    2aba: 9400         	str	r4, [sp]
    2abc: f000 f804    	bl	0x2ac8 <__udivmoddi4>   @ imm = #0x8
    2ac0: 9a02         	ldr	r2, [sp, #0x8]
    2ac2: 9b03         	ldr	r3, [sp, #0xc]
    2ac4: b004         	add	sp, #0x10
    2ac6: bd10         	pop	{r4, pc}

00002ac8 <__udivmoddi4>:
    2ac8: b580         	push	{r7, lr}
    2aca: 466f         	mov	r7, sp
    2acc: b086         	sub	sp, #0x18
    2ace: 4684         	mov	r12, r0
    2ad0: a802         	add	r0, sp, #0x8
    2ad2: e9cd 2300    	strd	r2, r3, [sp]
    2ad6: 4662         	mov	r2, r12
    2ad8: 460b         	mov	r3, r1
    2ada: f000 f80d    	bl	0x2af8 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33> @ imm = #0x1a
    2ade: f8d7 c008    	ldr.w	r12, [r7, #0x8]
    2ae2: e9dd 0102    	ldrd	r0, r1, [sp, #8]
    2ae6: f1bc 0f00    	cmp.w	r12, #0x0
    2aea: bf1c         	itt	ne
    2aec: e9dd 3204    	ldrdne	r3, r2, [sp, #16]
    2af0: e9cc 3200    	strdne	r3, r2, [r12]
    2af4: b006         	add	sp, #0x18
    2af6: bd80         	pop	{r7, pc}

00002af8 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33>:
    2af8: b5f0         	push	{r4, r5, r6, r7, lr}
    2afa: af03         	add	r7, sp, #0xc
    2afc: e92d 0b00    	push.w	{r8, r9, r11}
    2b00: e9d7 e802    	ldrd	lr, r8, [r7, #8]
    2b04: f1be 0f00    	cmp.w	lr, #0x0
    2b08: d072         	beq	0x2bf0 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0xf8> @ imm = #0xe4
    2b0a: f1b8 0f00    	cmp.w	r8, #0x0
    2b0e: d16f         	bne	0x2bf0 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0xf8> @ imm = #0xde
    2b10: 2b00         	cmp	r3, #0x0
    2b12: f000 80fc    	beq.w	0x2d0e <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x216> @ imm = #0x1f8
    2b16: 4573         	cmp	r3, lr
    2b18: f080 8107    	bhs.w	0x2d2a <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x232> @ imm = #0x20e
    2b1c: fab3 f183    	clz	r1, r3
    2b20: fabe f68e    	clz	r6, lr
    2b24: 1a71         	subs	r1, r6, r1
    2b26: f101 0620    	add.w	r6, r1, #0x20
    2b2a: bf08         	it	eq
    2b2c: 261f         	moveq	r6, #0x1f
    2b2e: f1c6 0520    	rsb.w	r5, r6, #0x20
    2b32: fa08 f106    	lsl.w	r1, r8, r6
    2b36: fa0e f806    	lsl.w	r8, lr, r6
    2b3a: fa2e f505    	lsr.w	r5, lr, r5
    2b3e: 4329         	orrs	r1, r5
    2b40: f1b6 0520    	subs.w	r5, r6, #0x20
    2b44: f006 061f    	and	r6, r6, #0x1f
    2b48: bf58         	it	pl
    2b4a: fa0e f105    	lslpl.w	r1, lr, r5
    2b4e: f04f 0501    	mov.w	r5, #0x1
    2b52: fa05 fc06    	lsl.w	r12, r5, r6
    2b56: f04f 0500    	mov.w	r5, #0x0
    2b5a: bf58         	it	pl
    2b5c: f04f 0800    	movpl.w	r8, #0x0
    2b60: e008         	b	0x2b74 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x7c> @ imm = #0x10
    2b62: 4622         	mov	r2, r4
    2b64: 4633         	mov	r3, r6
    2b66: ea4f 1418    	lsr.w	r4, r8, #0x4
    2b6a: ea44 7801    	orr.w	r8, r4, r1, lsl #28
    2b6e: ea4f 1c1c    	lsr.w	r12, r12, #0x4
    2b72: 0909         	lsrs	r1, r1, #0x4
    2b74: ebb2 0408    	subs.w	r4, r2, r8
    2b78: eb63 0601    	sbc.w	r6, r3, r1
    2b7c: 2e00         	cmp	r6, #0x0
    2b7e: d403         	bmi	0x2b88 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x90> @ imm = #0x6
    2b80: ea45 050c    	orr.w	r5, r5, r12
    2b84: d102         	bne	0x2b8c <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x94> @ imm = #0x4
    2b86: e02d         	b	0x2be4 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0xec> @ imm = #0x5a
    2b88: 4614         	mov	r4, r2
    2b8a: 461e         	mov	r6, r3
    2b8c: ea5f 0351    	lsrs.w	r3, r1, #0x1
    2b90: ea4f 0238    	rrx	r2, r8
    2b94: 1aa2         	subs	r2, r4, r2
    2b96: eb66 0303    	sbc.w	r3, r6, r3
    2b9a: 2b00         	cmp	r3, #0x0
    2b9c: d404         	bmi	0x2ba8 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0xb0> @ imm = #0x8
    2b9e: ea45 055c    	orr.w	r5, r5, r12, lsr #1
    2ba2: 4614         	mov	r4, r2
    2ba4: d102         	bne	0x2bac <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0xb4> @ imm = #0x4
    2ba6: e01d         	b	0x2be4 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0xec> @ imm = #0x3a
    2ba8: 4622         	mov	r2, r4
    2baa: 4633         	mov	r3, r6
    2bac: ea4f 0498    	lsr.w	r4, r8, #0x2
    2bb0: ea44 7481    	orr.w	r4, r4, r1, lsl #30
    2bb4: 1b14         	subs	r4, r2, r4
    2bb6: eb63 0691    	sbc.w	r6, r3, r1, lsr #2
    2bba: 2e00         	cmp	r6, #0x0
    2bbc: d403         	bmi	0x2bc6 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0xce> @ imm = #0x6
    2bbe: ea45 059c    	orr.w	r5, r5, r12, lsr #2
    2bc2: d102         	bne	0x2bca <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0xd2> @ imm = #0x4
    2bc4: e00e         	b	0x2be4 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0xec> @ imm = #0x1c
    2bc6: 4614         	mov	r4, r2
    2bc8: 461e         	mov	r6, r3
    2bca: ea4f 02d8    	lsr.w	r2, r8, #0x3
    2bce: ea42 7241    	orr.w	r2, r2, r1, lsl #29
    2bd2: 1aa2         	subs	r2, r4, r2
    2bd4: eb66 03d1    	sbc.w	r3, r6, r1, lsr #3
    2bd8: 2b00         	cmp	r3, #0x0
    2bda: d4c2         	bmi	0x2b62 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x6a> @ imm = #-0x7c
    2bdc: ea45 05dc    	orr.w	r5, r5, r12, lsr #3
    2be0: 4614         	mov	r4, r2
    2be2: d1c0         	bne	0x2b66 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x6e> @ imm = #-0x80
    2be4: fbb4 f1fe    	udiv	r1, r4, lr
    2be8: fb01 461e    	mls	r6, r1, lr, r4
    2bec: 4329         	orrs	r1, r5
    2bee: e092         	b	0x2d16 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x21e> @ imm = #0x124
    2bf0: ebb2 060e    	subs.w	r6, r2, lr
    2bf4: f04f 0100    	mov.w	r1, #0x0
    2bf8: eb73 0608    	sbcs.w	r6, r3, r8
    2bfc: d37c         	blo	0x2cf8 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x200> @ imm = #0xf8
    2bfe: 2b00         	cmp	r3, #0x0
    2c00: d07a         	beq	0x2cf8 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x200> @ imm = #0xf4
    2c02: fab3 f183    	clz	r1, r3
    2c06: fab8 f688    	clz	r6, r8
    2c0a: 1a71         	subs	r1, r6, r1
    2c0c: f001 063f    	and	r6, r1, #0x3f
    2c10: f001 011f    	and	r1, r1, #0x1f
    2c14: f1c6 0420    	rsb.w	r4, r6, #0x20
    2c18: fa08 f506    	lsl.w	r5, r8, r6
    2c1c: fa0e fc06    	lsl.w	r12, lr, r6
    2c20: fa2e f404    	lsr.w	r4, lr, r4
    2c24: 432c         	orrs	r4, r5
    2c26: f1b6 0520    	subs.w	r5, r6, #0x20
    2c2a: bf58         	it	pl
    2c2c: fa0e f405    	lslpl.w	r4, lr, r5
    2c30: f04f 0501    	mov.w	r5, #0x1
    2c34: fa05 f901    	lsl.w	r9, r5, r1
    2c38: f04f 0100    	mov.w	r1, #0x0
    2c3c: bf58         	it	pl
    2c3e: f04f 0c00    	movpl.w	r12, #0x0
    2c42: e008         	b	0x2c56 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x15e> @ imm = #0x10
    2c44: 4632         	mov	r2, r6
    2c46: 462b         	mov	r3, r5
    2c48: ea4f 161c    	lsr.w	r6, r12, #0x4
    2c4c: ea46 7c04    	orr.w	r12, r6, r4, lsl #28
    2c50: ea4f 1919    	lsr.w	r9, r9, #0x4
    2c54: 0924         	lsrs	r4, r4, #0x4
    2c56: ebb2 060c    	subs.w	r6, r2, r12
    2c5a: eb73 0504    	sbcs.w	r5, r3, r4
    2c5e: d407         	bmi	0x2c70 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x178> @ imm = #0xe
    2c60: ea41 0109    	orr.w	r1, r1, r9
    2c64: ebb6 020e    	subs.w	r2, r6, lr
    2c68: eb75 0208    	sbcs.w	r2, r5, r8
    2c6c: d202         	bhs	0x2c74 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x17c> @ imm = #0x4
    2c6e: e03a         	b	0x2ce6 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x1ee> @ imm = #0x74
    2c70: 4616         	mov	r6, r2
    2c72: 461d         	mov	r5, r3
    2c74: ea5f 0354    	lsrs.w	r3, r4, #0x1
    2c78: ea4f 023c    	rrx	r2, r12
    2c7c: 1ab2         	subs	r2, r6, r2
    2c7e: eb75 0303    	sbcs.w	r3, r5, r3
    2c82: d409         	bmi	0x2c98 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x1a0> @ imm = #0x12
    2c84: ebb2 050e    	subs.w	r5, r2, lr
    2c88: ea41 0159    	orr.w	r1, r1, r9, lsr #1
    2c8c: eb73 0508    	sbcs.w	r5, r3, r8
    2c90: 4616         	mov	r6, r2
    2c92: 461d         	mov	r5, r3
    2c94: d202         	bhs	0x2c9c <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x1a4> @ imm = #0x4
    2c96: e026         	b	0x2ce6 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x1ee> @ imm = #0x4c
    2c98: 4632         	mov	r2, r6
    2c9a: 462b         	mov	r3, r5
    2c9c: ea4f 059c    	lsr.w	r5, r12, #0x2
    2ca0: ea45 7584    	orr.w	r5, r5, r4, lsl #30
    2ca4: 1b56         	subs	r6, r2, r5
    2ca6: eb63 0594    	sbc.w	r5, r3, r4, lsr #2
    2caa: 2d00         	cmp	r5, #0x0
    2cac: d407         	bmi	0x2cbe <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x1c6> @ imm = #0xe
    2cae: ea41 0199    	orr.w	r1, r1, r9, lsr #2
    2cb2: ebb6 020e    	subs.w	r2, r6, lr
    2cb6: eb75 0208    	sbcs.w	r2, r5, r8
    2cba: d202         	bhs	0x2cc2 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x1ca> @ imm = #0x4
    2cbc: e013         	b	0x2ce6 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x1ee> @ imm = #0x26
    2cbe: 4616         	mov	r6, r2
    2cc0: 461d         	mov	r5, r3
    2cc2: ea4f 02dc    	lsr.w	r2, r12, #0x3
    2cc6: ea42 7244    	orr.w	r2, r2, r4, lsl #29
    2cca: 1ab2         	subs	r2, r6, r2
    2ccc: eb65 03d4    	sbc.w	r3, r5, r4, lsr #3
    2cd0: 2b00         	cmp	r3, #0x0
    2cd2: d4b7         	bmi	0x2c44 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x14c> @ imm = #-0x92
    2cd4: ebb2 050e    	subs.w	r5, r2, lr
    2cd8: ea41 01d9    	orr.w	r1, r1, r9, lsr #3
    2cdc: eb73 0508    	sbcs.w	r5, r3, r8
    2ce0: 4616         	mov	r6, r2
    2ce2: 461d         	mov	r5, r3
    2ce4: d2b0         	bhs	0x2c48 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x150> @ imm = #-0xa0
    2ce6: f04f 0c00    	mov.w	r12, #0x0
    2cea: e9c0 1c00    	strd	r1, r12, [r0]
    2cee: e9c0 6502    	strd	r6, r5, [r0, #8]
    2cf2: e8bd 0b00    	pop.w	{r8, r9, r11}
    2cf6: bdf0         	pop	{r4, r5, r6, r7, pc}
    2cf8: f04f 0c00    	mov.w	r12, #0x0
    2cfc: 4616         	mov	r6, r2
    2cfe: 461d         	mov	r5, r3
    2d00: e9c0 1c00    	strd	r1, r12, [r0]
    2d04: e9c0 6502    	strd	r6, r5, [r0, #8]
    2d08: e8bd 0b00    	pop.w	{r8, r9, r11}
    2d0c: bdf0         	pop	{r4, r5, r6, r7, pc}
    2d0e: fbb2 f1fe    	udiv	r1, r2, lr
    2d12: fb01 261e    	mls	r6, r1, lr, r2
    2d16: f04f 0c00    	mov.w	r12, #0x0
    2d1a: 2500         	movs	r5, #0x0
    2d1c: e9c0 1c00    	strd	r1, r12, [r0]
    2d20: e9c0 6502    	strd	r6, r5, [r0, #8]
    2d24: e8bd 0b00    	pop.w	{r8, r9, r11}
    2d28: bdf0         	pop	{r4, r5, r6, r7, pc}
    2d2a: d10d         	bne	0x2d48 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x250> @ imm = #0x1a
    2d2c: fbb2 f1f3    	udiv	r1, r2, r3
    2d30: 2500         	movs	r5, #0x0
    2d32: fb01 2613    	mls	r6, r1, r3, r2
    2d36: f04f 0c01    	mov.w	r12, #0x1
    2d3a: e9c0 1c00    	strd	r1, r12, [r0]
    2d3e: e9c0 6502    	strd	r6, r5, [r0, #8]
    2d42: e8bd 0b00    	pop.w	{r8, r9, r11}
    2d46: bdf0         	pop	{r4, r5, r6, r7, pc}
    2d48: fbb3 fcfe    	udiv	r12, r3, lr
    2d4c: f5be 3f80    	cmp.w	lr, #0x10000
    2d50: fb0c 351e    	mls	r5, r12, lr, r3
    2d54: d21a         	bhs	0x2d8c <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x294> @ imm = #0x34
    2d56: 0429         	lsls	r1, r5, #0x10
    2d58: 2500         	movs	r5, #0x0
    2d5a: ea41 4112    	orr.w	r1, r1, r2, lsr #16
    2d5e: fbb1 f3fe    	udiv	r3, r1, lr
    2d62: fb03 f10e    	mul	r1, r3, lr
    2d66: ea4c 4c13    	orr.w	r12, r12, r3, lsr #16
    2d6a: ebc1 4112    	rsb	r1, r1, r2, lsr #16
    2d6e: eac2 4101    	pkhbt	r1, r2, r1, lsl #16
    2d72: fbb1 f2fe    	udiv	r2, r1, lr
    2d76: fb02 161e    	mls	r6, r2, lr, r1
    2d7a: ea42 4103    	orr.w	r1, r2, r3, lsl #16
    2d7e: e9c0 1c00    	strd	r1, r12, [r0]
    2d82: e9c0 6502    	strd	r6, r5, [r0, #8]
    2d86: e8bd 0b00    	pop.w	{r8, r9, r11}
    2d8a: bdf0         	pop	{r4, r5, r6, r7, pc}
    2d8c: ebb2 010e    	subs.w	r1, r2, lr
    2d90: eb75 0108    	sbcs.w	r1, r5, r8
    2d94: d208         	bhs	0x2da8 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x2b0> @ imm = #0x10
    2d96: 2100         	movs	r1, #0x0
    2d98: 4616         	mov	r6, r2
    2d9a: e9c0 1c00    	strd	r1, r12, [r0]
    2d9e: e9c0 6502    	strd	r6, r5, [r0, #8]
    2da2: e8bd 0b00    	pop.w	{r8, r9, r11}
    2da6: bdf0         	pop	{r4, r5, r6, r7, pc}
    2da8: ea4f 71c8    	lsl.w	r1, r8, #0x1f
    2dac: ea41 035e    	orr.w	r3, r1, lr, lsr #1
    2db0: ea4f 79ce    	lsl.w	r9, lr, #0x1f
    2db4: f04f 4800    	mov.w	r8, #0x80000000
    2db8: 2100         	movs	r1, #0x0
    2dba: e008         	b	0x2dce <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x2d6> @ imm = #0x10
    2dbc: 4622         	mov	r2, r4
    2dbe: 4635         	mov	r5, r6
    2dc0: ea4f 1419    	lsr.w	r4, r9, #0x4
    2dc4: ea44 7903    	orr.w	r9, r4, r3, lsl #28
    2dc8: ea4f 1818    	lsr.w	r8, r8, #0x4
    2dcc: 091b         	lsrs	r3, r3, #0x4
    2dce: ebb2 0409    	subs.w	r4, r2, r9
    2dd2: eb65 0603    	sbc.w	r6, r5, r3
    2dd6: 2e00         	cmp	r6, #0x0
    2dd8: d403         	bmi	0x2de2 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x2ea> @ imm = #0x6
    2dda: ea41 0108    	orr.w	r1, r1, r8
    2dde: d102         	bne	0x2de6 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x2ee> @ imm = #0x4
    2de0: e02d         	b	0x2e3e <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x346> @ imm = #0x5a
    2de2: 4614         	mov	r4, r2
    2de4: 462e         	mov	r6, r5
    2de6: ea5f 0553    	lsrs.w	r5, r3, #0x1
    2dea: ea4f 0239    	rrx	r2, r9
    2dee: 1aa2         	subs	r2, r4, r2
    2df0: eb66 0505    	sbc.w	r5, r6, r5
    2df4: 2d00         	cmp	r5, #0x0
    2df6: d404         	bmi	0x2e02 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x30a> @ imm = #0x8
    2df8: ea41 0158    	orr.w	r1, r1, r8, lsr #1
    2dfc: 4614         	mov	r4, r2
    2dfe: d102         	bne	0x2e06 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x30e> @ imm = #0x4
    2e00: e01d         	b	0x2e3e <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x346> @ imm = #0x3a
    2e02: 4622         	mov	r2, r4
    2e04: 4635         	mov	r5, r6
    2e06: ea4f 0499    	lsr.w	r4, r9, #0x2
    2e0a: ea44 7483    	orr.w	r4, r4, r3, lsl #30
    2e0e: 1b14         	subs	r4, r2, r4
    2e10: eb65 0693    	sbc.w	r6, r5, r3, lsr #2
    2e14: 2e00         	cmp	r6, #0x0
    2e16: d403         	bmi	0x2e20 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x328> @ imm = #0x6
    2e18: ea41 0198    	orr.w	r1, r1, r8, lsr #2
    2e1c: d102         	bne	0x2e24 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x32c> @ imm = #0x4
    2e1e: e00e         	b	0x2e3e <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x346> @ imm = #0x1c
    2e20: 4614         	mov	r4, r2
    2e22: 462e         	mov	r6, r5
    2e24: ea4f 02d9    	lsr.w	r2, r9, #0x3
    2e28: ea42 7243    	orr.w	r2, r2, r3, lsl #29
    2e2c: 1aa2         	subs	r2, r4, r2
    2e2e: eb66 05d3    	sbc.w	r5, r6, r3, lsr #3
    2e32: 2d00         	cmp	r5, #0x0
    2e34: d4c2         	bmi	0x2dbc <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x2c4> @ imm = #-0x7c
    2e36: ea41 01d8    	orr.w	r1, r1, r8, lsr #3
    2e3a: 4614         	mov	r4, r2
    2e3c: d1c0         	bne	0x2dc0 <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x2c8> @ imm = #-0x80
    2e3e: fbb4 f2fe    	udiv	r2, r4, lr
    2e42: 2500         	movs	r5, #0x0
    2e44: fb02 461e    	mls	r6, r2, lr, r4
    2e48: 4311         	orrs	r1, r2
    2e4a: e9c0 1c00    	strd	r1, r12, [r0]
    2e4e: e9c0 6502    	strd	r6, r5, [r0, #8]
    2e52: e8bd 0b00    	pop.w	{r8, r9, r11}
    2e56: bdf0         	pop	{r4, r5, r6, r7, pc}

00002e58 <HardFault_>:
    2e58: b580         	push	{r7, lr}
    2e5a: 466f         	mov	r7, sp
    2e5c: e7fe         	b	0x2e5c <HardFault_+0x4> @ imm = #-0x4
    2e5e: d4d4         	bmi	0x2e0a <compiler_builtins::int::specialized_div_rem::u64_div_rem::h56a02874b2bc4b33+0x312> @ imm = #-0x58
