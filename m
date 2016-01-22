From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 3/4] x86/efi: print size and base in binary units in
 efi_print_memmap
Date: Fri, 22 Jan 2016 12:10:02 -0800
Message-ID: <20160122121002.02f1b4f7f04eae3189447873@linux-foundation.org>
References: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453389752-68175-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<20160121143558.2ae43ccf550e1693cd05834f@linux-foundation.org>
	<CAHp75VcCvpbamGurVVzXBGcYMCexpTZ4esg8YbKmzAu+iibyrw@mail.gmail.com>
	<20160122151100.GA3747@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122151100.GA3747-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 22 Jan 2016 15:11:00 +0000 Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> > >> +                     md->phys_addr, md->phys_addr + size - 1,
> > >
> > > So I did s/ - 1// here, but worried.
> > 
> > I'm pretty sure the series should go via efi tree.
> 
> Right, because of the prerequisite patches sat in my tree it makes
> sense for them to all be grouped together.
> 
> Andrew, would you mind dropping these from your tree and I'll take
> everything through the EFI tree?
> 
> Additionally, if you and Rasmus wanted to throw a couple of Acked-by
> or Reviewed-by tags my way, I'd feel better about the string_helpers
> patches.

No probs.  Please add Acked-by: Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> to [1/4] and [2/4].
