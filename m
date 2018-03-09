From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 06/12] x86: efi: Replace GFP_ATOMIC with GFP_KERNEL in
 efi_query_variable_store
Date: Fri, 9 Mar 2018 08:54:36 +0100
Message-ID: <20180309075436.tedbueuh3wuocr3p@gmail.com>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
 <20180308080020.22828-7-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180308080020.22828-7-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Jia-Ju Bai <baijiaju1990@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> The function kzalloc here is not called in atomic context.
> If nonblocking in efi_query_variable_store is true,
> namely it is in atomic context, efi_query_variable_store will return before
> this kzalloc is called.
> Thus GFP_ATOMIC is not necessary, and it can be replaced with GFP_KERNEL.
> 
> This is found by a static analysis tool named DCNS written by myself.

Please fix typos/spelling in changelogs when applying patches.

I improved the above to:

  efi_query_variable_store() does an atomic kzalloc() unnecessarily,
  because we can never get this far when called in an atomic context,
  namely when nonblocking == 1.

  Replace it with GFP_KERNEL.

  This was found by the DCNS static analysis tool written by myself.

Thanks,

	Ingo
