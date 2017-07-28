From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part1 PATCH v3 09/17] resource: Consolidate resource
 walking code
Date: Fri, 28 Jul 2017 17:23:42 +0200
Message-ID: <20170728152342.GB11564@nazgul.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-10-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724190757.11278-10-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 24, 2017 at 02:07:49PM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> The walk_iomem_res_desc(), walk_system_ram_res() and walk_system_ram_range()
> functions each have much of the same code.  Create a new function that
> consolidates the common code from these functions in one place to reduce
> the amount of duplicated code.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  kernel/resource.c | 53 ++++++++++++++++++++++++++---------------------------
>  1 file changed, 26 insertions(+), 27 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 9b5f044..7b20b3e 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -397,9 +397,30 @@ static int find_next_iomem_res(struct resource *res, unsigned long desc,
>  		res->start = p->start;
>  	if (res->end > p->end)
>  		res->end = p->end;
> +	res->desc = p->desc;
>  	return 0;

I must be going blind: where are we using that res->desc?

> +static int __walk_iomem_res_desc(struct resource *res, unsigned long desc,
> +				 bool first_level_children_only,

Btw, that variable name is insanely long.

The rest looks ok to me, thanks for the cleanup!

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
