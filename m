From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 02/10] x86/efi: Return error status if mapping EFI
 regions fail
Date: Mon, 4 Feb 2019 08:25:14 +0100
Message-ID: <20190204072514.GB115714@gmail.com>
References: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
 <20190202094119.13230-3-ard.biesheuvel@linaro.org>
 <20190204071809.GA115714@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190204071809.GA115714@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Note that I also fixed up the grammar and readability of the changelog - 
> see the updated version below.
> 
> Thanks,
> 
> 	Ingo
> 
> =============>
> Subject: x86/efi: Return error status if mapping of EFI regions fails
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Date: Sat, 2 Feb 2019 10:41:11 +0100
> 
> From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>

Also note that I left out this patch from the series for the time being 
under the assumption that it gets a v2 update. Since it has no 
dependencies in the remaining patches AFAICS I applied all the other 
patches to tip:efi/core.

Thanks,

	Ingo
