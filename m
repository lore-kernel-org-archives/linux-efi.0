From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v2 00/13] EFI mixed mode
Date: Thu, 6 Mar 2014 21:40:14 +0000
Message-ID: <20140306214014.GA8942@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
 <alpine.DEB.2.02.1403061325250.25499@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403061325250.25499@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 06 Mar, at 01:27:23PM, David Rientjes wrote:
> 
> This was merged into tip#x86/efi-mixed and results in a build error, 
> config attached:
> 
> arch/x86/boot/tools/build.c: In function 'update_pecoff_setup_and_reloc':
> arch/x86/boot/tools/build.c:259:1: error: parameter name omitted
> arch/x86/boot/tools/build.c: In function 'update_pecoff_text':
> arch/x86/boot/tools/build.c:260:1: error: parameter name omitted
> arch/x86/boot/tools/build.c:260:1: error: parameter name omitted
> arch/x86/boot/tools/build.c: In function 'main':
> arch/x86/boot/tools/build.c:380:2: warning: implicit declaration of function 'efi_stub_entry_update' [-Wimplicit-function-declaration]
> arch/x86/boot/compressed/head_64.o: In function `efi64_config':
> (.data+0x90): undefined reference to `efi_call6'

Thanks for the report David.

I sent a pull request that fixes these errors up. Looks like it got
pulled into tip:x86/efi,

commit 617b3c37da78
Merge: 994448f1afa6 3db4cafdfd05
Author: Matt Fleming <matt.fleming@intel.com>
Date:   Wed Mar 5 18:18:50 2014 +0000

    Merge branch 'mixed-mode' into efi-for-mingo

So everything should be working in tip:x86/efi which includes
tip:x86/efi-mixed.

-- 
Matt Fleming, Intel Open Source Technology Center
