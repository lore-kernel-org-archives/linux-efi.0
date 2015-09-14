From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub parameters
Date: Mon, 14 Sep 2015 11:09:25 +0200
Message-ID: <CAKv+Gu-xAAd=xTOh+qZvPDthgbRPLy=YwT4xfi4dS53EgJRh1Q@mail.gmail.com>
References: <20150910112418.GC29293@leverpostej>
	<alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
	<20150910121514.GE29293@leverpostej>
	<alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
	<20150910144938.GI29293@leverpostej>
	<alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
	<20150910162302.GN29293@leverpostej>
	<20150911124643.GB4530@olila.local.net-space.pl>
	<alpine.DEB.2.02.1509111410180.2672@kaball.uk.xensource.com>
	<CAKv+Gu9rN7_mxk0huX+34HSCC_aTWVTkUZKQMB1+9U56fRnwsA@mail.gmail.com>
	<20150911154534.GD4530@olila.local.net-space.pl>
	<55F6886D.1090900@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55F6886D.1090900@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Mark Rutland <mark.rutland@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "julien.grall@citrix.com" <julien.grall@citrix.com>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "jbeulich@suse.com" <jbeulich@suse.com>, peter.huan
List-Id: linux-efi@vger.kernel.org

On 14 September 2015 at 10:42, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
[..]

>
> It only needs to apply following patch to fix a bug in Linux kernel when
> mapping EFI_MEMORY_RUNTIME memory.
>

Could you explain why you think efi_virtmap_init() should fail if
there are no EFI_MEMORY_RUNTIME regions?

The absence of such regions is allowed by the spec, so
efi_virtmap_init() is correct imo to return success.

If you are trying to work around the issue where Xen does not expose
any Runtime Services regions, there is simply no way to do that and be
still UEFI compliant. I have suggested before that we should perhaps
tolerate this anyway, by considering the case where the EFI System
Table has a NULL runtime services pointer. But rigging
efi_virtmap_init() like this is really not the way to achieve that.

-- 
Ard.


> Author: Shannon Zhao <shannon.zhao@linaro.org>
> Date:   Thu Aug 20 14:54:58 2015 +0800
>
>     arm64/efi: Fix a bug when no EFI_MEMORY_RUNTIME memory found
>
>     Currently if the attribute type of all the EFI Memory Descriptors are
>     not EFI_MEMORY_RUNTIME, efi_virtmap_init will return true. But at this
>     case, it expect false as there are no EFI memory for RUNTIME. Fix it by
>     introducing a status to show whether it finds EFI_MEMORY_RUNTIME.
>
>     Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index e8ca6ea..bad7f87 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -233,6 +233,7 @@ void __init efi_init(void)
>  static bool __init efi_virtmap_init(void)
>  {
>         efi_memory_desc_t *md;
> +       bool status = false;
>
>         for_each_efi_memory_desc(&memmap, md) {
>                 u64 paddr, npages, size;
> @@ -264,8 +265,11 @@ static bool __init efi_virtmap_init(void)
>                         prot = PAGE_KERNEL;
>
>                 create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size,
> prot);
> +               status = true;
>         }
> -       return true;
> +       if (status)
> +               return true;
> +       return false;
>  }
>
> --
> Shannon
>
