From: Fabian Tschiatschek <fabian.tschiatschek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: PROBLEM: Unexpected contents of load options (EFI Boot Stub)
Date: Sat, 4 Mar 2017 11:45:11 +0100
Message-ID: <773c29b9-37b4-e007-c336-c4beab7cde91@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Trying to load Linux 4.10.0 (x86_64) on a Dell XPS 15 9550 [1]
using the firmware boot manager (BIOS revision 1.2.19; dated
January 23, 2017 on Dell's website) results in the following
kernel panic:

   VFS: Unable to mount root fs on unknown-block(0,0)

The kernel panic occurs even though a valid initrd kernel
parameter is supplied through the OptionalData parameter [2]
of the corresponding load option descriptor.

Adding debug output to function make_boot_params in eboot.c to
display a hex dump of the memory contents at the location pointed
to by member load_options of efi_loaded_image_t indicates that
load_options points to the beginning of the load option
descriptor, i.e. to the Attributes parameter [3]. This seems to
be unexpected behavior since later on the function tries to
interpret the memory area as UTF-16 string. The code seems to
assume that load_options points to the OptionalData parameter.

In my case the Attributes parameter [2] has value 1 and thus the
upper 16 bits of it are zero. This causes efi_convert_cmdline to
stop converting after one (non-printing) character. Since the
kernel command line obtained in this way misses the initrd
kernel parameter the system fails to boot.

If I adjust members load_options and load_options_size of
efi_loaded_image_t by calculating the offset to parameter
OptionalData as described under parameters FilePathListLength
and OptionalData in [2] the system boots correctly.

Is there anything I am missing? How should I proceed to fix this
issue?

Thanks for your attention.

Fabian

[1] Hardware name: Dell Inc. XPS 15 9550/0N7TVV, BIOS 1.2.19 12/22/2016
[2] Unified Extensible Firmware Interface Specification, Version 2.4 
Errata C, April, 2015, p. 68
[3] Unified Extensible Firmware Interface Specification, Version 2.4 
Errata C, April, 2015, p. 67
