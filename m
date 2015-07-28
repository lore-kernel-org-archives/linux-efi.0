From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [RFC PATCH 04/16] x86/efi: Generating random number in EFI stub
Date: Tue, 28 Jul 2015 14:01:12 +0200
Message-ID: <20150728120112.GA9518@amd>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-5-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437056730-15247-5-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi!

> This patch adds the codes for generating random number array as the
> HMAC key that will used by later EFI stub codes.
> 
> The original codes in efi_random copied from aslr and add the codes
> to accept input entropy and EFI debugging. In later patch will add
> the codes to get random number by EFI protocol. The separate codes
> can avoid impacting aslr function.
> 
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>

> +#define X86_FEATURE_EDX_TSC	(1 << 4)
> +#define X86_FEATURE_ECX_RDRAND	(1 << 30)

Can you pull it from existing includes somewhere?

> +static bool rdrand_feature(void)
> +{
> +	return (cpuid_ecx(0x1) & X86_FEATURE_ECX_RDRAND);
> +}
> +
> +static bool rdtsc_feature(void)
> +{
> +	return (cpuid_edx(0x1) & X86_FEATURE_EDX_TSC);
> +}

Are these helpers neccessary?

> +	if (rdrand_feature()) {
> +		efi_printk(sys_table, " RDRAND");
> +		if (rdrand_long(&raw)) {
> +			random ^= raw;
> +			use_i8254 = false;
> +		}
> +	}
> +
> +	if (rdtsc_feature()) {
> +		efi_printk(sys_table, " RDTSC");
> +		rdtscll(raw);
> +
> +		random ^= raw;
> +		use_i8254 = false;
> +	}

You'll do two (expensive) cpuids calls here.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
