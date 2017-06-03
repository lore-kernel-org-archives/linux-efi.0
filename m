From: Maniaxx <tripleshiftone@gmail.com>
Subject: Re: PROBLEM: Kernel panic on EFI BGRT early init code (kernel
 4.11/4.12rc2) [regression]
Date: Sat, 3 Jun 2017 20:24:02 +0200
Message-ID: <c1505b0e-8136-86d3-e6ab-019c17106e5b@gmail.com>
References: <86c36f9b-f633-3354-d676-7693f35dae0d@gmail.com>
 <20170526012342.GA3096@dhcp-128-65.nay.redhat.com>
 <a32eea98-9576-1ee7-c27a-b165204d825f@gmail.com>
 <20170527051427.GA3492@dhcp-128-65.nay.redhat.com>
 <20170527053457.GB3492@dhcp-128-65.nay.redhat.com>
 <df8e83f9-9362-b5b5-462d-b11980baac01@gmail.com>
 <20170601015621.GA4306@dhcp-128-65.nay.redhat.com>
 <e6d656c0-c76b-42c3-8413-0198efb8a33a@gmail.com>
 <20170602025155.GA3637@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20170602025155.GA3637@dhcp-128-65.nay.redhat.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org
Cc: linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Isn't the image address invalid if bgrt_tab->status is 0
(regarding ACPI specs below)?
The image address could be total garbage and probably the
reason why memremap (in efi-bgrt.c) leads to different 
behavior on early_init.

If so, you might need to add another condition to check
status and bail out before memremap.

**************************************************************************************
Source: http://www.acpi.info/DOWNLOADS/ACPIspec50.pdf

5.2.22 Boot Graphics Resource Table (BGRT)
[...]
If the boot path is interrupted (e.g. by a key press), 
the valid bit within the status field should be changed to 0 
to indicate to the OS that the current image is invalidated.

5.2.22.2 Status
The status field contains information about the current 
status of the table.  The Valid bit is bit 0 of the lowest byte. 
It should be set to 1 when the table is written, 
and invalidated if there is reason to expect that the screen 
state has been changed.

5.2.22.4 Image Address
The Image Address contains the location in memory where an in-memory 
copy of the boot image can be found.
The image should be stored in EfiBootServicesData, allowing the system 
to reclaim the memory when the image is no longer needed.

**************************************************************************************
Decompiled BGRT table:

$ sudo acpidump > acpi.dat
$ acpixtract -a acpi.dat
$ iasl -d bgrt.dat 
$ cat bgrt.dsl

/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20170303 (64-bit version)
 * Copyright (c) 2000 - 2017 Intel Corporation
 * 
 * Disassembly of bgrt.dat, Sat Jun  3 15:33:10 2017
 *
 * ACPI Data Table [BGRT]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "BGRT"    [Boot Graphics Resource Table]
[004h 0004   4]                 Table Length : 0000003C
[008h 0008   1]                     Revision : 00
[009h 0009   1]                     Checksum : 89
[00Ah 0010   6]                       Oem ID : "ALASKA"
[010h 0016   8]                 Oem Table ID : "A M I"
[018h 0024   4]                 Oem Revision : 01072009
[01Ch 0028   4]              Asl Compiler ID : "AMI "
[020h 0032   4]        Asl Compiler Revision : 00010013

[024h 0036   2]                      Version : 0001
[026h 0038   1]                       Status : 00
[027h 0039   1]                   Image Type : 00
[028h 0040   8]                Image Address : 0A08E01800000001
[030h 0048   4]                Image OffsetX : 00000000
[034h 0052   4]                Image OffsetY : 00000000

Raw Table Data: Length 60 (0x3C)

  0000: 42 47 52 54 3C 00 00 00 00 89 41 4C 41 53 4B 41  // BGRT<.....ALASKA
  0010: 41 20 4D 20 49 00 00 00 09 20 07 01 41 4D 49 20  // A M I.... ..AMI 
  0020: 13 00 01 00 01 00 00 00 01 00 00 00 18 E0 08 0A  // ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00              // ............


