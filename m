From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: Shorten efi regions output
Date: Tue, 9 Dec 2014 17:45:03 +0100
Message-ID: <20141209164503.GD3990@pd.tnic>
References: <20141209095843.GA3990@pd.tnic>
 <548716C5.6000506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <548716C5.6000506-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 09, 2014 at 04:35:33PM +0100, Laszlo Ersek wrote:
> I disagree with the patch in general, and I strongly disagree with this
> specific change in particular. This part:
> 
> - breaks the alignment for the right side of the table

Well, we can start by removing the sizes - they're useless anyway and
can be computed with a simple awk script or whatever. I.e.,

...
[    0.000000] efi: mem23: [0x000000007ee3b000-0x000000007ee4e000) [RtData     |RT|WB|WT|WC|UC])
[    0.000000] efi: mem24: [0x000000007ee4e000-0x000000007fd4e000) [BootData   |WB|WT|WC|UC]
[    0.000000] efi: mem25: [0x000000007fd4e000-0x000000007fece000) [BootCode   |WB|WT|WC|UC]
[    0.000000] efi: mem26: [0x000000007fece000-0x000000007fefe000) [RtCode     |RT|WB|WT|WC|UC]
[    0.000000] efi: mem27: [0x000000007fefe000-0x000000007ff22000) [RtData     |RT|WB|WT|WC|UC]
...

Then we could do some more work like fishing out columns and removing
those which are not set in any region from the output completely and
then have alignment but with only the relevant fields, ...

> - completely defeats another of my goals with the original patch, which
>   was to be able to get an overview of memory attributes *at a glance*.
>   That only works if each column is strictly associated with one bit,
>   and your gaze can slide over empty stretches.

Well, and empty column doesn't tell me a whole lot, does it?

[    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)

I still have to go and look up what those 5 empty bits mean. Thus my
angle was: if it is not set, don't print it.

>   Please compare how you visually execute a search for the next
>   runtime region (or the next non-WB line) before and after.

I'd look for region names RtData/RtCode.

Unless this dump is supposed to be used to sanity-check region attribute
flags too, then I see your point about the alignment.

> Your patch shaves off 30 characters of the width if I measured it right
> (goes from 131 to 101.) I don't believe that would justify breaking the
> alignment of the columns. For example, you could remove 15 characters
> from the right just with "dmesg -t" (timestamps are probably not overly
> important for printing the memmap).

Yeah, but you can look at that output with other means, i.e. serial
console/netconsole/guest boot log, etc.

> Anyway it's a matter of taste. I know you work with this every day so if
> it doesn't meet your needs then I won't insist preserving it. I won't
> NACK the patch it but I certainly won't ACK it either.

Ok, fair enough. Let's see what the others think.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
