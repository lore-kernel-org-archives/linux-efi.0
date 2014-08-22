From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Fri, 22 Aug 2014 17:43:35 +0300
Message-ID: <CAPWNY8V4pfazk4Hw9qu07cAQZywC-GS7eyS+54fazXZaKMjMQw@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<53F752A2.7080604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53F752A2.7080604-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 22, 2014 at 5:24 PM, Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On 09.08.2014 16:23, Mantas Mikul=C4=97nas wrote:
>> As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G"=
),
>> the kernel freezes at the earliest possible moment when trying to bo=
ot
>> via UEFI on my Asus laptop. (It still boots via BIOS.)
>>
>> If I revert that commit on current master (c309bfa9b481), it boots
>> correctly again [although I see "setup_efi_pci() failed" being print=
ed].
>>
>> (Seems like it freezes when handle_cmdline_files() attempts to read
>> the last chunk of the initramfs -- the last call to efi_file_read()
>> never returns. Figuring out why that happens is beyond me, though.)
>>
>
> I fixed my issue with: https://lkml.org/lkml/2014/8/22/232

=2E..Well. If that's the _physical_ address, then I suppose it wouldn't
have worked on my 4 GB laptop either way. (I thought UEFI already used
some sort of virtual memory, so I never even thought to mention
this... Oh well.)

Though if that's the case, then I'm wondering why it would be affected
by the read size? Shouldn't it have crashed either as soon as the high
address was used, or never at all? (I really don't know much about
memory at this level. Sorry.)

> Care to test?

Will try later today.

--=20
Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
