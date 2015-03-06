From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 01/15] x86, kaslr: Use init_size instead of run_size
Date: Fri, 6 Mar 2015 10:44:29 -0800
Message-ID: <CAE9FiQXzv7TPMRA+RqSdV0ERiW3KYA-2KOyDKBrZDn3Zd5RcrQ@mail.gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
	<1425456048-16236-2-git-send-email-yinghai@kernel.org>
	<20150306135534.GD4259@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150306135534.GD4259@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 6, 2015 at 5:55 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Mar 04, 2015 at 12:00:34AM -0800, Yinghai Lu wrote:
>> commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
>>
>> introduced one run_size for kaslr.
>>
>> We do not need to have home grown run_size.
>>
>> We should use real runtime size (include copy/decompress) aka init_size
>
> Why?

New change log:

Subject: [PATCH] x86, kaslr: Use init_size instead of run_size

commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
introduced one run_size for kaslr.
We should use real runtime size (include copy/decompress) aka init_size.

run_size is size of VO (vmlinux).
init_size is the size needed for decompress and it is bigger than run_size
when decompress need more buff.

According to arch/x86/boot/header.S:
| #define ZO_INIT_SIZE    (ZO__end - ZO_startup_32 + ZO_z_extract_offset)
| #define VO_INIT_SIZE    (VO__end - VO__text)
| #if ZO_INIT_SIZE > VO_INIT_SIZE
| #define INIT_SIZE ZO_INIT_SIZE
| #else
| #define INIT_SIZE VO_INIT_SIZE
| #endif
| init_size:              .long INIT_SIZE         # kernel initialization size

Bootloader allocate buffer according to init_size in hdr, and load the
ZO (arch/x86/boot/compressed/vmlinux) from start of that buffer.
During running of ZO, ZO move itself to the middle of buffer at
z_extract_offset to make sure that decompressor would not have output
overwrite input data before input data get consumed.
But z_extract_offset calculating is based on size of VO (vmlinux) and size
of compressed VO only at first.
So need to make [z_extra_offset, init_size) will fit ZO, that means
init_size need to be adjusted according to ZO size.
That make init_size is always >= run_size.

During aslr buffer searching, we need to make sure the buffer is bigger
enough for decompress at first. So use init_size instead, and kill not
needed run_size related code.
