From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v7 08/36] x86/mm: Add support to enable SME in early boot
 processing
Date: Wed, 21 Jun 2017 17:38:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1706211720060.2328@nanos>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net> <20170616185115.18967.79622.stgit@tlendack-t1.amdoffice.net> <alpine.DEB.2.20.1706202259290.2157@nanos> <8d3c215f-cdad-5554-6e9c-5598e1081850@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <8d3c215f-cdad-5554-6e9c-5598e1081850@amd.com>
Sender: owner-linux-mm@kvack.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, xen-devel@lists.xen.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Brijesh Singh <brijesh.singh@amd.com>, Toshimitsu Kani <toshi.kani@hpe.com>, =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Alexander Potapenko <glider@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Larry Woodman <lwoodman@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dave Young <dyoung@redhat.com>, Rik van Riel <riel@redhat.com>Arnd Bergmann <a>
List-Id: linux-efi@vger.kernel.org

On Wed, 21 Jun 2017, Tom Lendacky wrote:
> On 6/21/2017 2:16 AM, Thomas Gleixner wrote:
> > Why is this an unconditional function? Isn't the mask simply 0 when the MEM
> > ENCRYPT support is disabled?
> 
> I made it unconditional because of the call from head_64.S. I can't make
> use of the C level static inline function and since the mask is not a
> variable if CONFIG_AMD_MEM_ENCRYPT is not configured (#defined to 0) I
> can't reference the variable directly.
> 
> I could create a #define in head_64.S that changes this to load rax with
> the variable if CONFIG_AMD_MEM_ENCRYPT is configured or a zero if it's
> not or add a #ifdef at that point in the code directly. Thoughts on
> that?

See below.

> > That does not make any sense. Neither the call to sme_encrypt_kernel() nor
> > the following call to sme_get_me_mask().
> > 
> > __startup_64() is already C code, so why can't you simply call that from
> > __startup_64() in C and return the mask from there?
> 
> I was trying to keep it explicit as to what was happening, but I can
> move those calls into __startup_64().

That's much preferred. And the return value wants to be documented in both
C and ASM code.

> I'll still need the call to sme_get_me_mask() in the secondary_startup_64
> path, though (depending on your thoughts to the above response).

        call verify_cpu

        movq    $(init_top_pgt - __START_KERNEL_map), %rax

So if you make that:

	/*
	 * Sanitize CPU configuration and retrieve the modifier
	 * for the initial pgdir entry which will be programmed
	 * into CR3. Depends on enabled SME encryption, normally 0.
	 */
	call __startup_secondary_64

        addq    $(init_top_pgt - __START_KERNEL_map), %rax

You can hide that stuff in C-code nicely without adding any cruft to the
ASM code.

Thanks,

	tglx

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
