From: Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH v4 05/28] x86: Add Secure Memory Encryption (SME)
 support
Date: Sat, 25 Feb 2017 16:29:31 +0100
Message-ID: <20170225152931.p4lws753myepkkb3@pd.tnic>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
 <20170216154307.19244.72895.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170216154307.19244.72895.stgit@tlendack-t1.amdoffice.net>
Sender: owner-linux-mm@kvack.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Alexander Potapenko <glider@google.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 16, 2017 at 09:43:07AM -0600, Tom Lendacky wrote:
> Add support for Secure Memory Encryption (SME). This initial support
> provides a Kconfig entry to build the SME support into the kernel and
> defines the memory encryption mask that will be used in subsequent
> patches to mark pages as encrypted.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

...

> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -0,0 +1,42 @@
> +/*
> + * AMD Memory Encryption Support
> + *
> + * Copyright (C) 2016 Advanced Micro Devices, Inc.
> + *
> + * Author: Tom Lendacky <thomas.lendacky@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __X86_MEM_ENCRYPT_H__
> +#define __X86_MEM_ENCRYPT_H__
> +
> +#ifndef __ASSEMBLY__
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +
> +extern unsigned long sme_me_mask;
> +
> +static inline bool sme_active(void)
> +{
> +	return (sme_me_mask) ? true : false;

	return !!sme_me_mask;

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
