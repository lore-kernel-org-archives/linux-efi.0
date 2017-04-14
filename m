From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/24] Add a sysrq option to exit secure boot mode
Date: Sat, 15 Apr 2017 00:16:24 +0100
Message-ID: <12411.1492211784@warthog.procyon.org.uk>
References: <CAKv+Gu-FDzdqACyr_z6Zsgb51mg8Lc0YgfLs4oGURWnX4WewSw@mail.gmail.com> <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk> <149142332458.5101.14654616837280513947.stgit@warthog.procyon.org.uk> <alpine.DEB.2.20.1704142003570.2327@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-FDzdqACyr_z6Zsgb51mg8Lc0YgfLs4oGURWnX4WewSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-ID: <12410.1492211784.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> That does bring me to another EFI related point: many of these patches
> are x86 specific for no good reason.

Note that the sysrq one is awkward since the key chosen *is* arch-specific.
SysRq+x can't be arbitrarily assigned to this since some other arches have
their own use for it.

Anyway, the ones that are x86-specific are:

	efi: Add EFI_SECURE_BOOT bit
	efi: Lock down the kernel if booted in secure boot mode
	Add a sysrq option to exit secure boot mode
	Copy secure_boot flag in boot params across kexec reboot
	x86: Lock down IO port access when the kernel is locked down
	x86: Restrict MSR access when the kernel is locked down
	asus-wmi: Restrict debugfs interface when the kernel is locked down

The first three are dealt with in the five patches I posted later, including
making the choice of sysrq key an arch override.  The bits that can be moved
out to the efi firmware driver have been.

The 4th looks to be x86 bootloader protocol specific.

The remainder look very x86 specific, apart from one piece in the 5th patch
where /dev/port is locked down.

David
