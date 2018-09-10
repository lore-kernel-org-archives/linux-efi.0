From: Guenter Roeck <linux@roeck-us.net>
Subject: Random crashes with i386 and efi boots
Date: Mon, 10 Sep 2018 14:56:59 -0700
Message-ID: <20180910215659.GA17966@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Joerg Roedel <jroedel@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Michal Hocko <mhocko@suse.com>, Andi Kleen <ak@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

Hi folks,

even after commit eeb89e2bb1ac ("x86/efi: Load fixmap GDT in
efi_call_phys_epilog()"), my i386/efi qemu boot tests still crash randomly
(roughly 5-10% of the time). As before, I don't see much useful output in
the qemu log (this time it doesn't even complain about a triple fault). 

Debugging shows that the crash happens in efi_call_phys_epilog().
A sample log from a crashed test run is attached below. It appears that
the crash happens if there is an interrupt at a critical section of the
code.

While playing with the code, I found a possible fix.

diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 05ca14222463..9959657127f4 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -85,10 +85,9 @@ pgd_t * __init efi_call_phys_prolog(void)
 
 void __init efi_call_phys_epilog(pgd_t *save_pgd)
 {
+	load_fixmap_gdt(0);
 	load_cr3(save_pgd);
 	__flush_tlb_all();
-
-	load_fixmap_gdt(0);
 }

This restores the execution order prior to commit eeb89e2bb1ac.
I have no real idea what I am doing, so this change is to be taken with
a grain of salt. All I can say is that 100 boots with the above change
were successful while the current upstream code (v4.19-rc3) crashes on
a regular basis (in a controlled test I observed 6 failures out of 100
boots).

It would be great if someone with a bit more experience can have another
look and figure out the underlying problem. Please let me know if I can
provide additional information.

Thanks,
Guenter

----------------
IN:
# efi_call_phys_epilog(save_pgd);
0xd8f9c12c:  8b 45 f0                 movl     -0x10(%ebp), %eax
0xd8f9c12f:  e8 49 01 00 00           calll    0xd8f9c27d

----------------
IN:
# efi_call_phys_epilog():
# load_cr3();
0xd8f9c27d:  55                       pushl    %ebp
0xd8f9c27e:  05 00 00 00 40           addl     $0x40000000, %eax
0xd8f9c283:  89 e5                    movl     %esp, %ebp
0xd8f9c285:  0f 22 d8                 movl     %eax, %cr3

CR3 update: CR3=1904e000
----------------
IN:
# __flush_tlb_all();
0xd8f9c288:  e8 c8 5e 2b ff           calll    0xd8252155

EAX=1904e000 EBX=00000000 ECX=d8f9c126 EDX=d8eafd60
ESI=1f09a000 EDI=00000030 EBP=d8e99f3c ESP=d8e99f3c
EIP=d8f9c288 EFL=00200207 [-----PC] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =007b 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =0060 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]
SS =0068 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
DS =007b 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
FS =00d8 06c92000 ffffffff 008f9300 DPL=0 DS16 [-WA]
GS =00e0 dfcd09c0 00000018 00409100 DPL=0 DS   [--A]
LDT=0000 00000000 00000000 00008200 DPL=0 LDT
TR =0080 ff803000 0000206b 00008900 DPL=0 TSS32-avl
GDT=     1fcc0000 000000ff
IDT=     ff800000 000007ff
CR0=80050033 CR2=ffd17000 CR3=1904e000 CR4=00040690
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
DR6=ffff0ff0 DR7=00000400
CCS=40000000 CCD=1904e000 CCO=ADDL
EFER=0000000000000000
Servicing hardware INT=0x30
  508: v=30 e=0000 i=0 cpl=0 IP=0060:d8f9c288 pc=d8f9c288 SP=0068:d8e99f3c env->regs[R_EAX]=1904e000
X=1904e000 EBX=00000000 ECX=d8f9c126 EDX=d8eafd60
ESI=1f09a000 EDI=00000030 EBP=d8e99f3c ESP=d8e99f3c
EIP=d8f9c288 EFL=00200207 [-----PC] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =007b 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =0060 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]
SS =0068 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
DS =007b 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
FS =00d8 06c92000 ffffffff 008f9300 DPL=0 DS16 [-WA]
GS =00e0 dfcd09c0 00000018 00409100 DPL=0 DS   [--A]
LDT=0000 00000000 00000000 00008200 DPL=0 LDT
TR =0080 ff803000 0000206b 00008900 DPL=0 TSS32-avl
GDT=     1fcc0000 000000ff
IDT=     ff800000 000007ff
CR0=80050033 CR2=ffd17000 CR3=1904e000 CR4=00040690
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
DR6=ffff0ff0 DR7=00000400
CCS=00000005 CCD=1904e000 CCO=EFLAGS
EFER=0000000000000000
check_exception old: 0xffffffff new 0xe
  509: v=0e e=0000 i=0 cpl=0 IP=0060:d8f9c288 pc=d8f9c288 SP=0068:d8e99f3c CR2=1fcc0060
