From: Firo Yang <firogm@gmail.com>
Subject: Re: [PATCH] x86/efi: fix potential NULL pointer dereference
Date: Sat, 25 Apr 2015 15:15:47 +0800
Message-ID: <20150425071547.GA12818@firo>
References: <1429855639-14706-1-git-send-email-firogm@gmail.com>
 <1429889609.2182.25.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429889609.2182.25.camel@HansenPartnership.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 24, 2015 at 08:33:29AM -0700, James Bottomley wrote:
<On Fri, 2015-04-24 at 14:07 +0800, Firo Yang wrote:
<> In this patch, I add error-handing code for kmalloc() in
<> arch/x86/platform/efi/efi_64.c::efi_call_phys_prolog().
<> 
<> If kmalloc() failed to alloc memroy, save_pgd will be a NULL
<> pointer dereferenced by subsequent codes.
<> 
<> Signed-off-by: Firo Yang <firogm@gmail.com>
<> ---
<>  arch/x86/platform/efi/efi_64.c | 2 ++
<>  1 file changed, 2 insertions(+)
<> 
<> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
<> index a0ac0f9..62326c4 100644
<> --- a/arch/x86/platform/efi/efi_64.c
<> +++ b/arch/x86/platform/efi/efi_64.c
<> @@ -90,6 +90,8 @@ pgd_t * __init efi_call_phys_prolog(void)
<>  
<>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
<>  	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
<> +	if (unlikely(!save_pgd))
<> +		return NULL;
<>  
<>  	for (pgd = 0; pgd < n_pgds; pgd++) {
<>  		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
<
<First explain what you're trying to achieve?  I'm asking because the
<code you've introduced is actively harmful: the return from
<efi_call_phys_prolog() isn't checked for errors, so the error you return
<won't be handled and we'll likely trigger a much harder to detect error
<if the allocation you're checking fails.  Effectively the prolog/epilog
<do nothing and we never restore the pgds we hijacked, yet the system
<continues on with the memory map in an unexpected state.
<
<In my opinion the NULL deref we get further down in the prolog code is
<actually a far better indicator of failure than what you're proposing.
<
<James
<
I feel sorry for introducing this problematic and harmful patch.
I will do more checks and tests before submitting patch next time.

The deep reason is that I did not fully understand these code and
add the error-handing code roughly.

Regards
Firo
