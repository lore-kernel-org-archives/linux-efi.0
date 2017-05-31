From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] security, efi: Set lockdown if in secure boot mode
Date: Wed, 31 May 2017 10:23:55 +0100
Message-ID: <21606.1496222635@warthog.procyon.org.uk>
References: <CAKv+Gu_5gUWwx7Sxgm8d03L4t4nF8dDe+AXqOqto4B7AVSZ9CA@mail.gmail.com> <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_5gUWwx7Sxgm8d03L4t4nF8dDe+AXqOqto4B7AVSZ9CA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-ID: <21605.1496222635.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> - The series conflates 'UEFI secure boot support' with 'kernel lock
> down support'. I think this has been brought up before, but I really
> think we should have a cleaner separation between the feature (locking
> down various bits of the kernel if lockdown is in effect) from the
> policy 'enable lockdown if UEFI secure boot is enabled'.

I'm not sure what you're actually asking for.  Are you wanting me to push the
lockdown patches upstream separately from the UEFI patches that trigger the
lockdown?  Or do you mean something else?

> The only tunable we need is in the lockdown context, whether lockdown needs
> to take effect automatically when UEFI secure boot is detected

So you don't want this change:

	config EFI_SECURE_BOOT
		bool "Support UEFI Secure Boot and lock down the kernel in secure boot mode"
		default n
	+	select LOCK_DOWN_KERNEL

but would rather have a separate option asking whether lockdown should be
triggered if detect UEFI secure boot mode?

> (but there could be other ways to enable lockdown, including a kernel
> cmdline param or a sysfs node).

A sysfs node is pretty pointless.  A number of things that are locked down
need to be locked down during boot.  I could, however, provide a command-line
option to engage it or a kernel config option to unconditionally enable it.

> - The current series enables lockdown, but does not lock anything
> down.

Yes.  As I pointed out, and as I'm sure you know, I have a slew of other
patches that actually *do* lock things down.  I extracted these patches to try
and get some feedback on this bit without spamming various mailing lists with
all the other patches each time.

> Even if the code is in good shape otherwise, I am reluctant to
> ack and/or merge anything right now, given that it provides a false
> sense of security.

You're a member of the "make it provably 100% secure or nothing" camp?

> This also ties in to my more general concerns with this code (and I am aware
> I never replied to your email explaining it, my apologies [again]): without
> any sense of how large the attack surface is now,

I suspect no one knows.  I've been trying to lock down possibilities people
have pointed me at, even if some of them are very theoretical, and a lot of
the patches I've gathered together come from other people, but I don't know
the hardware that a lot of this is dealing with, so I can't answer this
question.

> and how much we reduced it by implementing the items on your list above, we
> should really not be making claims of security, given that we really have no
> idea how much more secure we are. That said, I do subscribe to the effort,
> in the sense that moving towards the goal is strictly better than moving
> away from it, or not at all.

Can we at least decide whether or not we want to put a locked-down mode into
the upstream kernel?  If not, I can drop this effort.

David
