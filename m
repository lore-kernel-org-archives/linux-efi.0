From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Sat, 9 Aug 2014 09:44:55 -0700
Message-ID: <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53E62EEF.9040801-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Aug 9, 2014 at 7:23 AM, Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8@public.gmane.org=
m> wrote:
> As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G")=
,
> the kernel freezes at the earliest possible moment when trying to boo=
t
> via UEFI on my Asus laptop. (It still boots via BIOS.)
>
> If I revert that commit on current master (c309bfa9b481), it boots
> correctly again [although I see "setup_efi_pci() failed" being printe=
d].
>
> (Seems like it freezes when handle_cmdline_files() attempts to read
> the last chunk of the initramfs -- the last call to efi_file_read()
> never returns. Figuring out why that happens is beyond me, though.)
>

Matt found that efi_file_read()/firmware has problem that could not do
several reading. Please check if reverting that commit have any
difference.

---
I spent some time playing around with this bug and it appears to be
triggered by the read-a-chunk-at-a-time logic in handle_cmdline_files()=
,
(which is itself a bug workaround) introduced here,

  commit 2d2da60fb40a
  Author: Maarten Lankhorst <m.b.lankhorst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
  Date:   Fri Dec 16 13:30:58 2011 +0100

      x86, efi: Break up large initrd reads
---
