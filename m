From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 04/16] x86/efi: Generating random number in EFI stub
Date: Fri, 31 Jul 2015 17:12:23 +0800
Message-ID: <20150731091223.GB13113@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-5-git-send-email-jlee@suse.com>
 <1438270662.11322.6.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438270662.11322.6.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

Hi Matt, 

Thanks for your review!

On Thu, Jul 30, 2015 at 04:37:42PM +0100, Matt Fleming wrote:
> On Thu, 2015-07-16 at 22:25 +0800, Lee, Chun-Yi wrote:
> > This patch adds the codes for generating random number array as the
> > HMAC key that will used by later EFI stub codes.
> > 
> > The original codes in efi_random copied from aslr and add the codes
> > to accept input entropy and EFI debugging. In later patch will add
> > the codes to get random number by EFI protocol. The separate codes
> > can avoid impacting aslr function.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  arch/x86/boot/compressed/Makefile     |  1 +
> >  arch/x86/boot/compressed/efi_random.c | 88 +++++++++++++++++++++++++++++++++++
> >  arch/x86/boot/compressed/misc.c       |  4 +-
> >  arch/x86/boot/compressed/misc.h       |  2 +-
> >  4 files changed, 92 insertions(+), 3 deletions(-)
> >  create mode 100644 arch/x86/boot/compressed/efi_random.c
> 
> [...]
> 
> > +static unsigned long get_random_long(unsigned long entropy,
> > +				     struct boot_params *boot_params,
> > +				     efi_system_table_t *sys_table)
> > +{
> > +#ifdef CONFIG_X86_64
> > +	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
> > +#else
> > +	const unsigned long mix_const = 0x3f39e593UL;
> > +#endif
> > +	unsigned long raw, random;
> > +	bool use_i8254 = true;
> > +
> > +	efi_printk(sys_table, " EFI random");
> 
> Probably want to remove these efi_printk()s from the final version ;-)
> 

OK, I will remove those log.

> > +	if (entropy)
> > +		random = entropy;
> > +	else
> > +		random = get_random_boot(boot_params);
> > +
> > +	if (rdrand_feature()) {
> > +		efi_printk(sys_table, " RDRAND");
> > +		if (rdrand_long(&raw)) {
> > +			random ^= raw;
> > +			use_i8254 = false;
> > +		}
> > +	}
> > +
> > +	if (rdtsc_feature()) {
> > +		efi_printk(sys_table, " RDTSC");
> > +		rdtscll(raw);
> > +
> > +		random ^= raw;
> > +		use_i8254 = false;
> > +	}
> > +
> > +	if (use_i8254) {
> > +		efi_printk(sys_table, " i8254");
> > +		random ^= i8254();
> > +	}
> > +
> > +	/* Circular multiply for better bit diffusion */
> > +	asm("mul %3"
> > +	    : "=a" (random), "=d" (raw)
> > +	    : "a" (random), "rm" (mix_const));
> > +	random += raw;
> > +
> > +	efi_printk(sys_table, "...\n");
> > +
> > +	return random;
> > +}
> > +
> > +void efi_get_random_key(efi_system_table_t *sys_table,
> > +			struct boot_params *params, u8 key[], int size)
> > +{
> 
> I would think that the size of the key array should be unsigned.
>

I will change size to unsigned int.


Thanks
Joey Lee 
