From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi/capsule: Add 'capsule' lookup support
Date: Thu, 2 Mar 2017 16:45:22 +0000
Message-ID: <CAKv+Gu8aKUMrZa0mwjVugmzAZvkSJC5xe4xerMvrsa5x+xH5xA@mail.gmail.com>
References: <20170301175943.87444-1-qiuxu.zhuo@intel.com> <20170301175943.87444-2-qiuxu.zhuo@intel.com>
 <CAKv+Gu8=_D_ghJkxeLtnVN2fNV8ybS_2+cjs3ih_TmGtTJM4+Q@mail.gmail.com> <20170302164402.GB9522@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170302164402.GB9522-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2 March 2017 at 16:44, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 02 Mar, at 03:38:51PM, Ard Biesheuvel wrote:
>>
>> > +       if (!capsule)
>> > +               return -ENOMEM;
>> > +
>> > +       capsule += sizeof(uint32_t);
>>
>> This is incorrect for 64-bit. You need to increment by the size of
>> unsigned long here, regardless of the size of efi_capsule_num.
>
> I'm almost positive this is correct, but I can't find the bit in the
> spec that says why. We're not trying to step over a pointer here, if
> memory serves, it's a capsule count or something and uint32_t is the
> right type.
>

Yes, but the next struct member is an array of pointers, so you need
to advance 8 bytes to get to it due to its alignment
