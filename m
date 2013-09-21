From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 02/11] efi: Remove EFI_PAGE_SHIFT and EFI_PAGE_SIZE
Date: Sat, 21 Sep 2013 17:41:43 +0200
Message-ID: <20130921154143.GC1587@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-3-git-send-email-bp@alien8.de>
 <20130920104249.GA21381@console-pimps.org>
 <20130921152139.GG2737@rocoto.smurfnet.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130921152139.GG2737@rocoto.smurfnet.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Matt Fleming <matt@console-pimps.org>, Mark Salter <msalter@redhat.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>, linux-efi@vger.kernel.org, Roy Franz <roy.franz@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Sep 21, 2013 at 05:21:39PM +0200, Leif Lindholm wrote:

> It will probably not be a problem on the stub side, and it's not used
> in many places but it would break efi_lookup_mapped_address(),
> efi_range_is_wc() and memrange_efi_to_native() for use by arm64.
> At least the first of these would be a problem.

Ok, maybe the generic header include/linux/efi.h might be a problem but
the rest are changes to arch/x86/ which should have no effect whatsoever
on any other arch.

Or are you planning to move some of it into generic code?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
