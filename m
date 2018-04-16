From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: Re: [PATCH v2] x86/xen/efi: Initialize UEFI secure boot state during
 dom0 boot
Date: Mon, 16 Apr 2018 11:04:52 +0200
Message-ID: <20180416090452.GQ26100@olila.local.net-space.pl>
References: <1522766345-4169-1-git-send-email-daniel.kiper@oracle.com>
 <1522770281.4522.14.camel@HansenPartnership.com>
 <20180403160712.GL26100@olila.local.net-space.pl>
 <1522774852.4522.25.camel@HansenPartnership.com>
 <20180404103824.GM26100@olila.local.net-space.pl>
 <20180411085620.GI26100@olila.local.net-space.pl>
 <CAKv+Gu_1ydqYS+TBgYVEH9jTDEjSecBYxJbq_28mZJ9G3-T8EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_1ydqYS+TBgYVEH9jTDEjSecBYxJbq_28mZJ9G3-T8EA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, eric.snowberg@oracle.com, "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <jgross@suse.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 16, 2018 at 10:15:15AM +0200, Ard Biesheuvel wrote:
> On 11 April 2018 at 10:56, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > On Wed, Apr 04, 2018 at 12:38:24PM +0200, Daniel Kiper wrote:
> >> On Tue, Apr 03, 2018 at 10:00:52AM -0700, James Bottomley wrote:
> >> > On Tue, 2018-04-03 at 18:07 +0200, Daniel Kiper wrote:
> >> > > On Tue, Apr 03, 2018 at 08:44:41AM -0700, James Bottomley wrote:
> >>
> >> [...]
> >>
> >> > > > This looks like a bad idea: you're duplicating the secure boot
> >> > > > check in
> >> > > >
> >> > > > drivers/firmware/efi/libstub/secureboot.c
> >> > > >
> >> > > > Which is an implementation of policy.  If we have to have policy in
> >> > > > the kernel, it should really only be in one place to prevent drift;
> >> > > > why can't you simply use the libstub efi_get_secureboot() so we're
> >> > > > not duplicating the implementation of policy?
> >> > >
> >> > > Well, here is the first version of this patch:
> >> > > https://lkml.org/lkml/2018/1/9/496 Ard did not like it. I was not
> >> > > happy too. In general both approaches are not perfect. More you can
> >> > > find in the discussion around this patchset. If you have better idea
> >> > > how to do that I am happy to implement it.
> >> >
> >> > One way might be simply to have the pre exit-boot-services code lay
> >> > down a variable containing the state which you pick up, rather than you
> >>
> >> Do you mean variable in kernel proper or something like that? If yes this
> >> is not possible. EFI Linux stub is not executed in Xen dom0. All UEFI
> >> infrastructure is owned and operated by Xen. Dom0 kernel can access some
> >> stuff in UEFI, including variables, via hypercall. However, when dom0
> >> runs only UEFI runtime services are available.
> >>
> >> > calling efi code separately and trying to use the insecure RT
> >>
> >> I am not sure why they are insecure.
> >>
> >> > variables.  That way there's a uniform view of the internal kernel
> >> > secure boot state that everyone can use.
> >>
> >> That would be perfect but I have a feeling that in form proposed above
> >> it is not possible.
> >
> > Ping?
> >
>
> (apologies if this is a duplicate email - I thought I had replied
> already but I don't see it in my sent folder)
>
> Queued in efi/next - thanks.

Thanks a lot!

Daniel
