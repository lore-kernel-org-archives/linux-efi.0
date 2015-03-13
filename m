From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 1/7] x86, kaslr: Use init_size instead of run_size
Date: Fri, 13 Mar 2015 13:27:56 +0100
Message-ID: <20150313122756.GA28855@gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-2-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425766041-6551-2-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>
List-Id: linux-efi@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
> introduced one run_size for kaslr.
> We should use real runtime size (include copy/decompress) aka init_size.

Why, what happens if we don't change this?

What's the purpose of your change?

> run_size is VO (vmlinux) init size include bss and brk.
> init_size is the size needed for decompress and it is bigger than run_size
> when decompress need more buff.

What happens if we don't have enough 'buff'?

What's the purpose of your change?

> According to arch/x86/boot/header.S:
> | #define ZO_INIT_SIZE    (ZO__end - ZO_startup_32 + ZO_z_extract_offset)
> | #define VO_INIT_SIZE    (VO__end - VO__text)
> | #if ZO_INIT_SIZE > VO_INIT_SIZE
> | #define INIT_SIZE ZO_INIT_SIZE
> | #else
> | #define INIT_SIZE VO_INIT_SIZE
> | #endif
> | init_size:              .long INIT_SIZE         # kernel initialization size
> 
> Bootloader allocate buffer according to init_size in hdr, and load the
> ZO (arch/x86/boot/compressed/vmlinux) from start of that buffer.
> init_size first come from VO (vmlinux) init size. That VO init size
> is from VO _end to VO _end and include VO bss and brk area.
> 
> During running of ZO, ZO move itself to the middle of buffer at
> z_extract_offset to make sure that decompressor would not have output
> overwrite input data before input data get consumed.
> But z_extract_offset calculating is based on size of VO (vmlinux) and size
> of compressed VO only at first.
> So need to make sure [z_extra_offset, init_size) will fit ZO, that means
> init_size need to be adjusted according to ZO size.
> That make init_size is always >= run_size.
> 
> During aslr buffer searching, we need to make sure the new buffer is big
> enough for decompress at first. So use init_size instead, and kill not
> needed run_size related code.

Why, what happens if it's not big enough?

What's the purpose of your change?

> Fixes: e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")

What does your patch fix in that commit?

What's the purpose of your change?

After so many words you still haven't explained _the_ most basic thing 
a Linux kernel changelog needs to include: why a change is necessary, 
i.e. what bad effects did the bug have...

Why are you ignoring the kernel technology of trying to explain things 
to others so that they can easily understand so badly?

'Code well explained to others' is just as important a technology to 
the Linux kernel as 'correct code', 'clean code' or 'fast code'.

Do you perhaps understand now why I have to ignore most of your 
patches after just a sad glance at the changelog's quality?

Thanks,

	Ingo
