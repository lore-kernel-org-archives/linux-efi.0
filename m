From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: EFI_STUB fails to boot non-EFI on arm64
Date: Fri, 23 May 2014 10:45:13 +0100
Message-ID: <20140523094513.GC9252@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <Leif.Lindholm-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

As the EFI_STUB for arm64 got into tip and soon into -next, I thought
about giving it a try (tip/arm64/efi). Using my boot-wrapper (non-EFI)
is still supposed to work but I get the trace below. It looks like
memmap.map is NULL but the code still assumes the kernel was started as
an EFI app.

Have you guys tested these patches properly?


Linux version 3.15.0-rc1+ (cmarinas@e102109-lin) (gcc version 4.8.3 20140401 (prerelease) (0.12.310) ) #451 SMP PREEMPT Fri May 23 10:40:10 BST 2014
CPU: AArch64 Processor [410fd0f0] revision 0
bootconsole [earlycon0] enabled
efi: Getting parameters from FDT:
efi: Can't find System Table in device tree!
cma: CMA: reserved 16 MiB at 8ff000000
Trying ::1...
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Unable to handle kernel NULL pointer dereference at virtual address 00000020
pgd = ffffffc00007d000
[00000020] *pgd=0000000000000000
Internal error: Oops: 96000005 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-rc1+ #451
task: ffffffc0005f4890 ti: ffffffc0005e8000 task.ti: ffffffc0005e8000
PC is at efi_idmap_init+0x74/0xc8
LR is at efi_idmap_init+0x4c/0xc8
pc : [<ffffffc0005b7f54>] lr : [<ffffffc0005b7f2c>] pstate: 600002c5
sp : ffffffc0005ebee0
x29: ffffffc0005ebee0 x28: 0000004080000000 
x27: ffffffc0005f60c8 x26: ffffffc0005f6000 
x25: ffffffc00053f618 x24: ffffffc0005f8fa8 
x23: ffffffc000600000 x22: ffffffc000629000 
x21: ffffffc000600000 x20: ffffffc000629338 
x19: 0000000000000000 x18: 0000000000000000 
x17: ffffffc000635d48 x16: 0000000000000001 
x15: 000000000000000a x14: 0000000900000000 
x13: 0000000000000018 x12: 0000000880000000 
x11: ffffffc000000000 x10: 0000004000000000 
x9 : 02c0000000000713 x8 : 0000000040000000 
x7 : 00000008ffffffff x6 : ffffffc000629390 
x5 : ffffffc000629000 x4 : 0000000000000000 
x3 : 00000008ffe00711 x2 : 0000000000000000 
x1 : 0000000000000000 x0 : 0000000000000000 

Process swapper (pid: 0, stack limit = 0xffffffc0005e8058)
Stack: (0xffffffc0005ebee0 to 0xffffffc0005ec000)
bee0: 005ebf10 ffffffc0 005b667c ffffffc0 7effdf80 ffffffc8 00635d78 ffffffc0
bf00: 005f6108 ffffffc0 005b65ec ffffffc0 005ebfa0 ffffffc0 005b4528 ffffffc0
bf20: 00629000 ffffffc0 00000001 00000000 005d7fd8 ffffffc0 410fd0f0 00000000
bf40: 805f6000 00000000 80000000 00000000 8007b000 00000000 8007d000 00000000
bf60: 00080590 ffffffc0 0044d088 ffffffc0 00000001 00000000 88000000 00000000
bf80: 0062f278 ffffffc0 00000002 00000000 0062ee32 ffffffc0 00000000 00000000
bfa0: 00000000 00000000 80080330 00000000 00000000 00000000 00000e12 00000000
bfc0: 88000000 00000000 410fd0f0 00000000 805f6000 00000000 00000000 00000000
bfe0: 00000000 00000000 005d7fd8 ffffffc0 00000000 00000000 00000000 00000000
Call trace:
[<ffffffc0005b7f54>] efi_idmap_init+0x74/0xc8
[<ffffffc0005b6678>] setup_arch+0x3d4/0x57c
[<ffffffc0005b4524>] start_kernel+0x88/0x364
Code: f9401a80 cb000020 eb00027f 54000248 (f9401260) 
---[ end trace f3ac502fe4422ad7 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
---[ end Kernel panic - not syncing: Attempted to kill the idle task!
