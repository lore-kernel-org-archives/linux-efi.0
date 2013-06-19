From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Wed, 19 Jun 2013 18:38:04 +0200
Message-ID: <20130619163804.GG28300@pd.tnic>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130619161827.GF28300@pd.tnic>
 <20130619162115.GA28119@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130619162115.GA28119@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>, Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 19, 2013 at 05:21:15PM +0100, Matthew Garrett wrote:
> Yes, kexec needs a different solution.

No need. If we say, "efi=use_11_map", the 1:1 map will be shoved down
SetVirtualAddressMap. Otherwise the high mappings.

> Because firmware images don't always update all of the pointers, and
> so will crash if the 1:1 mappings aren't present.

Ok, so it sounds like we want to *always* create both mappings but,
depending on what we want, to shove down SetVirtualAddressMap a
different set. And the 1:1 map will be the optional one which we give
SetVirtualAddressMap only when user wants it, i.e. when booting with
"efi=1:1_map".

Makes sense?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
