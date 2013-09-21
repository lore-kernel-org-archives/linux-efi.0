From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
Date: Sat, 21 Sep 2013 09:50:02 +0200
Message-ID: <20130921075002.GB7771@gmail.com>
References: <1379525333-4373-1-git-send-email-bemk@redhat.com>
 <20130920152859.GC21381@console-pimps.org>
 <1379708486.12705.131.camel@dhcp-128-237.ams.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379708486.12705.131.camel-0VdLhd/A9PkhetGgFr3ssPXAX3CI6PSWQQ4Iyu8u01E@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, 2013-09-20 at 16:28 +0100, Matt Fleming wrote:
> > On Wed, 18 Sep, at 07:28:53PM, Bart Kuivenhoven wrote:
> > > The problem in efi_main was that the idt was cleared before the
> > > interrupts were disabled.
> > > 
> > > The UEFI spec states that interrupts aren't used so this shouldn't be
> > > too much of a problem. Peripherals however don't necessarily know about
> > > this and thus might cause interrupts to happen anyway. Even if
> > > ExitBootServices() has been called.
> > >
> > > This means there is a risk of an interrupt being triggered while the IDT
> > > register is nullified and the interrupt bit hasn't been cleared,
> > > allowing for a triple fault.
> > 
> > Just to be clear, you haven't witnessed a triple fault, correct?
> > 
> > > This patch fixes this by clearing the interrupt bit before the lidt
> > > instruction.
> > 
> > I think we can go even further than this and get rid of all of the IDT
> > code in the EFI boot stub. The kernel maintains its own IDT anyway.
> > 
> 
> Well, isn't it so, that the kernel expects a setup in which interrupts 
> are disabled before the decompressed image is loaded?
> 
> What we can do is remove the lidt instruction and IDT pointer, but that 
> still doesn't change anything with regards to the kernels expectations.
> 
> And no, I haven't witnessed a triple fault, this is purely theoretical, 
> with a very slim chance of it actually happening. That does not mean 
> that it can't happen though.

it would also be very hard to prove that it occured (outside of special 
debug environments) - spurious, low probability triple faults are as 
undebuggable as it gets.

Thanks,

	Ingo
