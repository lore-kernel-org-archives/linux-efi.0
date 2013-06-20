From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Thu, 20 Jun 2013 10:44:46 +0100
Message-ID: <20130620094446.GA17882@srcf.ucam.org>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130620091321.GB6811@gmail.com>
 <20130620091537.GA17159@srcf.ucam.org>
 <20130620092237.GA6943@gmail.com>
 <20130620093337.GI32694@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130620093337.GI32694@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>, Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 20, 2013 at 11:33:37AM +0200, Borislav Petkov wrote:
> This will break the Macs so maybe we can do
> 
> efi=no_11_map
> 
> so the Macs can still boot but use the 1:1 map by default.

I'm going to guess that there are more people running unmodified Linux 
kernels on Macs than there are people using kexec, so just pass the high 
maps by default and let the enterprise kernels that care about kexec do 
something different.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
