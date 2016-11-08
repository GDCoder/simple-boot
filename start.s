.text
.global _start
_start:
    /* 异常向量表 */
    b reset
    ldr pc, undefined_instruction
    ldr pc, software_interrupt
    ldr pc, prefetch_abort
    ldr pc, data_abort
    ldr pc, not_used
    ldr pc, irq
    ldr pc, fiq

reset:
	/* 设置CPU到SVC32模式 */
    mrs r0, cpsr
    bic r0, r0, #0x1F
    orr r0, r0, #0xD3
    msr cpsr, r0
    
    /* 设置异常向量基地址到CP15协处理器C12寄存器中, 此操作只适用于ARM11和Cortex-A处理器 */
    mrc p15, 0, r0, c1, c0, 0
    bic r0, #(1<<13)
    mcr p15, 0, r0, c1, c0, 0
    
    ldr r0, =_start
    mcr p15, 0, r0, c12, c0, 0

	/* 禁用I/D CACHE和MMU及其CACHE */
	bl	cpu_init_cp15

	/*设置PLL, MUX, MEMORY*/
	bl	cpu_init_crit

	/* 跳到主函数 */
	bl	halt_loop

/*************************************************************************
 *
 * cpu_init_cp15
 *
 * Setup CP15 registers (cache, MMU, TLBs). The I-cache is turned on unless
 * CONFIG_SYS_ICACHE_OFF is defined.
 *
 *************************************************************************/
ENTRY(cpu_init_cp15)
	/* 无效I CACHE和D CACHE */
	mov	r0, #0                  @ set up for MCR
	mcr	p15, 0, r0, c8, c7, 0	@ invalidate TLBs
	mcr	p15, 0, r0, c7, c5, 0	@ invalidate icache
	mcr	p15, 0, r0, c7, c5, 6	@ invalidate BP array
	mcr p15, 0, r0, c7, c10, 4	@ DSB
	mcr p15, 0, r0, c7, c5, 4	@ ISB

	/* disable MMU stuff and caches */
	/* 禁用MMU Stuff和CACHE */
	mrc	p15, 0, r0, c1, c0, 0
	bic	r0, r0, #0x00002000     @ clear bits 13 (--V-)
	bic	r0, r0, #0x00000007     @ clear bits 2:0 (-CAM)
	orr	r0, r0, #0x00000002     @ set bit 1 (--A-) Align
	orr	r0, r0, #0x00000800     @ set bit 11 (Z---) BTB
	
	#ifdef CONFIG_SYS_ICACHE_OFF
		bic	r0, r0, #0x00001000	@ clear bit 12 (I) I-cache
	#else
		orr	r0, r0, #0x00001000	@ set bit 12 (I) I-cache
	#endif
	
	mcr	p15, 0, r0, c1, c0, 0
	mov	pc, lr					@ back to my caller
ENDPROC(cpu_init_cp15)

/*************************************************************************
 *
 * CPU_init_critical registers
 *
 * setup important registers
 * setup memory timing
 *
 *************************************************************************/
ENTRY(cpu_init_crit)
	/*
	 * Jump to board specific initialization...
	 * The Mask ROM will have already initialized
	 * basic memory. Go here to bump up clock rate and handle
	 * wake up conditions.
	 */
	b	lowlevel_init			@ go setup pll,mux,memory
ENDPROC(cpu_init_crit)

/*************************************************************************
 *
 * Lowlevel_init
 *
 * Disable watchdog.
 *
 *
 *************************************************************************/
ENTRY(lowlevel_init)
	/* 禁用看门狗 */
	ldr     r0, =0xfd0c0000
	mov             r1, #0
	str     r1, [r0, #0x0]
	mov	pc, lr
ENDPROC(lowlevel_init)
    
halt_loop:
    /* 进入循环 */
    b halt_loop

/* 异常处理 */
	.align	5
undefined_instruction:
	b undefined_instruction

	.align	5
software_interrupt:
	b software_interrupt

	.align	5
prefetch_abort:
	b prefetch_abort

	.align	5
data_abort:
	b data_abort

	.align	5
not_used:
	b not_used

	.align	5
irq:
	b irq

	.align	5
fiq:
	b fiq

