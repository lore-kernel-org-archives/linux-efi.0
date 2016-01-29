From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/mm/pageattr: Use _PAGE_GLOBAL bit for EFI page table
 mappings
Date: Fri, 29 Jan 2016 16:25:29 +0000
Message-ID: <20160129162529.GE2611@codeblueprint.co.uk>
References: <1453919696-13096-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453919696-13096-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Wed, 27 Jan, at 10:34:56AM, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> Since EFI page tables can be treated as kernel page tables they should
> be global. All the other page mapping functions in pageattr.c set the
> _PAGE_GLOBAL bit and we want to avoid inconsistencies when we map a page
> in the EFI code paths, for example when that page is split in
> __split_large_page(), etc. It also makes it easier to validate that the
> EFI region mappings have the correct attributes because there are fewer
> differences compared with regular kernel mappings.
> 
> Cc: Ricardo Neri <ricardo.neri@intel.com>
> Cc: Ravi Shankar <ravi.v.shankar@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> ---
>  arch/x86/mm/pageattr.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Reducing any differences between the EFI mapping and regular kernel
mapping code in pageattr.c is a plus.

Thanks Sai, applied.
