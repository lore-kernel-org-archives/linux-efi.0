From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 08:22:47 +0000
Message-ID: <531D84670200007800122375@nat28.tlf.novell.com>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com> <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
 <531D7786020000780012230D@nat28.tlf.novell.com>
 <20140310073753.GA4658@gmail.com>
 <531D7BA80200007800122349@nat28.tlf.novell.com>
 <20140310075306.GB4939@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20140310075306.GB4939@gmail.com>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, Matt Fleming <matt.fleming@intel.com>, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Dan Carpenter <dan.carpenter@oracle.com>, Ingo Molnar <mingo@redhat.com>, Nathan Zimmer <nzimmer@sgi.com>, Matthew Garrett <mjg59@srcf.ucam.org>, kernel-janitors@vger.kernel.org, linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

>>> On 10.03.14 at 08:53, Ingo Molnar <mingo@kernel.org> wrote:
>> [...] Remember the far from insignificant number of issues with the 
>> ACPI interrupt source overrides for particularly the timer interrupt 
>> years ago? Which wasn't a reason to stop trying to use ACPI wherever 
>> possible, even on affected systems (by introducing command line 
>> overrides).
> 
> That's an apples to oranges comparison IMO, the motivation for that 
> was real on real systems: to get high(er) resolution time and 
> interrupt sources.

What has that got to do with getting higher resolution? IRQ0 is IRQ0,
irrespective whether driven by an 8254 or a HPET. The workaround
was needed to get IRQ0 to work properly _at all_.

> What's the upside here, for existing systems? Please don't mistake me: 
> if an upside exists I'm not against it, at all.

The upside isn't so much on existing systems that work with the
intended model, but on those that don't: Increasing awareness
and pressure on the firmware vendors' side to get their bugs
fixed. Just like - afaict - the ratio of systems with broken ACPI
tables has gone down over time.

Just to give an example from the Xen side: Xen uses the time
interface in UEFI, as you would expect not without problems. Apart
from issues with memory areas needed by those runtime calls not
being properly marked for runtime use (which the respective
vendors accepted they need to fix), we are also facing problems
with runtime calls using XMM registers. Rather than blindly saying
"the specification isn't precise on this, and e.g. Linux has a half
baked mechanism to deal with this, so let's just do so too" we're
pushing for the specification to get updated, such that it becomes
clear whether the firmware may do so and we need to change Xen,
or whether it's the firmware people needing to fix their
implementation. Doing it that way is cumbersome, yes, but I think
it is in the best interest of everybody involved (and better than
papering over bugs by avoiding certain functionality). And yes,
should such a machine reach customer hands, and should we get
reports that there's no way for them to boot it with Xen, we can
always add a command line override telling the hypervisor to
avoid the broken runtime service and use direct CMOS accesses
instead.

The approach you lobby - avoid the runtime service by default -
will just result in further delaying the fixing of the firmware bugs.

(The one real upside - getting time zone information - was
already mentioned by someone else on this thread.)

Jan

