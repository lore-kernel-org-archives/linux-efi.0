From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/mm/pageattr: Don't implicitly allow _PAGE_RW in
 kernel_map_pages_in_pgd()
Date: Thu, 11 Feb 2016 14:40:38 +0000
Message-ID: <20160211144038.GE4134@codeblueprint.co.uk>
References: <1454115880-6914-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1454115880-6914-2-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454115880-6914-2-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 29 Jan, at 05:04:39PM, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> As part of the preparation for the EFI_MEMORY_RO flag added in the UEFI
> 2.5 specification, we need the ability to map pages in kernel page
> tables without _PAGE_RW being set.
> 
> Modify kernel_map_pages_in_pgd() to require its callers to pass _PAGE_RW
> if the pages need to be mapped read/write. Otherwise, we'll map the
> pages as read-only.
> 
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/mm/pageattr.c         | 3 +++
>  arch/x86/platform/efi/efi_64.c | 8 ++++----
>  2 files changed, 7 insertions(+), 4 deletions(-)

Thanks Sai, applied.
