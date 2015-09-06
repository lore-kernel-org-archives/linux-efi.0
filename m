From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sun, 6 Sep 2015 16:06:16 +0200
Message-ID: <CAKv+Gu8a585HGe4K-1pr0jrWC0JVGD4arQoOgsBQPD+Z2p9ipw@mail.gmail.com>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
	<CAKv+Gu9bGcSVWuMkPVJGDkCPmWvFpjhh4odLWPBZ-wX3=LgGaw@mail.gmail.com>
	<20150904182307.GE2737@codeblueprint.co.uk>
	<CAKv+Gu-AQdgJNOtrgtEtqxsaSC_L=EANpC3pT8b6X2jmZ5qO_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-AQdgJNOtrgtEtqxsaSC_L=EANpC3pT8b6X2jmZ5qO_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 4 September 2015 at 20:53, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 4 September 2015 at 20:23, Matt Fleming <matt@codeblueprint.co.uk> wrote:
>> On Fri, 04 Sep, at 03:24:21PM, Ard Biesheuvel wrote:
>>>
>>> Since the UEFI spec does not mandate an enumeration order for
>>> GetMemoryMap(), it seems to me that you still need to sort its output
>>> before laying out the VA space. Since you need to sort it anyway, why
>>> not simply sort it in reverse order and keep all the original code?
>>> Considering that this is meant for stable, that would keep the delta
>>> *much* smaller.
>>
>> Hmm... that'd be a neat trick and while it would save on the diff
>> size, I don't think it would be smaller in terms of change complexity.
>>
>> EDK2 sorts the memory map when EFI_PROPERTIES_TABLE is enabled, so we
>> can be reasonably sure the entry order returned by GetMemoryMap() is
>> compatible with the split regions, even if it's not mandated by the
>> spec.
>>
>
> EDK2 does sort it, but the spec does not mandate it so another
> implementation may do something different entirely.
>
>> For the non-EFI_PROPERTIES_TABLE case, things have been working fine
>> without the sorting, so I'm reluctant to introduce it now (it's also
>> much less of an issue there).
>>
>
> I see. I do wonder, since the VA mapping preserves the modulo 2 MB
> alignment of each region, aren't you using much more VA space when
> mapping in reverse order as you are doing now?
>

BTW if you are going to rely on the sortedness of the memory map if
the feature is enabled, you could still simply traverse the memory map
in reverse order and keep most of the old code.

-- 
Ard.
