From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v7 11/17] ARM: XEN: Move xen_early_init() before
 efi_init()
Date: Tue, 29 Mar 2016 17:07:57 +0100
Message-ID: <20160329160756.GG6745@arm.com>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
 <1458830676-27075-12-git-send-email-shannon.zhao@linaro.org>
 <alpine.DEB.2.02.1603261252510.18380@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1603261252510.18380@kaball.uk.xensource.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, julien.grall@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, zhaoshenglong@huawei.com, shannon.zhao@linaro.org
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 26, 2016 at 12:54:09PM +0000, Stefano Stabellini wrote:
> are you OK with this patch?

Nothing against it, but the only arm64 bit is:

> > diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> > index 450987d..6cf5051 100644
> > --- a/arch/arm64/kernel/setup.c
> > +++ b/arch/arm64/kernel/setup.c
> > @@ -313,6 +313,7 @@ void __init setup_arch(char **cmdline_p)
> >  	 */
> >  	local_async_enable();
> >  
> > +	xen_early_init();
> >  	efi_init();
> >  	arm64_memblock_init();
> >  
> > @@ -334,7 +335,6 @@ void __init setup_arch(char **cmdline_p)
> >  	} else {
> >  		psci_acpi_init();
> >  	}
> > -	xen_early_init();

so it's difficult to care too much ;) I do hope that there won't be a
need to split up efi_init() in future because some of it has to happen
before xen_early_init, but that doesn't sound likely at the moment.

Will
