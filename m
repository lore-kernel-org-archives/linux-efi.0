From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 08/13] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Tue, 17 Nov 2015 11:37:01 +0000
Message-ID: <20151117113701.GE12586@leverpostej>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
 <1447754231-7772-9-git-send-email-shannon.zhao@linaro.org>
 <CAKv+Gu98L_dQYVhvGQG=d9Uga-x3mJ=4oxtQqvgU-D3DvcrwHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu98L_dQYVhvGQG=d9Uga-x3mJ=4oxtQqvgU-D3DvcrwHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ian Campbell <ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Julien Grall <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hangaohuai <hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 17, 2015 at 12:25:58PM +0100, Ard Biesheuvel wrote:
> On 17 November 2015 at 10:57,  <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >
> > Add a new function to parse DT parameters for Xen specific UEFI just
> > like the way for normal UEFI. Then it could reuse the existing codes.
> >
> > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/firmware/efi/efi.c | 67 ++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 62 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > index d6144e3..629bd06 100644
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/of_fdt.h>
> >  #include <linux/io.h>
> >  #include <linux/platform_device.h>
> > +#include <xen/xen.h>
> >
> >  struct efi __read_mostly efi = {
> >         .mps        = EFI_INVALID_TABLE_ADDR,
> > @@ -488,12 +489,60 @@ static __initdata struct {
> >         UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
> >  };
> >
> > +static __initdata struct {
> > +       const char name[32];
> > +       const char propname[32];
> > +       int offset;
> > +       int size;
> > +} xen_dt_params[] = {
> > +       UEFI_PARAM("System Table", "xen,uefi-system-table", system_table),
> > +       UEFI_PARAM("MemMap Address", "xen,uefi-mmap-start", mmap),
> > +       UEFI_PARAM("MemMap Size", "xen,uefi-mmap-size", mmap_size),
> > +       UEFI_PARAM("MemMap Desc. Size", "xen,uefi-mmap-desc-size", desc_size),
> > +       UEFI_PARAM("MemMap Desc. Version", "xen,uefi-mmap-desc-ver", desc_ver)
> > +};
> > +
> 
> We discussed (and agreed afair) that dropping the "linux," prefix from
> the DT properties was an acceptable change. If we do that, and reuse
> the same names in the xen version (i.e., drop the "xen," prefix), we
> could make this change a *lot* simpler.

Regardless of if we drop the "linux," prefix from the existing strings,
I think we need the "xen," prefix here.

The xen EFI interface comes with additional caveats, and we need to
treat it separately.

Unless you're suggesting that /hypervisor/uefi-* is handled differently
to /chosen/uefi-*?

I think I'd still prefer the "xen," prefix regardless.

Thanks,
Mark.
