From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 10:43:28 +0000
Message-ID: <20140310104328.GG10262@console-pimps.org>
References: <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
 <531D7786020000780012230D@nat28.tlf.novell.com>
 <20140310073753.GA4658@gmail.com>
 <531D7BA80200007800122349@nat28.tlf.novell.com>
 <20140310075306.GB4939@gmail.com>
 <531D84670200007800122375@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <531D84670200007800122375@nat28.tlf.novell.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Dan Carpenter <dan.carpenter@oracle.com>, Ingo Molnar <mingo@redhat.com>, Nathan Zimmer <nzimmer@sgi.com>, Matthew Garrett <mjg59@srcf.ucam.org>, kernel-janitors@vger.kernel.org, linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 10 Mar, at 08:22:47AM, Jan Beulich wrote:
> 
> The upside isn't so much on existing systems that work with the
> intended model, but on those that don't: Increasing awareness
> and pressure on the firmware vendors' side to get their bugs
> fixed. Just like - afaict - the ratio of systems with broken ACPI
> tables has gone down over time.
 
I'm not saying that we can never use the time functions. All I'm saying
is that until there are actaul in-kernel users let's delete the code.
Feel free to bring them back when someone actually needs them.

We're evaluating the tradeoff between having the code around for future
use, and the resultant maintenance burden whenever the EFI code gets
refactored. Clearly the code is bitrotting, which is the issue that
started this thread. No, it's not bitrotting very fast, and yes things
still build, but code can't bitrot at all if it doesn't exist.

I think we're all pretty much agreed that at the very least
phys_efi_get_time() can go in the bin. Whatever the outcome of this
thread that'll happen. The question is whether it makes sense to rip out
all of the time stuff in one go.

> Just to give an example from the Xen side: Xen uses the time
> interface in UEFI, as you would expect not without problems. Apart
> from issues with memory areas needed by those runtime calls not
> being properly marked for runtime use (which the respective
> vendors accepted they need to fix), we are also facing problems
> with runtime calls using XMM registers.

Presumably you've got some kind of quirk mechanism to get things
working? That doesn't exist in the kernel so the time functions as-is
are useless, right? What's the benefit of using the EFI time services
for Xen? Does Xen use the current kernel functions directly?

But this is good, here is a concrete use case.

Regarding the XMM updates...

> Rather than blindly saying "the specification isn't precise on this,
> and e.g. Linux has a half baked mechanism to deal with this, so let's
> just do so too" we're pushing for the specification to get updated,
> such that it becomes clear whether the firmware may do so and we need
> to change Xen, or whether it's the firmware people needing to fix
> their implementation.  Doing it that way is cumbersome, yes, but I
> think it is in the best interest of everybody involved (and better
> than papering over bugs by avoiding certain functionality).

Pushing for clarification in the spec is definitely a good idea, and I
commend you for doing that. But you're talking about fundamental calling
conventions here, you're not discussing peripheral services that have a
track record of bearly being tested at runtime and of arguably limited
value when things do work.

But we're getting off topic here.

> (The one real upside - getting time zone information - was
> already mentioned by someone else on this thread.)
 
We can easily do that from the EFI boot stub, we don't need runtime
services to do that. And even if we did need runtime services, someone
needs to show me the patches that use them.

-- 
Matt Fleming, Intel Open Source Technology Center
