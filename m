From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Fri, 21 Jun 2013 09:23:56 +0200
Message-ID: <20130621072356.GA22006@pd.tnic>
References: <1371746775.2372.11.camel@dabdike>
 <20130620165426.GB26214@srcf.ucam.org>
 <20130620170124.GA19877@pd.tnic>
 <20130620171210.GA26593@srcf.ucam.org>
 <20130620180808.GB19877@pd.tnic>
 <20130620181015.GA27833@srcf.ucam.org>
 <20130620181445.GA791@pd.tnic>
 <20130620181731.GA27960@srcf.ucam.org>
 <20130620184736.GC19877@pd.tnic>
 <51C383AC.4060706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51C383AC.4060706-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 20, 2013 at 03:35:24PM -0700, H. Peter Anvin wrote:
> On 06/20/2013 11:47 AM, Borislav Petkov wrote:
> > 
> > I guess we can do a top-down allocation, starting from the highest
> > virtual addresses:
> > 
> > EFI_HIGHEST_ADDRESS
> > |
> > | size1
> > |
> > --> region1
> > |
> > | size2
> > |
> > --> region2
> > 
> > ...
> > 
> > and we make EFI_HIGHEST_ADDRESS be the same absolute number on every
> > system.
> > 
> > hpa, is this close to what you had in mind? It would be prudent to
> > verify whether this will suit well with the kexec virtual space layout
> > though...
> > 
> 
> This would work really well, I think.  The tricky part here is to pick a
> safe EFI_HIGHEST_ADDRESS as it is an ABI.
> 
> My preference would be to make EFI_HIGHEST_ADDRESS = -4 GB, which is
> *not* what Windows uses, but will leave the high negative range clear,
> and allows a range where we can grow down without much risk of
> interfering with anything else.

Hmm, cool. Let me see whether my primitive math still has it:

-(4 << 30) = 0xffffffff00000000.

Staring at Documentation/x86/x86_64/mm.txt, that's right in the unused
hole, sandwiched between:

ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)

xxxxxxxxxxxxxxxx - ffffffff00000000 (=XX bits, not a lot :-), maybe 4, i.e. 64G) EFI

ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0

Now, if we go and do that, what are we going to say for the lower bound,
in case later someone wants to use some more of the rest of the unused
hole? Should we limit it to say

0xffffffff00000000 -
0xfffffff000000000 = 64G max EFI mappable region.

Or am I too generous? The remaining hole is around

(0xfffffff000000000 - 0xffffeaffffffffff) >> 40 = 20TB.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
