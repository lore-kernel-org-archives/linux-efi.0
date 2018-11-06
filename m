From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v10 2/7] x86/boot: Copy kstrtoull() to compressed period
Date: Tue, 6 Nov 2018 20:13:03 +0100
Message-ID: <20181106191303.GN13712@zn.tnic>
References: <20181022093720.21426-1-fanc.fnst@cn.fujitsu.com>
 <20181022093720.21426-3-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181022093720.21426-3-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 22, 2018 at 05:37:15PM +0800, Chao Fan wrote:
> kstrtoull() lives in 'uncompressed' period, used to
> convert a string to an unsigned long long.
> Copy to 'compressed' so that we can use it to
> convert the memory address from sting to unsigned

sting?

> long long in 'compressed' period.
> 
> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
> ---
>  arch/x86/boot/compressed/misc.c | 88 +++++++++++++++++++++++++++++++++
>  arch/x86/boot/compressed/misc.h |  4 ++
>  2 files changed, 92 insertions(+)

Why do you need to copy things?

You can link that file into compressed/ as lib/kstrtox.c is a library or
include it similar to what arch/x86/boot/compressed/cmdline.c does.

Still better than copying the code.

> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index 008fdc47a29c..40378408d980 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -63,6 +63,10 @@ static inline void debug_puthex(const char *s)
>  
>  #endif
>  
> +#if (defined CONFIG_RANDOMIZE_BASE) && (defined CONFIG_RANDOMIZE_BASE)

CONFIG_RANDOMIZE_BASE twice huh? Once not enough?

:-)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
