From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Date: Wed, 27 Aug 2014 01:16:57 +0300
Message-ID: <CAPWNY8WG3E7oZdZDdYsrnGM5pG4kWAKkEq0Eh5Hc_uXJ_8zD5g@mail.gmail.com>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
	<53FD01D0.8020203@zytor.com>
	<CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 27, 2014 at 1:05 AM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Aug 26, 2014 at 2:53 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote=
:
>> On 08/26/2014 02:45 PM, Yinghai Lu wrote:
>>> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support init=
rd
>>> loaded above 4G"), the kernel freezes at the earliest possible mome=
nt
>>> when trying to boot via UEFI on Asus laptop.
>>>
>>> There are buggy EFI implementations: with EFI run time, kernel need
>>> to load file with 512bytes alignment when buffer is above 4G.
>>>
>>
>> This makes absolutely zero sense.  Please explain what the actual
>> problem is here.
>
> The firmware has bug and can use buffer above 4G to read files.
> and if the file size is 512 bytes alignment, then reading could go th=
rough.
>
> From Mantas:
> --
> On Wed, Aug 20, 2014 at 12:05 PM, Mantas Mikul=C4=97nas <grawity@gmai=
l.com> wrote:
>>
>> I experimented with some things (like setting chunk size to a few kB
>> to see if it hangs earlier or only at the very end; etc.), and final=
ly
>> found out that it stops freezing if I pad the initrd file to a
>> multiple of 512 bytes :/ That is, 5684268 bytes will freeze, 5684736
>> bytes will not.
>>
>> ...In other words, seems like it cannot read chunks that aren't
>> multiples of 512 into a location above 4 GB. Or something like that.=
=2E

Note that I'm mostly clueless about how EFI works (my "debugging" is
mostly just 'efi_printk()'s to see where it hangs), so take my
description with a grain of salt...

In particular, I just realized yesterday that I don't know whether
it's referring to physical or virtual addresses in the initrd load
code -- and the laptop only has 4 GB of memory, so the kernel
shouldn't be using larger physical addresses in the first place.
(Virtual ones, on the other hand, /would/ mean a weird bug like
described above.)

--=20
Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
