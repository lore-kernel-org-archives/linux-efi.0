From: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/2] x86/efi: don't allocate memmap through memblock after mm_init()
Date: Thu, 05 Jan 2017 13:53:50 +0100
Message-ID: <87pok1hdlt.fsf@gmail.com>
References: <20161222102340.2689-1-nicstange@gmail.com>
        <20161223145206.GC16838@codeblueprint.co.uk>
        <878tr6jqoa.fsf@gmail.com> <20170105074221.GA1777@gmail.com>
        <CAKv+Gu9AabgVMQ+uZkmiJZt9shBB=j4XUccRoRJcv5+T8X7eAw@mail.gmail.com>
        <87inpt6ce7.fsf@gmail.com>
        <CAKv+Gu-KEJ3t5kqedbcmkagyxHusuvj2whc5zLY521tRtenUBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-KEJ3t5kqedbcmkagyxHusuvj2whc5zLY521tRtenUBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Ard Biesheuvel's message of "Thu, 5 Jan 2017 11:34:06 +0000")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86@kernel.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mika =?utf-8?Q?Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
> On 5 January 2017 at 10:15, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> So, are you Ok with only taking the other review comment, namely
>>
>>   "modify efi_fake_memmap() to use your new efi_memmap_alloc() function
>>    for consistency"
>>
>> into account for a v3?
>>
>
> Yes, that should be sufficient for a fix that can be backported.
> Anything else can wait for now


Ard, thanks for your help!

v3 is here:

  http://lkml.kernel.org/r/20170105125130.2815-1-nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org


Nicolai
