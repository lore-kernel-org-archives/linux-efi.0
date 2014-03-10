From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 11:05:10 +0000
Message-ID: <531DAA7602000078001224EF@nat28.tlf.novell.com>
References: <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda> <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
 <531D7786020000780012230D@nat28.tlf.novell.com>
 <20140310073753.GA4658@gmail.com>
 <531D7BA80200007800122349@nat28.tlf.novell.com>
 <20140310075306.GB4939@gmail.com>
 <531D84670200007800122375@nat28.tlf.novell.com>
 <20140310104328.GG10262@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140310104328.GG10262-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>>> On 10.03.14 at 11:43, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Mon, 10 Mar, at 08:22:47AM, Jan Beulich wrote:
>> Just to give an example from the Xen side: Xen uses the time
>> interface in UEFI, as you would expect not without problems. Apart
>> from issues with memory areas needed by those runtime calls not
>> being properly marked for runtime use (which the respective
>> vendors accepted they need to fix), we are also facing problems
>> with runtime calls using XMM registers.
> 
> Presumably you've got some kind of quirk mechanism to get things
> working?

Not yet, since so far we haven't been shown issues with the code
on other than non-production systems.

> That doesn't exist in the kernel so the time functions as-is
> are useless, right?

Not sure why you call them useless. If wired up properly, they
would be useful on systems where they work.

> What's the benefit of using the EFI time services for Xen?

As said before: Don't suffer from there not being any wallclock
if there's no CMOS clock. With there even being a FADT flag to
indicate its absence, there clearly must be plans to have such
machines.

> Does Xen use the current kernel functions directly?

Which kernel functions? Perhaps just a misunderstanding - I
gave that example with the actual hypervisor in mind, not the
kernel side code sitting on top. The kernel, after all, can't
directly call EFI runtime code when running on top of Xen.

Jan
