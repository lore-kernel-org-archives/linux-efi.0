From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Thu, 27 Jun 2013 15:54:33 +0100
Message-ID: <CACxGe6uyMjT8HGb16+eqgCwZEDOuC6nkORvej2uGra3oCnyLwg@mail.gmail.com>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org> <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
 <20130626135311.GA9078@rocoto.smurfnet.nu> <20130626135933.GQ22026@console-pimps.org>
 <1372257499.2168.5.camel@dabdike> <20130627013219.GA346@srcf.ucam.org>
 <CACxGe6uFkbuJ3BxM=A0Lu=jZQ79Ba8SmNsdBdTOO13szTfTZ=Q@mail.gmail.com> <1372314821.557.33.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372314821.557.33.camel@dabdike>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 27, 2013 at 7:33 AM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Thu, 2013-06-27 at 07:23 +0100, Grant Likely wrote:
>> On Thu, Jun 27, 2013 at 2:32 AM, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:
>> > On Wed, Jun 26, 2013 at 07:38:19AM -0700, James Bottomley wrote:
>> >> The fixed virtual address scheme currently being looked at for x86_64 to
>> >> make SetVirtualAddressMap() kexec invariant doesn't work on 32 bit
>> >> because the address space isn't big enough.  For ARM, given that we've
>> >> much more opportunity to work with the vendors, can we just avoid
>> >> transitioning to a virtual address map and always just install a
>> >> physical mapping before doing efi calls?
>> >
>> > We can probably get away with that now, but it does risk us ending up
>> > with some firmware that expects to run in physical mode (boards designed
>> > for Linux) and some firmware that expects to run in virtual mode (boards
>> > designed for Windows). The degree of lockdown in the Windows ecosystem
>> > at present means it's not a real problem at the moment, but if that ever
>> > changes we're going to risk incompatibility.
>>
>> What is the problem trying to be avoided by not using the virtual map?
>> Is it passing the virtual mapping data from one kernel to the next
>> when kexecing? Or something else?
>
> Where to begin ... SetVirtualAddressMap() is one massive hack job ...
> just look at the tiano core implementation.   Basically it has a fixed
> idea of where all the pointers are and it tries to convert them all to
> the new address space.  The problem we see in x86 is that this
> conversion process isn't exhaustive due to implementation cockups, so
> the post virtual address map image occasionally tries to access
> unconverted pointers via the old physical address and oopses the kernel.

Would it be possible to run the UEFI hooks in some form of pseudo
userspace thread that protects against dereferencing addresses that
are no longer UEFI addresses?

> The problem for kexec is that SetVirtualAddressMap isn't idempotent.  In
> fact by API fiat it can only ever be called once for the entire lifetime
> of the UEFI bios, which could be many kernels in a kexec situation.  So,
> somehow the subsequent kernels have to know not to call it, plus,
> obviously, the virtual address map of the previous kernel has to work in
> the next because it can't set up a new one.

For this problem at least I think we've got a solution on ARM because
the virtual map can be passed across the kexec boundary via the device
tree. It will still (probably) need to be located in the ioremap
region and the size of the map will push down the maximum address for
ioremapping. The value of VMALLOC_END on arm 32bit is 0xff000000 and
that is a pretty stable number. As long as both the new and old
kernels have the same VMALLOC_END (very likely) then it should be okay
to pass the map over.

Let me know if I'm missing something important.

g.
