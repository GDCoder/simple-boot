/*
 * Copyright (c) 2004-2008 Texas Instruments
 *
 * (C) Copyright 2002
 * Gary Jennejohn, DENX Software Engineering, <garyj@denx.de>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

/* 分别指定在缺省、大端、小端 情况下的输出可执行文件格式 */
OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")

/* 指定输出文件的体系结构BFDNAME */
OUTPUT_ARCH(arm)

/* 将符号_start的值设置成程序入口地址, 整个程序将从_start处开始启动 */
ENTRY(_start)

SECTIONS
{
    /* 把定位器符号置为0×0 */
    . = 0x0;
    
    /* 定位符4字节(32位)对齐, 将所有输入文件的.text section合并成一个.text section
    . = ALIGN(4);
    .text : { *(.text) }

    /* 定位符4字节(32位)对齐, 将所有输入文件的.rodata section合并成一个.rodata section
    . = ALIGN(4);
    .rodata : {*(.rodata)}

    /* 定位符4字节(32位)对齐, 将所有输入文件的.data section合并成一个.data section
    . = ALIGN(4);
    .data : { *(.data) }

    /* 定位符4字节(32位)对齐, 将所有输入文件的.bss section合并成一个.bss section
    . = ALIGN(4);
    __bss_start = .; 
    .bss : { *(.bss) }
    __bss_end = .;
}

