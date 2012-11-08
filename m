From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [RFC] [PATCH] X86 MSR read whitelist
Date: Thu, 8 Nov 2012 15:36:03 +0000
Message-ID: <20121108153603.6765c0bf@pyramind.ukuu.org.uk>
References: <1352323699-52400-1-git-send-email-trenn@suse.de>
	<20121107232722.67589868@pyramind.ukuu.org.uk>
	<201211081519.23364.trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201211081519.23364.trenn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> What exactly could go wrong with which MSR read?

Show me a pair of Intel and AMD architecture documents guaranteeing all
undefined, undocumented, and documented MSR reads for all processors have
no side effects.

> I just picked some MSRs I found in turbostat and cpupower.
> Len: It would be great if you could contribute to cpupower.
> It can do exactly the same than turbostat (but for all archs)
> and the fixups you send for turbostat are very easy to integrate
> into cpupower as well.

I suspect the number you need is very smal fortunately (and that they
could be properly exposed by a kernel interface that knows the CPU type
and what is needed for each - be that a chopped down msr driver or
something saner)

> > I would also look at MTRRs because mis-setting MTRRs
> > allows you to get firmware to do interesting things in certain
> > situations because the commands being issued to stuff like the GPU may
> > get corrupted.
> I am not aware of a mtrr interface to userspace.

/proc/mtrr


> +static u32 msr_intel_wl[] =
> +	{
> +		0x198, /* MSR_IA32_PERF_STATUS */
> +		0x1a0, /* MSR_IA32_MISC_ENABLES */
> +		0x1b0, /* MSR_IA32_ENERGY_PERF_BIAS */
> +		0xce,  /* MSR_NEHALEM_PLATFORM_INFO */
> +		0x1ad, /* MSR_NEHALEM_TURBO_RATIO_LIMIT */
> +		0x3f8, /* MSR_PKG_C3_RESIDENCY */
> +		0x3f9, /* MSR_PKG_C6_RESIDENCY */
> +		0x3fc, /* MSR_CORE_C3_RESIDENCY */
> +		0x3fd, /* MSR_CORE_C6_RESIDENCY */

I believe you need to verify precisely which processor each is
architecturally defined for and whitelist according to a CPU match.

Alan
