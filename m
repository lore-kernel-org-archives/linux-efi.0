From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part1 PATCH v3 06/17] x86/mm: Use encrypted access of boot
 related data with SEV
Date: Thu, 27 Jul 2017 15:31:25 +0200
Message-ID: <20170727133125.GB28553@nazgul.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-7-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724190757.11278-7-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 24, 2017 at 02:07:46PM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> When Secure Encrypted Virtualization (SEV) is active, boot data (such as
> EFI related data, setup data) is encrypted and needs to be accessed as
> such when mapped. Update the architecture override in early_memremap to
> keep the encryption attribute when mapping this data.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/mm/ioremap.c | 44 ++++++++++++++++++++++++++++++++------------
>  1 file changed, 32 insertions(+), 12 deletions(-)

...

> @@ -590,10 +598,15 @@ bool arch_memremap_can_ram_remap(resource_size_t phys_addr, unsigned long size,
>  	if (flags & MEMREMAP_DEC)
>  		return false;
>  
> -	if (memremap_is_setup_data(phys_addr, size) ||
> -	    memremap_is_efi_data(phys_addr, size) ||
> -	    memremap_should_map_decrypted(phys_addr, size))
> -		return false;
> +	if (sme_active()) {
> +		if (memremap_is_setup_data(phys_addr, size) ||
> +		    memremap_is_efi_data(phys_addr, size) ||
> +		    memremap_should_map_decrypted(phys_addr, size))
> +			return false;
> +	} else if (sev_active()) {
> +		if (memremap_should_map_decrypted(phys_addr, size))
> +			return false;
> +	}
>  
>  	return true;
>  }

I guess this function's hind part can be simplified to:

        if (sme_active()) {
                if (memremap_is_setup_data(phys_addr, size) ||
                    memremap_is_efi_data(phys_addr, size))
                        return false;
        }

        return ! memremap_should_map_decrypted(phys_addr, size);
}

> @@ -608,15 +621,22 @@ pgprot_t __init early_memremap_pgprot_adjust(resource_size_t phys_addr,
>  					     unsigned long size,
>  					     pgprot_t prot)

And this one in a similar manner...

>  {
> -	if (!sme_active())
> +	if (!sme_active() && !sev_active())
>  		return prot;

... and you don't need that check...

> -	if (early_memremap_is_setup_data(phys_addr, size) ||
> -	    memremap_is_efi_data(phys_addr, size) ||
> -	    memremap_should_map_decrypted(phys_addr, size))
> -		prot = pgprot_decrypted(prot);
> -	else
> -		prot = pgprot_encrypted(prot);
> +	if (sme_active()) {

... if you're going to do it here too.

> +		if (early_memremap_is_setup_data(phys_addr, size) ||
> +		    memremap_is_efi_data(phys_addr, size) ||
> +		    memremap_should_map_decrypted(phys_addr, size))
> +			prot = pgprot_decrypted(prot);
> +		else
> +			prot = pgprot_encrypted(prot);
> +	} else if (sev_active()) {

And here.

> +		if (memremap_should_map_decrypted(phys_addr, size))
> +			prot = pgprot_decrypted(prot);
> +		else
> +			prot = pgprot_encrypted(prot);
> +	}

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
