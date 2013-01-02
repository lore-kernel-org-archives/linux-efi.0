From: Robin Holt <holt-sJ/iWh9BUns@public.gmane.org>
Subject: Re: BUG: unable to handle kernel paging request at 000000effd870020
Date: Wed, 2 Jan 2013 15:09:58 -0600
Message-ID: <20130102210958.GD3470@sgi.com>
References: <20130102172107.GA26761@gulag1.americas.sgi.com>
 <50E476C2.7060300@zytor.com>
 <50E486E7.1080903@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50E486E7.1080903-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 02, 2013 at 01:13:43PM -0600, Nathan Zimmer wrote:
> On 01/02/2013 12:04 PM, H. Peter Anvin wrote:
> >On 01/02/2013 09:21 AM, Nathan Zimmer wrote:
> >>I am getting an early boot problem. It only happens on the larger of the
> >>machines I haven't seen it crop up on machines with more then 512 GB of ram.
> >>It shows in the latest linus kernel too.
> >>
> >>I am (wildly) guessing that what is happening is that the new_memmap that is
> >>being passed to bios is somehow placed incorrectly.
> >>I have come up with a workaround.  By placing it the DMA area the issue goes
> >>away but that doesn't seem like a real fix.
> >>
> >What does your memory map look like?

We reported this a few times (Russ Anderson and I both).  The problem is
at the point in boot where the efi_enter_virtual_mode callback is, there
is no identity mapping for most of memory.  If the allocation happens
to be above the 512GB (or maybe something lower than that) point, the
BIOS is not able to address this via the physical address passed to it.

Russ' solution was to not remap at all.  The interim workaround I have
been using is adding a GFP_DMA flag to the kmalloc.  An earlier post I
made to the list was to pass in the va to the new memmap table.

Robin
