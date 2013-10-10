From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Thu, 10 Oct 2013 13:34:53 +0100
Message-ID: <20131010123453.GA12321@console-pimps.org>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131010080635.GA3692@dhcp-16-126.nay.redhat.com>
 <20131010081434.GB3692@dhcp-16-126.nay.redhat.com>
 <20131010085827.GA9929@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131010085827.GA9929-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Oct, at 10:58:28AM, Borislav Petkov wrote:
> On Thu, Oct 10, 2013 at 04:14:34PM +0800, Dave Young wrote:
> > Even though I still have no idea why kernel text overlap with efi boot
> > region, anyway map the un-overlapped part is necessary though.
> >
> > I can post the kexec related patches after your mapping patches settle
> > down
> 
> Right, "settle down" being the key here.
> 
> Matt just mentioned on IRC that we might not need boot services mappings
> by the time we have to start the kexec kernel, which would mean, you
> don't have to do anything in efi_reserve_boot_services().

Dave, apologies for not discussing the whole Boot Services thing sooner.
I missed your questions.

We really should not be passing the EFI Boot Service regions via the
memmap to kexec at all, because by the time the kexec'd kernel is
running those pages that previously contained Boot Service code/data
will have likely been reused for something else.

Which, to answer your question, is why the Boot Service regions overlap
the kernel text in the kexec'd kernel - those regions have been
reallocated by the first kernel and now happen to contain the kernel
text of the kexec kernel.

The reason that we don't keep the Boot Service regions around forever is
because they can take up a considerable amount of memory, so the current
situation of free'ing them after we're sure the firmware isn't going to
reference them is still the right way to go, and simply not including
any Boot Service entries in the memory map passed to kexec should make
everything work OK.

> The question which needs answering first though is, how the whole efi
> thing is going to handle any functionality like calling into efi boot
> regions from runtime functions and such. Which hasn't really been tested
> and fw vendors don't really want to support that. But this is all bits
> and pieces I heard yesterday so it is all pretty wet and I'll let efi
> guys, i.e. the Matts and a couple of others :-), figure out this whole
> issue.

We currently treat the scenario where Runtime Services reference Boot
Service regions as a bug and either work around it (where we do
efi_reserve_boot_services() and efi_free_boot_services() around
SetVirtualAddressMap()) or we avoid calling those services altogether.

The spec is pretty clear that runtime drivers shouldn't be doing this,
and so far this approach has served us well.

There are only two reasons why we keep the Boot Services regions around
(for a short period) at all,

  1) To work around the aforementioned runtime firmware bugs
  2) To copy a ACPI BGRT image into kernel memory

I'm not sure whether the kexec kernel would care about the BGRT?

-- 
Matt Fleming, Intel Open Source Technology Center
