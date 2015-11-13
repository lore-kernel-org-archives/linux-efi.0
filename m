From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 6/6] Documentation/x86: Update EFI memory region description
Date: Fri, 13 Nov 2015 08:42:54 -0800
Message-ID: <CA+55aFxeyspaa_VCv9fRqTpuamFD95siSx9oXp57aO3Fi=EwXw@mail.gmail.com>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
	<1447342823-3612-7-git-send-email-matt@codeblueprint.co.uk>
	<20151113092210.GB19922@gmail.com>
	<20151113092906.GD2716@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151113092906.GD2716-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 13, 2015 at 1:29 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Fri, 13 Nov, at 10:22:10AM, Ingo Molnar wrote:
>
> You've snipped the patch hunk that gives the address range used,

I'm actually wondering if we should strive to make the UEFI stuff more
like a user process, and just map the UEFI mappings in low memory in
that magic UEFI address space.

We won't be able to run those things *as* user space, since I assume
the code will want to do a lot of kernely things, but shouldn't we aim
to make it look as much like that as possible? Maybe some day we could
even strive to run it in some controlled environment (ie user space
with fixups, virtual machine, whatever), but even if we never get
there it sounds like a potentially good idea to try to set up the
mappings to move in that direction..

No big hurry, and maybe there are good reasons not to go that way. The
first step is indeed just to get rid of the WX mappings in the normal
kernel page tables.

               Linus
