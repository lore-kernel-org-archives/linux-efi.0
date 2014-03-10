From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 08:53:06 +0100
Message-ID: <20140310075306.GB4939@gmail.com>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
 <531D7786020000780012230D@nat28.tlf.novell.com>
 <20140310073753.GA4658@gmail.com>
 <531D7BA80200007800122349@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <531D7BA80200007800122349@nat28.tlf.novell.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Cc: Matt Fleming <matt@console-pimps.org>, Matt Fleming <matt.fleming@intel.com>, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Dan Carpenter <dan.carpenter@oracle.com>, Ingo Molnar <mingo@redhat.com>, Nathan Zimmer <nzimmer@sgi.com>, Matthew Garrett <mjg59@srcf.ucam.org>, kernel-janitors@vger.kernel.org, linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 10.03.14 at 08:37, Ingo Molnar <mingo@kernel.org> wrote:
> 
> > * Jan Beulich <JBeulich@suse.com> wrote:
> > 
> >> >>> On 09.03.14 at 19:50, Matt Fleming <matt@console-pimps.org> wrote:
> >> > On Sun, 09 Mar, at 04:31:41PM, Matthew Garrett wrote:
> >> >> On Sun, Mar 09, 2014 at 04:20:20PM +0000, Matt Fleming wrote:
> >> >> 
> >> >> > We have tried to use the time functions before, with little success
> >> >> > because of various bugs in the runtime implementations, e.g. see commit
> >> >> > bacef661acdb ("x86-64/efi: Use EFI to deal with platform wall clock")
> >> >> > and commit bd52276fa1d4 ("x86-64/efi: Use EFI to deal with platform wall
> >> >> > clock (again)").
> >> >> 
> >> >> I'd naively expected that these would be more reliable after the 
> >> >> 1:1 mapping patches, so it might actually be time to give them 
> >> >> another go.
> >> > 
> >> > Is there any value in that? Do machines exist where we absolutely 
> >> > must have access to the EFI time services? Either because there's 
> >> > no other method or no other working one?
> >> 
> >> Is it such a bad thing to be prepared for this sort of machine to 
> >> arrive even if likely there are none so far?
> > 
> > "Be prepared for a not yet existing machine" != "time to give them 
> > another go on existing machines", right?
> 
> That heavily depends on the perspective you take, [...]

The inequality I mention above is purely factual, so it does not 
depend on perspective.

> [...] and I know we tend to have disagreeing perspectives here: I 
> think things should be done the intended way on all systems where 
> this is possible. [...]

The problem is that on 99% of these systems the "intended way" at 
hardware design time was to run Windows and only Windows.

Firmware interfacing problems are a lot less severe on ARM, where 99% 
of the systems are intended to run Linux.

So it's all inflicted on us artificially, and when it comes to Windows 
hardware we have no choice but to act defensively, not in an 
optimistic, anticipatory fashion.

> [...] Remember the far from insignificant number of issues with the 
> ACPI interrupt source overrides for particularly the timer interrupt 
> years ago? Which wasn't a reason to stop trying to use ACPI wherever 
> possible, even on affected systems (by introducing command line 
> overrides).

That's an apples to oranges comparison IMO, the motivation for that 
was real on real systems: to get high(er) resolution time and 
interrupt sources.

What's the upside here, for existing systems? Please don't mistake me: 
if an upside exists I'm not against it, at all.

Thanks,

	Ingo
