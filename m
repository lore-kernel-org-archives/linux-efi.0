From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 12/17] efi: fix efi_pci_io_protocol32 prototype for mixed
 mode
Date: Mon, 14 May 2018 08:57:44 +0200
Message-ID: <20180514065744.GD16596@gmail.com>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
 <20180504060003.19618-13-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180504060003.19618-13-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Mixed mode allows a kernel built for x86_64 to interact with 32-bit
> EFI firmware, but requires us to define all struct definitions carefully
> when it comes to pointer sizes. efi_pci_io_protocol32 currently uses a
> void* for the 'romimage' field, which will be interpreted as a 64-bit
> field on such kernels, potentially resulting in bogus memory references
> and subsequent crashes.

Yeah, so the first confusion I ran into is:

 s/efi_pci_io_protocol32
  /efi_pci_io_protocol_32

Once I found it in the code I made this change:

 s/efi: fix efi_pci_io_protocol32 prototype for mixed mode
  /efi: Fix 'struct efi_pci_io_protocol32' definition for mixed mode

Because we normally use the 'prototype' name for function declarations, not for 
data type definitions. Adding 'struct' and putting it between quotes makes it 
obvious at a glance that we are talking about a structure definition here.

BTW., since it's marked -stable, due to:

 > potentially resulting in bogus memory references
 > and subsequent crashes.

I'm moving it to efi/urgent: the principle here is that if a patch is urgent 
enough for -stable then it should generally not wait for the next merge window.

Also, because this actually fixes a crash, I extended the title to spell this out 
more clearly:

  Subject: efi: Avoid potential crashes, fix the 'struct efi_pci_io_protocol_32' definition for mixed mode

... which also makes it easier for maintainers of older stable kernels to decide 
whether to backport the patch or not.

Anyway, the patch is looking good otherwise, no need to resend.

Thanks,

	Ingo
