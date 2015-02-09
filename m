From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86, boot: Allow 64bit EFI kernel to be loaded above 4G
Date: Mon, 9 Feb 2015 12:23:15 -0800
Message-ID: <CAE9FiQUFO4yfEVgGZ9U0Q-RaokFor1gMbKJ7As2vvqGVkqrDbw@mail.gmail.com>
References: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
	<20150209182742.GQ6461@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150209182742.GQ6461@codeblueprint.co.uk>
Sender: linux-doc-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt.fleming@intel.com>, Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 9, 2015 at 10:27 AM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Tue, 03 Feb, at 06:03:20PM, Yinghai Lu wrote:
>
> The first thing that comes to mind is the issues we experienced last
> year when adding support for loading initrds above 4GB to the EFI boot
> stub, c.f. commit 47226ad4f4cf ("x86/efi: Only load initrd above 4g on
> second try").
>
> Are things going to work correctly this time?

That should be addressed the grub2.

I was thinking that we may need to add mem_limit command together with
linuxefi and initrdefi.
or add linuxefi64/initrdefi64?

BTW, I tested loading kernel above grub2 on
virutalbox, qemu/kvm/OVMF, and real servers (ami ...) all work without problem.

wonder if we need have one black list for 64bit UEFI that does not
support access
memory above 4G.

>> @@ -1430,9 +1431,12 @@ struct boot_params *efi_main(struct efi_
>>        * If the kernel isn't already loaded at the preferred load
>>        * address, relocate it.
>>        */
>> -     if (hdr->pref_address != hdr->code32_start) {
>> -             unsigned long bzimage_addr = hdr->code32_start;
>> -             status = efi_relocate_kernel(sys_table, &bzimage_addr,
>> +     loaded_addr = hdr->code32_start;
>> +     loaded_addr |= (unsigned long)hdr->ext_code32_start << 32;
>
> Please compile this for CONFIG_X86_32 and fix any compiler warnings.

Ok.

>
>> @@ -738,6 +742,13 @@ Offset/size:     0x264/4
>>
>>    See EFI HANDOVER PROTOCOL below for more details.
>>
>> +Field name:  ext_code32_start
>> +Type:                modify (optional, reloc)
>> +Offset/size: 0x268/4
>> +Protocol:    2.14+
>> +
>> +  The address is used with code32_start to compare pref_address
>> +  to support EFI 64bit kernel get loaded above 4G.
>
> It would be good to mention that this new field contains the upper
> 32-bits of the 64-bit address.

ok. that is: upper 32bits of the 64bit address of startup_32 when kernel
loaded above 4G.

Thanks

Yinghai
