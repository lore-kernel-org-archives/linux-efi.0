From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: Setup separate EFI page tables in kexec paths
Date: Thu, 21 Jan 2016 20:58:15 +0000
Message-ID: <20160121205815.GI2510@codeblueprint.co.uk>
References: <1453385519-11477-1-git-send-email-matt@codeblueprint.co.uk>
 <20160121193332.GA17206@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160121193332.GA17206@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, Dave Young <dyoung@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Fri, 22 Jan, at 01:03:32AM, Srikar Dronamraju wrote:
> * Matt Fleming <matt@codeblueprint.co.uk> [2016-01-21 14:11:59]:
> 
> > The switch to using a new dedicated page table for EFI runtime calls
> > in commit commit 67a9108ed431 ("x86/efi: Build our own page table
> > structures") failed to take into account changes required for the
> > kexec code paths, which are unfortunately duplicated in the EFI code.
> > 
> > Call the allocation and setup functions in kexec_enter_virtual_mode()
> > just like we do for __efi_enter_virtual_mode() to avoid hitting
> > NULL-pointer dereferences when making EFI runtime calls.
> > 
> > At the very least, the call to efi_setup_page_tables() should have
> > existed for kexec before commit 67a9108ed431. Things just magically
> > worked because we were actually using the kernel's page tables that
> > contained the required mappings.
> > 
> > Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> > Cc: Dave Young <dyoung@redhat.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> 
> Applied this patch on top of tip/x86/efi and was able to build and boot
> the kernel.

Fantastic, thanks for testing!

Ingo, this commit should unblock the EFI changes for v4.5.
