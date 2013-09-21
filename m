From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 02/11] efi: Remove EFI_PAGE_SHIFT and EFI_PAGE_SIZE
Date: Sat, 21 Sep 2013 18:01:21 +0200
Message-ID: <20130921160121.GI2737@rocoto.smurfnet.nu>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-3-git-send-email-bp@alien8.de>
 <20130920104249.GA21381@console-pimps.org>
 <20130921152139.GG2737@rocoto.smurfnet.nu>
 <20130921154143.GC1587@pd.tnic>
 <20130921155039.GD1587@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130921155039.GD1587@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, Mark Salter <msalter@redhat.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>, linux-efi@vger.kernel.org, Roy Franz <roy.franz@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Sep 21, 2013 at 05:50:39PM +0200, Borislav Petkov wrote:
> > Ok, maybe the generic header include/linux/efi.h might be a problem but
> > the rest are changes to arch/x86/ which should have no effect whatsoever
> > on any other arch.
> > 
> > Or are you planning to move some of it into generic code?
> 
> Oh, and arm64 defines a respective PAGE_SIZE too, so what's the problem?
> Or is possibly EFI_PAGE_SIZE != PAGE_SIZE on arm64?
 
Correct. On arm64, EFI_PAGE_SIZE will be 4K, and PAGE_SIZE can be 4K
or 64K, with at least Fedora opting for 64K.

/
    Leif
