From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/6] x86/mm/pageattr: Ensure cpa->pfn only contains page
 frame numbers
Date: Thu, 12 Nov 2015 19:47:37 +0100
Message-ID: <20151112184737.GJ3838@pd.tnic>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-2-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447342823-3612-2-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 12, 2015 at 03:40:18PM +0000, Matt Fleming wrote:
> The x86 pageattr code is confused about the data that is stored
> cpa->pfn, sometimes it's treated as a page fram number and sometimes
> it's treated as an unshifted physical address.
> 
> The result of this is that the mapping functions do not map the
> intended physical address.
> 
> This isn't a problem in practice because most of the addresses we're
> mapping in the EFI code paths are already mapped in 'trampoline_pgd'
> and so the pageattr mappings functions don't actually do anything in
> this case. But when we move to using a separate page table for the EFI
> runtime this will be an issue.
> 
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> ---
>  arch/x86/mm/pageattr.c         | 12 ++++++------
>  arch/x86/platform/efi/efi_64.c | 33 ++++++++++++++++++++++-----------
>  2 files changed, 28 insertions(+), 17 deletions(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
