From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] x86/EFI: check table header length in efi_bgrt_init()
Date: Tue, 13 Nov 2012 16:33:42 -0800
Message-ID: <20121114003341.GA7858@jtriplet-mobl1>
References: <509A9E6002000078000A7079@nat28.tlf.novell.com>
 <1352837295.15747.72.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1352837295.15747.72.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 13, 2012 at 08:08:15PM +0000, Matt Fleming wrote:
> On Wed, 2012-11-07 at 16:46 +0000, Jan Beulich wrote:
> > Header length should be validated for all ACPI tables before accessing
> > any non-header field.
> > 
> > Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
> > 
> > ---
> >  arch/x86/platform/efi/efi-bgrt.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- 3.7-rc4/arch/x86/platform/efi/efi-bgrt.c
> > +++ 3.7-rc4-x86-EFI-BGRT-checks/arch/x86/platform/efi/efi-bgrt.c
> > @@ -39,6 +39,8 @@ void efi_bgrt_init(void)
> >  	if (ACPI_FAILURE(status))
> >  		return;
> >  
> > +	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
> > +		return;
> >  	if (bgrt_tab->version != 1)
> >  		return;
> >  	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
> 
> Guys, do you want me to take this into the efi tree? Jan, have you see
> machines that actually trip up without this check? I'm trying to gauge
> the urgency of this patch.

I'd expect this to either go through efi or through tip, whichever you
prefer.  If Jan has a system that would fail this check, then this patch
seems urgent; otherwise, it could potentially wait until the merge
window, but as a bugfix it doesn't necessarily need to.

- Josh Triplett
