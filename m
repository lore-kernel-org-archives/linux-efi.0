From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Sun, 10 Aug 2014 21:43:32 +0300
Message-ID: <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
	<20140809192302.GJ15082@console-pimps.org>
	<CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
	<CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, Aug 10, 2014 at 8:55 AM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Sat, Aug 9, 2014 at 3:45 PM, Mantas Mikul=C4=97nas <grawity@gmail.=
com> wrote:
>> On Sat, Aug 9, 2014 at 10:23 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434MQ@public.gmane.org=
g> wrote:
>> [However... Whether it's five chunks, four (after making the initrd
>> smaller), or just one (with your efi=3Dnochunk), I noticed that it
>> *always* hangs during the *last* read, and the allocated memory alwa=
ys
>> ends at roughly the same address (0x137fffXXX). I wonder if it's
>> selecting a memory location already in use, or something like that..=
=2E]
>>
>> (The laptop is Asus K52JT, AMI firmware v206, no updates available.)
>
> wonder if  efi_file_read return with wrong chunksize.
>
> Can you try attached patch ?

Thanks, but it didn't change anything.

(I tried adding some efi_printk's, and as far as I can see,
efi_file_read *doesn't* return at all.)

--=20
Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
