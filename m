From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
Date: Mon, 19 May 2014 14:30:45 +0100
Message-ID: <537A23A50200007800013A7F@mail.emea.novell.com>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: david.vrabel@citrix.com, ian.campbell@citrix.com, stefano.stabellini@eu.citrix.com, jeremy@goop.org, matt.fleming@intel.com, x86@kernel.org, tglx@linutronix.de, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com, eshelton@pobox.com, mingo@redhat.com, mjg59@srcf.ucam.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
List-Id: linux-efi@vger.kernel.org

>>> On 16.05.14 at 22:41, <daniel.kiper@oracle.com> wrote:
> @@ -457,6 +460,21 @@ void __init efi_free_boot_services(void)
>  	efi_unmap_memmap();
>  }
>  
> +static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
> +							unsigned long size)
> +{
> +	if (efi_enabled(EFI_DIRECT))
> +		return early_ioremap(phys_addr, size);
> +
> +	return (__force void __iomem *)phys_addr;

Now that surely needs some explanation: I can't see how this can
ever be correct, Xen or not being completely irrelevant.

Jan
