From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86, boot: Allow 64bit EFI kernel to be loaded above 4G
Date: Tue, 24 Feb 2015 16:31:27 -0800
Message-ID: <CAE9FiQW8qRw76Q9R0YqmXVPC_scNNYc440_XoDVrLNRc+OxOhQ@mail.gmail.com>
References: <1424663028-13066-1-git-send-email-yinghai@kernel.org>
	<20150224215501.GB9758@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150224215501.GB9758@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt.fleming@intel.com>, Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 24, 2015 at 1:55 PM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Sun, 22 Feb, at 07:43:48PM, Yinghai Lu wrote:
>> +Field name:  ext_code32_start
>> +Type:                modify (optional, reloc)
>> +Offset/size: 0x268/4
>> +Protocol:    2.14+
>> +
>> +  This field is the upper 32bits of load address when EFI 64bit kernel
>> +  is loaded above 4G. And it is used with code32_start to compare to
>> +  pref_address to decide if kernel need to be relocated further.
>
> I think we can delete the second sentence.
>
> But these are minimal changes and I'm happy to fix them up when applying
> this patch if that's OK?

Sure. Please go ahead.

Thanks

Yinghai
