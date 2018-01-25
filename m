From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] x86: efi: Replace GFP_ATOMIC with GFP_KERNEL in
 efi_query_variable_store
Date: Wed, 24 Jan 2018 18:49:23 -0800
Message-ID: <1516848563.8378.60.camel@perches.com>
References: <1516847386-5291-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516847386-5291-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2018-01-25 at 10:29 +0800, Jia-Ju Bai wrote:
> The function kzalloc here is not called in atomic context.
> If nonblocking in efi_query_variable_store is true, 
> namely it is in atomic context, efi_query_variable_store will return before
> this kzalloc is called.
> Thus GFP_ATOMIC is not necessary, and it can be replaced with GFP_KERNEL.
> 
> This is found by a static analysis tool named DCNS written by myself.
[]
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
[]
> @@ -177,7 +177,7 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size,
>  		 * that by attempting to use more space than is available.
>  		 */
>  		unsigned long dummy_size = remaining_size + 1024;
> -		void *dummy = kzalloc(dummy_size, GFP_ATOMIC);
> +		void *dummy = kzalloc(dummy_size, GFP_KERNEL);

trivially, kzalloc takes a size_t not an unsigned long
and this _could_, though probably doesn't, lose precision.

It might be nicer to convert to size_t where appropriate.
