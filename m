From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.9 39/92] efi/arm: Revert deferred unmap of early memmap
 mapping
Date: Thu, 29 Nov 2018 16:02:21 +0100
Message-ID: <20181129150221.GB22451@kroah.com>
References: <20181129140106.520639693@linuxfoundation.org>
 <20181129140109.438834361@linuxfoundation.org>
 <CAKv+Gu8cPOQaYY_KH3dq+2U517z7j67Od+Cxe+wB4gkEOqnQTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8cPOQaYY_KH3dq+2U517z7j67Od+Cxe+wB4gkEOqnQTA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, sashal@kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 29, 2018 at 03:28:44PM +0100, Ard Biesheuvel wrote:
> On Thu, 29 Nov 2018 at 15:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 4.9-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > [ Upstream commit 33412b8673135b18ea42beb7f5117ed0091798b6 ]
> >
> > Commit:
> >
> >   3ea86495aef2 ("efi/arm: preserve early mapping of UEFI memory map longer for BGRT")
> >
> > deferred the unmap of the early mapping of the UEFI memory map to
> > accommodate the ACPI BGRT code, which looks up the memory type that
> > backs the BGRT table to validate it against the requirements of the UEFI spec.
> >
> > Unfortunately, this causes problems on ARM, which does not permit
> > early mappings to persist after paging_init() is called, resulting
> > in a WARN() splat. Since we don't support the BGRT table on ARM anway,
> > let's revert ARM to the old behaviour, which is to take down the
> > early mapping at the end of efi_init().
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: linux-efi@vger.kernel.org
> > Fixes: 3ea86495aef2 ("efi/arm: preserve early mapping of UEFI memory ...")
> 
> This commit is only in v4.19 as far as I know. Does it even apply?

This commit is in the following releases:
	4.9.129 4.14.72 4.18.10 4.19

so it should apply :)

thanks,

greg k-h
