From: Sebastian Roth <sebaroth-Mmb7MZpHnFY@public.gmane.org>
Subject: memcpy freeze in __setup_efi_pci64 on HP X2 210 tablet
Date: Thu, 4 Feb 2016 12:05:47 +0100
Message-ID: <56B3308B.2050702@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Booting current mainline kernel (EFI_STUB=y, tried 4.4.0 and 4.3.3) on 
HP X2 210 tablet (UEFI enabled, secure boot off) freezes very early 
without any output - earlyprintk enabled. Adding own debug output I 
found that it freezes on line 473 in arch/x86/boot/compressed/eboot.c 
where memcpy is called. Preceding mem allocation seams fine though.

At first this seamed to be an issue when chainloading the kernel from 
iPXE. See here: http://forum.ipxe.org/showthread.php?tid=7938

But booting the kernel straight from USB as bootx64.efi freezes on the 
exact same memcpy call. Using the same kernel with GRUB as bootloader 
does not cause an issue as this seams to load it as bzImage bypassing 
the EFI init code.

Asking for advice on how to further debug this. Why/how is memcpy 
failing/freezing on this hardware? Any checks I could add to the code to 
make this run?

Thanks in advance!

Cheers
Sebastian
