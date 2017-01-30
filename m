From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: What should the default lockdown mode be if the bootloader sentinel triggers sanitization?
Date: Mon, 30 Jan 2017 12:10:29 +0000
Message-ID: <25118.1485778229@warthog.procyon.org.uk>
References: <20170127140101.GD31613@codeblueprint.co.uk> <20170123212642.GA2766@codeblueprint.co.uk> <20170116144954.GB27351@codeblueprint.co.uk> <20170111143304.GA29649@codeblueprint.co.uk> <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk> <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk> <7948.1484148443@warthog.procyon.org.uk> <794.1484581158@warthog.procyon.org.uk> <6306.1485209503@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-ID: <25117.1485778229.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michael Chang <mchang-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi all,

There's an interesting issue with the way the x86 boot parameters are passed
into the kernel if we want to store the secure-boot mode flag in there.

My patches add boot_params->secure_boot, into which is placed the secure boot
mode as deduced by the EFI boot wrapper, if it is invoked.  This, however,
gets scrubbed by sanitize_boot_params() if the ->sentinel flag is set.  It
turns out that grub2 has a bug in it whereby it initialises boot_params by
copying the wrong stuff over it, thereby setting the ->sentinel flag.

In my patch I saw that sanitisation was happening and I stopped
sanitize_boot_params() from clobbering that particular byte and instead zeroed
it on entry to the boot wrapper.  This seemed reasonable since the boot
wrapper calculates the flag and simply overwrites whatever the boot loader had
placed there - and the value was getting clobbered by sanitisation called
during kernel decompression.

Matt argues, however, that boot_params->secure_boot should be propagated from
the bootloader and if the bootloader wants to set it, then we should skip the
check in efi_main() and go with the bootloader's opinion.  This is something
we probably want to do with kexec() so that the lockdown state is propagated
there.

However, what should happen in the core kernel if the bootloader doesn't
properly initialise ->sentinel and sanitisation is done that then clobbers
->secure_boot?  Should the kernel be locked down by default or left open by
default if lockdown was enabled in the kernel config?

But, as I mentioned, a bug in grub2 whereby it is copying the wrong
initialisation data over boot_params is causing sanitisation to be triggered.

Some questions that should clarify how we proceed:

 (1) Do we actually want to propagate the mode determination from the boot
     loader?

 (2) Do we have to determine the secure-boot status in the EFI boot wrapper
     (we don't use it there) or can we determine it in the core kernel?

 (3) What's the default mode in the case of sanitisation when lockdown is
     configured?

 (4) How do we handle the initialisation being mucked up such that ->sentinel
     ends up 0 and ->secure_boot ends up essentially random?

Any thoughts?

David
