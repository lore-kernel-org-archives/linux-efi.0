From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Wed, 26 Jun 2013 15:53:11 +0200
Message-ID: <20130626135311.GA9078@rocoto.smurfnet.nu>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org>
 <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Cc: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 26, 2013 at 02:20:23PM +0100, Grant Likely wrote:
> On Wed, Jun 26, 2013 at 12:42 AM, Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org> wrote:
> > the properties) should be part of a file in
> > Documentation/devicetree/bindings/ (arm/uefi.txt?).
> >
> > What node are these properties expected to be contained within?
> >
> > Shouldn't that node be required to contain a compatible value, which
> > would define the schema for the other properties?
> 
> Typically, a compatible property isn't only used for nodes that
> represent a device or a so-called 'virtual' device (ie. such as to
> describe how all the sound complex is wired together) since that
> should be the clue to an OS that a device driver will bind against the
> node. I think these properties can be dropped into /chosen without
> defining a new compatible value.
 
That would be my preference.
But yes, that should be documented, and will be in the next version.

> >> +Since UEFI firmware on ARM systems are required to use a 1:1 memory map
> >> +even on LPAE-capable systems, the above fields are 32-bit regardless.
> >
> > What about ARMv8? Is the intention to have a separate definition for the
> > UEFI bindings on ARMv8, so that compatibility isn't an issue? What if a
> > future version of UEFI allows LPAE usage?
> 
> It is unlikely that will happen on v7 since newer versions of UEFI are
> expected to remain backwards compatible with the current spec.
 
I'm going to go out on a limb here and claim that it wouldn't be possible
to do that compatibly. The current spec doesn't ban LPAE (or "use of long
descriptors"). But it does specify that all RAM known to UEFI must use a
1:1 mapping.

> >> +After the kernel has mapped the required regions into its address space,
> >> +a SetVirtualAddressMap() call is made into UEFI in order to update
> >> +relocations. This call must be performed with all the code in a 1:1
> >
> > Presumably "all the code" also includes "all .data and .bss", or
> > whatever the UEFI-equivalent may be? I'm not familiar with UEFI at all;
> > does the "EFI memory map" mentioned above describe all the memory
> > regions that must be mapped to use UEFI?
> 
> yes.Actually, there is an API for retrieving the memory map from UEFI
> at runtime, but it is difficult to call from within the kernel.
> Actually, my preference would be to not require GRUB or the Linux
> Loader to add the above properties at all and instead have the kernel
> proper retrieve the memory map directly. That would reduce the
> dependency on GRUB/LinuxLoader doing things correctly, but Leif knows
> better how feasible that would be.

It's completely feasible, but we'd need to use a different method to do
the boot services call with a 1:1 mapping (idmap support is not available
until much later in the boot process).

The System Table pointer still needs to be passed across though.

/
    Leif
