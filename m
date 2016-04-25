From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 4/6] arm64: mm: dump: make page table dumping reusable
Date: Mon, 25 Apr 2016 12:07:57 +0100
Message-ID: <20160425110757.GI16065@arm.com>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
 <1461343688-8552-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461343688-8552-5-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Ard, Mark,

On Fri, Apr 22, 2016 at 06:48:06PM +0200, Ard Biesheuvel wrote:
> From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> 
> For debugging purposes, it would be nice if we could export page tables
> other than the swapper_pg_dir to userspace. To enable this, this patch
> refactors the arm64 page table dumping code such that multiple tables
> may be registered with the framework, and exported under debugfs.
> 
> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/include/asm/ptdump.h | 44 ++++++++++++++++++++
>  arch/arm64/mm/dump.c            | 32 ++++++++------
>  2 files changed, 64 insertions(+), 12 deletions(-)

Could you reorder this with patch 3, please? I'm unsure about the benefit
of the very specific string literal changes, but the ptdump stuff here
certainly looks beneficial.

I can queue the first two patches as-is.

Thanks.

Will
