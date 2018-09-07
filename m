From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V4 3/3] x86/efi: Introduce EFI_PAGE_FAULT_HANDLER
Date: Fri, 7 Sep 2018 13:22:07 +0200
Message-ID: <20180907112207.GS24106@hirez.programming.kicks-ass.net>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536276468-28499-4-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536276468-28499-4-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, ricardo.neri@intel.com, matt@codeblueprint.co.uk, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 06, 2018 at 04:27:48PM -0700, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> There may exist some buggy UEFI firmware implementations that might
> access efi regions other than EFI_RUNTIME_SERVICES_<CODE/DATA> even
> after the kernel has assumed control of the platform. This violates UEFI
> specification.
> 
> If selected, this debug option will print a warning message if the UEFI
> firmware tries to access any memory region which it shouldn't. Along
> with the warning, the efi page fault handler will also try to recover
> from the page fault triggered by the firmware so that the machine
> doesn't hang.

Why make this optional?
