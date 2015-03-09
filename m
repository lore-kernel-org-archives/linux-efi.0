From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v3 1/7] x86, kaslr: Use init_size instead of run_size
Date: Mon, 9 Mar 2015 12:35:25 -0700
Message-ID: <CAE9FiQWc+mnepaqr8RvRXkyhyaOY_C=KvE_A0Ojf_jda3KmFBA@mail.gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
	<1425766041-6551-2-git-send-email-yinghai@kernel.org>
	<20150309124935.GA12732@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150309124935.GA12732@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 9, 2015 at 5:49 AM, Borislav Petkov <bp@suse.de> wrote:
> I ended up committing this. Anything I've missed?
>
> ---
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Sat, 7 Mar 2015 14:07:15 -0800
> Subject: [PATCH] x86/setup: Use init_size instead of run_size
>
> Commit
>
>   e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
>
> introduced run_size for KASLR to represent the size of kernel proper
> (vmlinux).
>
> However, we should use the actual runtime size (which provides for
> copy/decompress), i.e. init_size, as it includes .bss and .brk.
>
> Why, you ask?
>
> Because init_size is the size needed for safe kernel decompression and
> thus can be higher than run_size in case the decompressor needs a larger
> buffer.
>
> From arch/x86/boot/header.S:
>   #define ZO_INIT_SIZE    (ZO__end - ZO_startup_32 + ZO_z_extract_offset)
>   #define VO_INIT_SIZE    (VO__end - VO__text)
>   #if ZO_INIT_SIZE > VO_INIT_SIZE
>   #define INIT_SIZE ZO_INIT_SIZE
>   #else
>   #define INIT_SIZE VO_INIT_SIZE
>   #endif
>   init_size:              .long INIT_SIZE         # kernel initialization size
>
> The boot loader allocates a buffer of size init_size which it
> reads from the setup header and loads the compressed kernel
> (arch/x86/boot/compressed/vmlinux) in it.
>
> init_size initially comes from the kernel proper's (vmlinux) init size.
> It includes the .bss and .brk area.
>
> When the boot loader hands off to the compressed kernel, the last
> moves itself to z_extract_offset within the buffer to make sure that
> the decompressor output does not overwrite input data before it gets
> consumed.
>
> However, z_extract_offset is the size difference
> between the uncompressed and compressed kernel (see
> arch/x86/boot/compressed/mkpiggy.c) and thus represents the additional
> space needed for decompression but it doesn't factor in a bigger
> ZO_INIT_SIZE.

Can you put back:
"
So need to make sure [z_extra_offset, init_size) will fit ZO, that means
init_size need to be adjusted according to ZO size.
That make init_size is always >= run_size.
"

>
> During ASLR buffer searching, we need to make sure the new buffer is big
> enough for decompression. So use init_size instead, and kill run_size
> related code.
