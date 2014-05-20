From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 3/5] xen: Put EFI machinery in place
Date: Tue, 20 May 2014 12:58:27 +0100
Message-ID: <537B5F8302000078000140F2@mail.emea.novell.com>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
 <537B2494.2080702@citrix.com>
 <20140520112933.GF3529@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140520112933.GF3529-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 20.05.14 at 13:29, <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, May 20, 2014 at 10:47:00AM +0100, David Vrabel wrote:
>> On 16/05/14 21:41, Daniel Kiper wrote:
>> > @@ -1714,6 +1725,21 @@ asmlinkage __visible void __init xen_start_kernel(void)
>> >
>> >  	xen_setup_runstate_info(0);
>> >
>> > +	efi_systab_xen = xen_efi_probe();
>> > +
>> > +	if (efi_systab_xen) {
>> > +		strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
>> > +				sizeof(boot_params.efi_info.efi_loader_signature));
>> > +		boot_params.efi_info.efi_systab = (__u32)((__u64)efi_systab_xen);
>> > +		boot_params.efi_info.efi_systab_hi = (__u32)((__u64)efi_systab_xen >> 32);
>> > +
>> > +		x86_platform.get_wallclock = efi_get_time;
>>
>> x86_platform.get_wallclock should always be xen_get_wallclock().
> 
> Hmmm... Make sens... Jan, why did you replace x86_platform.get_wallclock
> with efi_get_time() in your implementation?

On the basis that (for Dom0 only) this is the equivalent of (and
actually also falls back to) mach_get_cmos_time(). If on Dom0
.get_wallclock doesn't get set to mach_get_cmos_time() on
pv-ops, then that line above should also be dropped.

Jan
