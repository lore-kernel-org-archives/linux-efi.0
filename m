From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Thu, 27 Jun 2013 16:37:16 +0100
Message-ID: <CACxGe6u2xU=+MzYLUbDLFB-9kA23TT2=otzM59zrbGWYt8x7Uw@mail.gmail.com>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org> <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
 <20130626135311.GA9078@rocoto.smurfnet.nu> <20130626135933.GQ22026@console-pimps.org>
 <1372257499.2168.5.camel@dabdike> <20130627013219.GA346@srcf.ucam.org>
 <CACxGe6uFkbuJ3BxM=A0Lu=jZQ79Ba8SmNsdBdTOO13szTfTZ=Q@mail.gmail.com>
 <1372314821.557.33.camel@dabdike> <20130627143714.GA12900@srcf.ucam.org> <1372345790.2522.26.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372345790.2522.26.camel@dabdike>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 27, 2013 at 4:09 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Thu, 2013-06-27 at 15:37 +0100, Matthew Garrett wrote:
>> On Wed, Jun 26, 2013 at 11:33:41PM -0700, James Bottomley wrote:
>> > On Thu, 2013-06-27 at 07:23 +0100, Grant Likely wrote:
>> > > What is the problem trying to be avoided by not using the virtual map?
>> > > Is it passing the virtual mapping data from one kernel to the next
>> > > when kexecing? Or something else?
>> >
>> > Where to begin ... SetVirtualAddressMap() is one massive hack job ...
>> > just look at the tiano core implementation.   Basically it has a fixed
>> > idea of where all the pointers are and it tries to convert them all to
>> > the new address space.  The problem we see in x86 is that this
>> > conversion process isn't exhaustive due to implementation cockups, so
>> > the post virtual address map image occasionally tries to access
>> > unconverted pointers via the old physical address and oopses the kernel.
>>
>> And yet it's the only mode in which the firmrware is actually tested
>> against an OS, so we don't have any real choice in the matter.
>
> Agree for x86 ... we just have to cope with the implementations we see
> in the field.  However, ARM has much more scope to have the UEFI
> implementation developed collaboratively with Linux as the reference
> platform.  If we can convince the ARM implementors that
> SetVirtualAddressMap is an accident waiting to happen, they might be
> more flexible.

We may not have any success convincing them of that; but given the
larger scope for Linux on ARM UEFI implementations, it will actually
get tested. If Linux chooses to use a 1:1 mapping, then the hardware
vendors will make sure a 1:1 mapping will actually work.

I must say that I'm a whole lot more comfortable with this approach.
I've never been comfortable with calling out to UEFI functions while
leaving the entirety of kernel space accessable. Sure UEFI can still
do nasty things if it really wants to and important devices get
mapped, but at least it will protect against accidental accesses.

g.
