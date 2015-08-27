From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 05/16] x86/efi: Get entropy through EFI random number
 generator protocol
Date: Thu, 27 Aug 2015 14:17:50 +0800
Message-ID: <20150827061750.GE24088@linux-rxt1.site>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-6-git-send-email-jlee@suse.com>
 <20150820202620.GF2567@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150820202620.GF2567-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 20, 2015 at 09:26:20PM +0100, Matt Fleming wrote:
> On Tue, 11 Aug, at 02:16:25PM, Lee, Chun-Yi wrote:
> > +
> > +static unsigned long efi_get_rng64(efi_system_table_t *sys_table,
> > +				   void **rng_handle)
> > +{
> > +	const struct efi_config *efi_early = __efi_early();
> > +	efi_rng_protocol_64 *rng = NULL;
> > +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
> > +	u64 *handles = (u64 *)(unsigned long)rng_handle;
> > +	efi_status_t status;
> > +	unsigned long rng_number;
> > +
> > +	status = efi_call_early(handle_protocol, handles[0],
> > +				&rng_proto, (void **)&rng);
> > +	if (status != EFI_SUCCESS)
> > +		efi_printk(sys_table, "Failed to get EFI_RNG_PROTOCOL handles\n");
> > +
> > +	if (status == EFI_SUCCESS && rng) {
> > +		status = efi_early->call((unsigned long)rng->get_rng, rng, NULL,
> > +					sizeof(rng_number), &rng_number);
> 
> Actually, one thing just occurred to me - you're not passing an
> RNGAlgorithm value and are relying upon the firmware's default
> implementation.
> 
> I don't think that's a safe bet, the default could be anything and
> might vary across implementations.
> 

I didn't set specific RNGAlgorithm because different BIOS may
set different algorithm as default, it's also a kind of random situation
to provide uncertainty.

On the other hand, if the specific RNGAlgorithm doesn't support by BIOS
then EFI stub still need use BIOS's _default_ algorithm to get random
value.

> Can we do a little better here and pick a "preferred" algorithm
> instead of the default?
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

Per EDK2 implementation, EFI_RNG_ALGORITHM_SP800_90_CTR_256 is the default
algorithm that provided by driver, and EFI_RNG_ALGORITHM_RAW is the second
algorithm supported by EDK2. BIOS vendor need to write driver to support
others.

Maybe using EFI_RNG_ALGORITHM_SP800_90_CTR_256 as the default RNGAlgorithm
in efi_random can cover the most widely UEFI implementation, but when BIOS
do not support EFI_RNG_ALGORITHM_SP800_90_CTR_256 then kernel still need
use BIOS's _default_ setting.

I hope your suggestion.


Thanks a lot!
Joey Lee
