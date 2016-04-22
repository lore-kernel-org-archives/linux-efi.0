From: Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v11 15/17] ARM64: XEN: Add a function to initialize Xen
 specific UEFI runtime services
Date: Fri, 22 Apr 2016 12:57:41 +0100 (BST)
Message-ID: <alpine.DEB.2.10.1604221257150.6744@sstabellini-ThinkPad-X260>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com> <1460030614-16112-16-git-send-email-zhaoshenglong@huawei.com> <20160422105427.GG2998@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160422105427.GG2998-M2fw3Uu6cmfZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 22 Apr 2016, Catalin Marinas wrote:
> On Thu, Apr 07, 2016 at 08:03:32PM +0800, Shannon Zhao wrote:
> > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > 
> > When running on Xen hypervisor, runtime services are supported through
> > hypercall. Add a Xen specific function to initialize runtime services.
> > 
> > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
> > ---
> >  arch/arm/include/asm/xen/xen-ops.h   |  6 ++++++
> >  arch/arm/xen/Makefile                |  1 +
> >  arch/arm/xen/efi.c                   | 40 ++++++++++++++++++++++++++++++++++++
> >  arch/arm64/include/asm/xen/xen-ops.h |  6 ++++++
> >  arch/arm64/xen/Makefile              |  1 +
> >  drivers/xen/Kconfig                  |  2 +-
> >  6 files changed, 55 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm/include/asm/xen/xen-ops.h
> >  create mode 100644 arch/arm/xen/efi.c
> >  create mode 100644 arch/arm64/include/asm/xen/xen-ops.h
> 
> This looks like entirely Xen code, so I don't think it needs arm64
> maintainers' approval. FWIW:
> 
> Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>

Thanks Catalin, I'll go ahead and queue the series up for 4.7.

Cheers,

Stefano