EAX=1904e000 EBX=00000000 ECX=d8f9c126 EDX=d8eafd60
ESI=1f09a000 EDI=00000030 EBP=d8e99f3c ESP=d8e99f3c
EIP=d8f9c288 EFL=00200207 [-----PC] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =007b 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =0060 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]
SS =0068 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
DS =007b 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
FS =00d8 06c92000 ffffffff 008f9300 DPL=0 DS16 [-WA]
GS =00e0 dfcd09c0 00000018 00409100 DPL=0 DS   [--A]
LDT=0000 00000000 00000000 00008200 DPL=0 LDT
TR =0080 ff803000 0000206b 00008900 DPL=0 TSS32-avl
GDT=     1fcc0000 000000ff
IDT=     ff800000 000007ff
CR0=80050033 CR2=1fcc0060 CR3=1904e000 CR4=00040690
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
DR6=ffff0ff0 DR7=00000400
CCS=00000005 CCD=1904e000 CCO=EFLAGS
EFER=0000000000000000
check_exception old: 0xe new 0xe
  510: v=08 e=0000 i=0 cpl=0 IP=0060:d8f9c288 pc=d8f9c288 SP=0068:d8e99f3c env->regs[R_EAX]=1904e000
EAX=1904e000 EBX=00000000 ECX=d8f9c126 EDX=d8eafd60
ESI=1f09a000 EDI=00000030 EBP=d8e99f3c ESP=d8e99f3c
EIP=d8f9c288 EFL=00200207 [-----PC] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =007b 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =0060 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]
SS =0068 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
DS =007b 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
FS =00d8 06c92000 ffffffff 008f9300 DPL=0 DS16 [-WA]
GS =00e0 dfcd09c0 00000018 00409100 DPL=0 DS   [--A]
LDT=0000 00000000 00000000 00008200 DPL=0 LDT
TR =0080 ff803000 0000206b 00008900 DPL=0 TSS32-avl
GDT=     1fcc0000 000000ff
IDT=     ff800000 000007ff
CR0=80050033 CR2=1fcc0060 CR3=1904e000 CR4=00040690
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
DR6=ffff0ff0 DR7=00000400
CCS=00000005 CCD=1904e000 CCO=EFLAGS
EFER=0000000000000000
check_exception old: 0x8 new 0xe

# qemu dies silently here

---

In another log, the code proceeeds a little further:

CR3 update: CR3=13668000
----------------
IN:
0xd35b6412:  e8 ae cb 29 ff           calll    0xd2852fc5

----------------
IN:
0xd35b6417:  31 c0                    xorl     %eax, %eax
0xd35b6419:  e8 12 2e 27 ff           calll    0xd2829230

----------------
IN:
0xd2829230:  55                       pushl    %ebp
0xd2829231:  89 e5                    movl     %esp, %ebp
0xd2829233:  83 ec 08                 subl     $8, %esp
0xd2829236:  e8 75 6c 02 00           calll    0xd284feb0

Servicing hardware INT=0x30

... subsequent log messages and crash are as before.
