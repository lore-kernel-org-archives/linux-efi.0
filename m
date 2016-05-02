From: Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Mon, 2 May 2016 15:17:00 -0700
Message-ID: <5727D1DC.7020509@sgi.com>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
 <20160430221209.GO2839@codeblueprint.co.uk>
 <20160502213931.GT113599@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502213931.GT113599-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 5/2/2016 2:39 PM, Alex Thorlton wrote:
>> > Who owns the MMR space and what is it used for? Do both the kernel and
>> > the firmware need access to it? My SGI UV knowledge is zero, so I'm
>> > happy to be educated! I can't think of any analogous memory regions on
>> > x86 where the EFI services require the kernel to map them, other than
>> > the EFI regions themselves.
>
> We have MMRs that get used for a ton of different purposes.  I'm only
> familiar with the details of a few of them, but they provide a bunch of
> information about various bits of SGI-specific hardware (i.e. the hub
> and the BAU) and I think there are also some that allow you to control
> that hardware.
> 
> This is more Mike Travis's department - he might be able to paint a
> better picture.
> 

I don't have the complete picture either.  But from what I do understand,
the answer is "yes", BIOS and the kernel both access the MMRs during the
lifetime of the system operation.  The vast majority of the MMRs are setup
by UV BIOS during system startup.  At some point they switch from each
blade/board/chassis running separately, to one doing overall system setup.
Then BIOS hands over the system to the kernel as expected.

After the hand off, the kernel and drivers, use the MMRs for machine control
and feedback.  In addition, various services are provided by BIOS in the
"System Management Mode" layer.  I'm not completely sure how the regs are
shared while in this mode, I think they both need the same address mappings.
Russ or Dimitri would know more about this, as this is the "kernel/BIOS
interface" the efi bios callbacks are using (most commonly in UV kernel
modules).
