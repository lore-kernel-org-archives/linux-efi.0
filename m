From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] EFI changes for v5.1
Date: Tue, 5 Mar 2019 13:37:25 +0100
Message-ID: <20190305123725.GA42141@gmail.com>
References: <20190305122038.GA2472@gmail.com>
 <CAKv+Gu_P-tmM-tFCDuxy+6mE-tGUUbcFoCUbJMAsitMk5Ahstw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_P-tmM-tFCDuxy+6mE-tGUUbcFoCUbJMAsitMk5Ahstw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Hi ingo,
> 
> On Tue, 5 Mar 2019 at 13:20, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Linus,
> >
> > Please pull the latest efi-core-for-linus git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus
> >
> >    # HEAD: 5c418dc789a3898717ebf2caa5716ba91a7150b2 efi: Fix build error due to enum collision between efi.h and ima.h
> >
> > The main EFI changes in this cycle were:
> >
> >  - Move BGRT table handling to earlier in the boot so we don't overwrite it
> 
> This one actually got reverted because it broke x86. I haven't heard 
> back from the Intel engineers that reported the issue, so i will 
> revisit this at a later date.

Indeed, and I applied the revert and then promptly forgot about it...

So the real changelog is:

 - Use 32-bit alignment for efi_guid_t
 - Allow the SetVirtualAddressMap() call to be omitted
 - Implement earlycon=efifb based on existing earlyprintk code
 - Various minor fixes and code cleanups from Sai, Ard and me

Sorry and thanks,

	Ingo
