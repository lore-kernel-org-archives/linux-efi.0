From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
Date: Mon, 10 Jun 2013 14:55:30 +0200
Message-ID: <20130610125530.GA11673@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-5-git-send-email-bp@alien8.de>
 <20130606131439.GI30420@console-pimps.org>
 <20130606132908.GE20972@pd.tnic>
 <20130606155822.GH20972@pd.tnic>
 <51B0E2D4.3040007@zytor.com>
 <20130606193612.GM20972@pd.tnic>
 <51B0E522.4070005@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51B0E522.4070005-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 06, 2013 at 12:38:10PM -0700, H. Peter Anvin wrote:
> On 06/06/2013 12:36 PM, Borislav Petkov wrote:
> > On Thu, Jun 06, 2013 at 12:28:20PM -0700, H. Peter Anvin wrote:
> >> Or we could materialize mappings for this specific PGD. However,
> >> adding a read of %cr3 in __do_page_fault sounds expensive.
> > 
> > Yes, I think we want to make sure all mappings are there when we do an
> > EFI runtime call so that we never #PF while it executes.
> > 
> > Matt mentioned on IRC that the it could be that his EFI runtime is
> > referencing EFI_RESERVED area which we don't map. However, we need to
> > confirm/disprove that first, as it is currently only a hunch.

FWIW,

booting the patchset on my Dell looks good here. Booting at least, I
don't know about other stuff. If you have an EFI test suite or want me
to try stuff out, let me know. efibootmgr output looks sane too.

Btw, I've added a printk to the code so that we know that we've managed
switching to the 1:1 thing:

[    0.073119] efi: Using 1:1 map.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
