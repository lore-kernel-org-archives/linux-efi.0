From: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: efi_mem_reserve(): don't reserve through memblock after mm_init()
Date: Thu, 22 Dec 2016 11:26:36 +0100
Message-ID: <87zijoz2cj.fsf@gmail.com>
References: <20161221182846.2968-1-nicstange@gmail.com>
        <20161221182846.2968-2-nicstange@gmail.com>
        <c7bf34ba-56f0-8346-36d1-7069f2115dcf@nextfour.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c7bf34ba-56f0-8346-36d1-7069f2115dcf-MRsr7dthA9VWk0Htik3J/w@public.gmane.org> ("Mika
        \=\?utf-8\?Q\?Penttil\=C3\=A4\=22's\?\= message of "Wed, 21 Dec 2016 20:45:13
 +0200")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mika =?utf-8?Q?Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>
Cc: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Mika Penttil=C3=A4 <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org> writes:

> On 21.12.2016 20:28, Nicolai Stange wrote:
>>  /**
>>   * efi_mem_reserve - Reserve an EFI memory region
>> @@ -419,7 +422,7 @@ void __init __weak efi_arch_mem_reserve(phys_addr_t =
addr, u64 size) {}
>>   */
>>  void __init efi_mem_reserve(phys_addr_t addr, u64 size)
>>  {
>> -	if (!memblock_is_region_reserved(addr, size))
>> +	if (slab_is_available() && !memblock_is_region_reserved(addr, size))
>>  		memblock_reserve(addr, size);
> Maybe !slab_is_available() ?

You're right, thanks for catching this!

Fixed in v2 at http://lkml.kernel.org/r/20161222102340.2689-2-nicstange@gma=
il.com

Thanks,

Nicolai
