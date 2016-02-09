From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 14/14] x86/efi: Print size in binary units in
 efi_print_memmap
Date: Tue, 9 Feb 2016 13:20:18 +0100
Message-ID: <20160209122018.GA4178@gmail.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-15-git-send-email-matt@codeblueprint.co.uk>
 <56B0756E.9010603@redhat.com>
 <20160203104045.GB7310@gmail.com>
 <20160203112829.GC2597@codeblueprint.co.uk>
 <94D0CD8314A33A4D9D801C0FE68B40295BF72A9F@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BF72A9F@G4W3202.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Laszlo Ersek <lersek@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org


* Elliott, Robert (Persistent Memory) <elliott@hpe.com> wrote:

> 
> > -----Original Message-----
> > From: Matt Fleming [mailto:matt@codeblueprint.co.uk]
> > Sent: Wednesday, February 3, 2016 5:28 AM
> > To: Ingo Molnar <mingo@kernel.org>
> > Cc: Laszlo Ersek <lersek@redhat.com>; H . Peter Anvin <hpa@zytor.com>;
> > Thomas Gleixner <tglx@linutronix.de>; linux-efi@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Elliott, Robert (Persistent Memory)
> > <elliott@hpe.com>; Andy Shevchenko <andriy.shevchenko@linux.intel.com>;
> > Ard Biesheuvel <ard.biesheuvel@linaro.org>; Taku Izumi
> > <izumi.taku@jp.fujitsu.com>; Linus Torvalds <torvalds@linux-
> > foundation.org>; Andrew Morton <akpm@linux-foundation.org>
> > Subject: Re: [PATCH 14/14] x86/efi: Print size in binary units in
> > efi_print_memmap
> ...
> > OK, this patch has caused enough headaches. Let's drop it from this
> > series.
> > 
> > Robert, Andy, feel free to resubmit it after you've addressed
> > everyone's concerns and we can discuss it in isolation.
> 
> We could just delete the size print altogether - better to print
> nothing than a silently rounded number.  The end address already
> communicates the size - it's just not as readable.  
> 
> The e820 table prints don't bother with a size print. 
> 
> That would also shorten these extremely wide prints to 116
> characters (131 if printk time is enabled).
> 
> [    0.000000] BIOS-e820: [mem 0x0000001880000000-0x000000207fffffff] reserved
> vs.
> [    0.000000] efi: mem62: [Reserved           |   |  |NV|  |  |  |  |   |WB|WT|WC|UC] range=[0x0000001880000000-0x000000207fffffff] (32 GiB)

So I find the latter a lot more readable - my terminals are wide enough ;-)

Humans are also rather bad at parsing 64-bit hexa address ranges at a glance, so 
the size display is very useful.

But the flags portion should be shortened via appropriately chosen 
single-character abbreviations for the flags. Anyone deeply intimate with the code 
will recognize the flags - others won't care one way or another.

plus there's no need to write out 'range='.
  
... and please keep the size and just use GB/TB for chrissake.

I.e. something like this would work for me:

> [    0.000000] efi: mem62: 0x0000001880000000-0x000000207fffffff (  32 GB) .N....BTCU "Reserved"

Thanks,

	Ingo
