From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Date: Tue, 26 Aug 2014 15:58:50 -0700
Message-ID: <CAE9FiQVE-UyXQOGTwErxRHJSUP0X61eL+x1L6x90=JToG12btw@mail.gmail.com>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
	<53FD01D0.8020203@zytor.com>
	<CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
	<CAPWNY8WG3E7oZdZDdYsrnGM5pG4kWAKkEq0Eh5Hc_uXJ_8zD5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPWNY8WG3E7oZdZDdYsrnGM5pG4kWAKkEq0Eh5Hc_uXJ_8zD5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 26, 2014 at 3:16 PM, Mantas Mikul=C4=97nas <grawity@gmail.c=
om> wrote:
>
> In particular, I just realized yesterday that I don't know whether
> it's referring to physical or virtual addresses in the initrd load
> code -- and the laptop only has 4 GB of memory, so the kernel
> shouldn't be using larger physical addresses in the first place.
> (Virtual ones, on the other hand, /would/ mean a weird bug like
> described above.)

When you have 4G ram installed, the mmio could take [3G,4G).
ram range will be [0,3G), [4G, 5G).

Yinghai
