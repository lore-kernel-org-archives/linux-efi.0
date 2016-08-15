From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] x86/efi-bgrt: remove the check of the version field
Date: Mon, 15 Aug 2016 09:09:49 -0700
Message-ID: <20160815160949.b6sccopomrn54c76@x>
References: <20160809052546.31462-1-icenowy@aosc.xyz>
 <20160815125643.GG30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160815125643.GG30909@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Icenowy Zheng <icenowy@aosc.xyz>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Young <dyoung@redhat.com>, Josh Boyer <jwboyer@redhat.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 15, 2016 at 01:56:43PM +0100, Matt Fleming wrote:
> On Tue, 09 Aug, at 01:25:46PM, Icenowy Zheng wrote:
> > Some broken firmwares have a wrongly filled version field in BGRT table.
> > (See http://wiki.osdev.org/Broken_UEFI_implementations )
> > 
> > As we know, these firmwares can also provide correct BGRT image, although
> > the table is wrong.
> > 
> > After removing the check of the version field, the kernel can now extract
> > the image correctly, and the information is also correct.
> > 
> > Tested on a Thinkpad E531 (68854UC).
> > 
> > Signed-off-by: Icenowy Zheng <icenowy@aosc.xyz>
> > ---
> >  arch/x86/platform/efi/efi-bgrt.c | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> > index 6a2f569..f492ea0 100644
> > --- a/arch/x86/platform/efi/efi-bgrt.c
> > +++ b/arch/x86/platform/efi/efi-bgrt.c
> > @@ -47,11 +47,6 @@ void __init efi_bgrt_init(void)
> >  		       bgrt_tab->header.length, sizeof(*bgrt_tab));
> >  		return;
> >  	}
> > -	if (bgrt_tab->version != 1) {
> > -		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
> > -		       bgrt_tab->version);
> > -		return;
> > -	}
> >  	if (bgrt_tab->status & 0xfe) {
> >  		pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
> >  		       bgrt_tab->status);
> 
> This would be less scary if we checked for known broken and known good
> version values instead of removing the check altogether, i.e. 0 and 1.
> 
> The whole point of the version field is that it tells us about the
> layout of the BGRT table, so it's not exactly a useless check.

Agreed.  It seems likely that BIOSes would have incorrectly left the
version at 0.  It seems less likely that they'd set it to some other
random value.

So, I'd suggest changing the check to pr_debug and continue for 0,
continue for 1, and pr_notice and abort for anything else.
