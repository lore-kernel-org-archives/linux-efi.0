From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v10 37/38] compiler-gcc.h: Introduce __nostackp function
 attribute
Date: Tue, 18 Jul 2017 11:36:31 +0200
Message-ID: <20170718093631.pnamvdrkmzcjz64j@gmail.com>
References: <cover.1500319216.git.thomas.lendacky@amd.com>
 <0576fd5c74440ad0250f16ac6609ecf587812456.1500319216.git.thomas.lendacky@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0576fd5c74440ad0250f16ac6609ecf587812456.1500319216.git.thomas.lendacky@amd.com>
Sender: linux-doc-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, kasan-dev@googlegroups.com, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Rik van Riel <riel@redhat.co>
List-Id: linux-efi@vger.kernel.org


* Tom Lendacky <thomas.lendacky@amd.com> wrote:

> Create a new function attribute, __nostackp, that can used to turn off
> stack protection on a per function basis.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  include/linux/compiler-gcc.h | 2 ++
>  include/linux/compiler.h     | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index cd4bbe8..682063b 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -166,6 +166,8 @@
>  
>  #if GCC_VERSION >= 40100
>  # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
> +
> +#define __nostackp	__attribute__((__optimize__("no-stack-protector")))
>  #endif
>  
>  #if GCC_VERSION >= 40300
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 219f82f..63cbca1 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -470,6 +470,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
>  #define __visible
>  #endif
>  
> +#ifndef __nostackp
> +#define __nostackp
> +#endif

So I changed this from the hard to read and ambiguous "__nostackp" abbreviation 
(does it mean 'no stack pointer?') to "__nostackprotector", plus added this detail 
to the changelog:

| ( This is needed by the SME in-place kernel memory encryption feature,
|   which activates encryption in its sme_enable() function and thus changes the 
|   visible value of the stack protection cookie on function return. )

Agreed?

Thanks,

	Ingo
