From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH V2] x86/efi: fix kernel param add_efi_memmap regression
Date: Mon, 18 Dec 2017 14:23:50 +0000
Message-ID: <20171218142350.GC3891@codeblueprint.co.uk>
References: <20171216041953.GA1690@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171216041953.GA1690@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: mingo@kernel.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, 16 Dec, at 12:19:53PM, Dave Young wrote:
> 'add_efi_memmap' is an early param, but do_add_efi_memmap() has no
> chance to run because the code path is before parse_early_param().
> I believe it worked when the param was introduced but probably later
> some other changes caused the wrong order and nobody noticed it.
> 
> Move efi_memblock_x86_reserve_range() after parse_early_param()
> to fix it.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/kernel/setup.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Thanks Dave, applied to 'urgent'.
