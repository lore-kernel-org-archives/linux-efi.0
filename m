From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH] block: partitions: efi: Always check for alternative GPT
 at end of drive
Date: Tue, 26 Apr 2016 14:15:47 -0700
Message-ID: <20160426211547.GC16601@linux-uzut.site>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
 <20160426102014.o7k77uzi32h73y3b@ws.net.home>
 <20160426183353.GB16601@linux-uzut.site>
 <94D0CD8314A33A4D9D801C0FE68B402963904365@G4W3296.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402963904365-wwDBVnaDRpYSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Apr 2016, Elliott, Robert (Persistent Memory) wrote:

>The UEFI specification is not ambiguous - you should always look
>for the backup GPT Header at the last LBA:
>
>"Two GPT Header structures are stored on the device: the primary
>and the backup. The primary GPT Header must be located in LBA 1
>(i.e., the second logical block), and the backup GPT Header must
>be located in the last LBA of the device."
>
>If the primary GPT Header is corrupted (e.g., CRC is bad), you
>cannot trust any fields in it, including the Alternate LBA field.

I'm well aware of this, and is really what I meant with 'ambiguous'
(which was ambiguous in itself). All I'm arguing is that I don't see
a solid reason to change the default, when we have (and have had for
a long time) the gpt param alternative.

>The Alternate LBA field is there to help you tolerate failures
>while growing or shrinking the block device size (not important
>for individual physical drives, but an issue for logical drives
>presented by RAID controllers).

I have nothing against the agpt, just pass a boot param and voila,
you can use it. This is not some sort of recent regression we are
talking about here. How is this such a burden all of a sudden?

Thanks,
Davidlohr
