From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: Re: [PATCH] efivars: Make efivarfs autoloading on mount request
Date: Thu, 28 Feb 2013 13:18:12 +0100
Message-ID: <CAG-2HqUK2Ak0TKPR6axrmuNhBPq0nDwQWfCuvmUjhcu4D6RFCg@mail.gmail.com>
References: <1362047181.3128.22.camel@dabdike.int.hansenpartnership.com>
 <CAG-2HqVWx7ORjk=5x_KJGS_enMphAhBH7iitE6Cro9ktg1=wDw@mail.gmail.com> <1362052527.3128.29.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362052527.3128.29.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 28, 2013 at 12:55 PM, James Bottomley
<jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> If you want a filesystem
> in /sys, then you have the same problem as debugfs and cgroupfs, so it
> can't be done without distro support: specifically a fstab entry, so
> this patch is as far as the kernel should go.

Sure, something would have to do the actual mounting for you. In
systemd this is done during early boot to /sys/firmware/efi/efivars/
[0], which means that until Matt's rework is in, it will only work
when efivars is compiled into the kernel.

> Even a split won't solve the problem that the directory won't exist
> until the modules are loaded and the modules are autoloaded by the mount
> call, so the problem is the same whether the modules are split or
> monolithic.

Sorry, I was unclear. The efi subsystem itself would not be a module,
and hence /sys/firmware/efi/efivars would always exist if the system
supports it (similarly to, say, /sys/firmware/acpi). The relevant
patch is here [1].

> We definitely need this patch in 3.8 because that's where the efivarfs
> filesystem was added, so it should probably have a cc stable which I
> forgot.

Yeah, that might make sense for now (though, due to the above, this
would not really help any of the distros, so they'd need to compile
efivars into the kernel anyway).

Cheers,

Tom

[0]: <http://cgit.freedesktop.org/systemd/systemd/tree/src/core/mount-setup.c#n93>
[1]: <http://www.mail-archive.com/linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg00785.html>
