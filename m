From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi Fix regression in efi_arch_mem_reserve
Date: Wed, 21 Dec 2016 22:30:54 +0000
Message-ID: <20161221223054.GG2225@codeblueprint.co.uk>
References: <20161221131138.10512-1-poros@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161221131138.10512-1-poros@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Oros <poros@redhat.com>
Cc: ard.biesheuvel@linaro.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 21 Dec, at 02:11:38PM, Petr Oros wrote:
>   Booting on EFI with ESRT table has been stop since commit:
>     8e80632 efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()
> 
>   This is caused by this commit:
>     816e761 efi: Allow drivers to reserve boot services forever
> 
>   Problem is, that efi_memmap_insert need memory aligned
>   on EFI_PAGE_SIZE. If memory not aligned, efi_memmap_insert
>   just return and let efi.memmap in inconsistent state.
>   This breaking boot.
> 
>   Tested in my machine, which stop booting
>   after upgrade to 4.9
> 
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  arch/x86/platform/efi/quirks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Could you provide some more information? Why does efi_memmap_insert()
require this alignment? How does booting "break"? If you see an Oops,
please post it here.
