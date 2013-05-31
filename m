From: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable info
 to runtime code
Date: Fri, 31 May 2013 07:54:22 -0400
Message-ID: <CA+5PVA7d6=5ruagDeFPvpcxOLu5AkJVfyVgqvjXhheh9n_apjg@mail.gmail.com>
References: <20130524074331.GL14575@console-pimps.org>
	<20130529210115.GC28027@sgi.com>
	<alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	<20130529224645.GA16582@sgi.com>
	<alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
	<1369880172.17397.11.camel@linux-s257.site>
	<20130530221737.GA11105@sgi.com>
	<alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
	<20130531101250.GD30394@gmail.com>
	<alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
	<20130531114037.GC7131@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130531114037.GC7131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 31, 2013 at 7:40 AM, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org> wrote:
>
>> On Fri, 31 May 2013, Ingo Molnar wrote:
>>
>> > > Unfortunately that means that you can as well throw the patch away
>> > > completely.
>> > >
>> > > The sole point is to run the QueryVariableInfo() from the boot
>> > > environment, in order to obtain more accurate information. And it's
>> > > a valid thing to do, according to UEFI specification.
>> >
>> > So this change needs to be reverted or fixed.
>>
>> I don't think anyone is arguing against that.
>
> The statement I replied to above can be fairly read as arguing against it.
>
> Anyway, given that the fix (workaround) from Boris seems elaborate so late
> in the v3.10 cycle, does everyone else agree with a revert as well?

If you go with a revert, please make sure to tag it for stable to it
gets picked up with 3.9.y.

josh
