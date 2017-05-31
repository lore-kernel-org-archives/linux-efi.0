From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5] security, efi: Set lockdown if in secure boot mode
Date: Wed, 31 May 2017 11:39:14 +0000
Message-ID: <CAKv+Gu_vXASr=yDJ3MwT960eApqeWKEd-hqGoEyGsJKip7N+KQ@mail.gmail.com>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
 <CAKv+Gu_5gUWwx7Sxgm8d03L4t4nF8dDe+AXqOqto4B7AVSZ9CA@mail.gmail.com> <21606.1496222635@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <21606.1496222635-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 31 May 2017 at 09:23, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> - The series conflates 'UEFI secure boot support' with 'kernel lock
>> down support'. I think this has been brought up before, but I really
>> think we should have a cleaner separation between the feature (locking
>> down various bits of the kernel if lockdown is in effect) from the
>> policy 'enable lockdown if UEFI secure boot is enabled'.
>
> I'm not sure what you're actually asking for.  Are you wanting me to push the
> lockdown patches upstream separately from the UEFI patches that trigger the
> lockdown?  Or do you mean something else?
>

No, I am fine with keeping this as a single series. I don't want
anything under drivers/efi to imply policy regarding lockdown. Kernel
lockdown should be a feature that lives somewhere else, and which
contains a CONFIG_ option that implies 'lockdown is enabled by default
when UEFI secure boot is detected.' The code that gets added to
drivers/efi should only concern itself with establishing whether
secure boot is in effect or not (and can hence be enabled
unconditionally)

>> The only tunable we need is in the lockdown context, whether lockdown needs
>> to take effect automatically when UEFI secure boot is detected
>
> So you don't want this change:
>
>         config EFI_SECURE_BOOT
>                 bool "Support UEFI Secure Boot and lock down the kernel in secure boot mode"
>                 default n
>         +       select LOCK_DOWN_KERNEL
>
> but would rather have a separate option asking whether lockdown should be
> triggered if detect UEFI secure boot mode?
>

Yes. As I said, supporting UEFI secure boot (whatever that could mean)
and implementing a lockdown policy when it is enabled are two entirely
different things.

>> (but there could be other ways to enable lockdown, including a kernel
>> cmdline param or a sysfs node).
>
> A sysfs node is pretty pointless.  A number of things that are locked down
> need to be locked down during boot.

OK.

> I could, however, provide a command-line
> option to engage it or a kernel config option to unconditionally enable it.
>

I *think* that could be useful, although it was meant as an
illustration rather than actual suggestion.

>> - The current series enables lockdown, but does not lock anything
>> down.
>
> Yes.  As I pointed out, and as I'm sure you know, I have a slew of other
> patches that actually *do* lock things down.  I extracted these patches to try
> and get some feedback on this bit without spamming various mailing lists with
> all the other patches each time.
>
>> Even if the code is in good shape otherwise, I am reluctant to
>> ack and/or merge anything right now, given that it provides a false
>> sense of security.
>
> You're a member of the "make it provably 100% secure or nothing" camp?
>

No, not at all. But patch 4/5 contains this line

pr_info("Secure boot enabled and kernel locked down\n");

which I don't like at all, given that nothing is actually locked down.
I have been working in this area long enough to know that people will
interpret 'lockdown' or 'secure' to mean anything they like if it is
left unqualified.

So what I would prefer is to separate this from the EFI code, and
perhaps print something like

lockdown: Kernel lockdown policy in effect due to xxx

and print a subsequent line for every lockdown feature that is enabled, e.g.,

lockdown: disabling MSRs
lockdown: disabling hibernate support

etc etc

These are just examples, of course, but it manages the expectations,
and as a bonus, it makes differences between architectures much more
visible.

>> This also ties in to my more general concerns with this code (and I am aware
>> I never replied to your email explaining it, my apologies [again]): without
>> any sense of how large the attack surface is now,
>
> I suspect no one knows.  I've been trying to lock down possibilities people
> have pointed me at, even if some of them are very theoretical, and a lot of
> the patches I've gathered together come from other people, but I don't know
> the hardware that a lot of this is dealing with, so I can't answer this
> question.
>

OK, and that is fine. I would just like this modest stance to be
reflected in the code and especially the log messages.

>> and how much we reduced it by implementing the items on your list above, we
>> should really not be making claims of security, given that we really have no
>> idea how much more secure we are. That said, I do subscribe to the effort,
>> in the sense that moving towards the goal is strictly better than moving
>> away from it, or not at all.
>
> Can we at least decide whether or not we want to put a locked-down mode into
> the upstream kernel?  If not, I can drop this effort.

No, I think this is a very important feature. But it needs to be more
transparent to avoid a false sense of security.
