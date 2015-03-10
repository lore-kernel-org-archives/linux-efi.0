From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v3 2/7] x86, boot: Move ZO to end of buffer
Date: Mon, 9 Mar 2015 18:04:08 -0700
Message-ID: <CAE9FiQUcmKJQm5FTADa10y6Ur1v-NfQ7gTT0HZfAWVpnRY3AkQ@mail.gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
	<1425766041-6551-3-git-send-email-yinghai@kernel.org>
	<CAGXu5jJFms+vYOtEpVAQ6iZXM45uYF70a=vgyb72T0uRkf8c0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJFms+vYOtEpVAQ6iZXM45uYF70a=vgyb72T0uRkf8c0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 9, 2015 at 5:54 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Mar 7, 2015 at 2:07 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Boris found data from boot stage can not be used kernel stage.
>
> "... be used during kernel stage."
>
> Also, can you give a specific example of this problem? (Which data, used how?)
>
>> Bootloader allocate buffer according to init_size in hdr, and load the
>> ZO (arch/x86/boot/compressed/vmlinux) from start of that buffer.
>> During running of ZO, ZO move itself to the middle of buffer at
>> z_extract_offset to make sure that decompressor would not have output
>> overwrite input data before input data get consumed.
>> After decompressor is called, VO (vmlinux) use whole buffer from start,
>> and ZO code and data section is overlapped with VO bss section.
>> And later VO/clear_bss() clear them before code in arch/x86/kernel/setup.c
>> access them.
>>
>> To make the data survive that later, we should avoid the overlapping.
>> At first move ZO close the end of buffer instead of middle of the buffer,
>> that will move out ZO data out of VO bss area.
>>
>> Also after that we can find out where is data section of copied ZO
>> instead of guessing. That will aslr mem_avoid array filling for
>
> "That will make aslr mem_avoid array ..."
>
>> new buffer seaching much simple.
>>
>> And rename z_extract_offset to z_min_extract_offset, as it is
>> actually the minimum offset for extracting now.
>>
>> To keep the final real extract_offset to be page aligned like
>> min_extract_offset, we need make VO _end and ZO _end both
>> page aligned to make sure init_size always page aligned.
>>
>> Next patch will add ZO data size to init_size, so it will make sure
>> ZO data is even out of VO brk area.
>
> This seems like a reasonable idea, but I think the changes should be
> noted/updated in misc.c since a lot of effort was made to make the
> in-memory foot print as small as possible.

Yes, that explanation in misc.c is very good about extra bytes, and it should
still stand. Also need to make mkpiggy.c to point to it.
We need to add more info about in head_32/64.c actually we need move
to end of the buffer.

> These changes do expand the
> size of the loaded kernel, IIUC. If not in this patch, maybe in 5/7?

It extend about 256k for init_size.  should be 3/7.
but that is only for decompress time. Final VO (vmlinux) run size
is not changed.

Thanks

Yinghai
