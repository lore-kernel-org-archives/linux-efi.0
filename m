From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86, boot: Allow 64bit EFI kernel to be loaded above 4G
Date: Wed, 11 Feb 2015 15:55:24 +0000
Message-ID: <20150211155524.GC4665@codeblueprint.co.uk>
References: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
 <20150209182742.GQ6461@codeblueprint.co.uk>
 <CAE9FiQUFO4yfEVgGZ9U0Q-RaokFor1gMbKJ7As2vvqGVkqrDbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQUFO4yfEVgGZ9U0Q-RaokFor1gMbKJ7As2vvqGVkqrDbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 09 Feb, at 12:23:15PM, Yinghai Lu wrote:
> On Mon, Feb 9, 2015 at 10:27 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > On Tue, 03 Feb, at 06:03:20PM, Yinghai Lu wrote:
> >
> > The first thing that comes to mind is the issues we experienced last
> > year when adding support for loading initrds above 4GB to the EFI boot
> > stub, c.f. commit 47226ad4f4cf ("x86/efi: Only load initrd above 4g on
> > second try").
> >
> > Are things going to work correctly this time?
> 
> That should be addressed the grub2.
 
I vaguely remember thinking that the issue was only experienced when
using the EFI_FILE protocol, which grub2 doesn't use. So the grub
developers may be OK, but we should at least give them a heads up.

> I was thinking that we may need to add mem_limit command together with
> linuxefi and initrdefi.
> or add linuxefi64/initrdefi64?
 
No, we definitely do not want to add any more grub commands.

> BTW, I tested loading kernel above grub2 on
> virutalbox, qemu/kvm/OVMF, and real servers (ami ...) all work without problem.
> 
> wonder if we need have one black list for 64bit UEFI that does not
> support access
> memory above 4G.
 
We have been successful, so far, in not introducing these kind of
blacklists. It would be a shame to start now.

-- 
Matt Fleming, Intel Open Source Technology Center
