From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Date: Fri, 5 Sep 2014 10:03:58 -0700
Message-ID: <CAE9FiQV7XLwKsYWprmKAkZGGyuFeK=o_b1_ABMbEGVZzZxtp2w@mail.gmail.com>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
	<20140904100137.GK3001@console-pimps.org>
	<5408D299.5000300@zytor.com>
	<20140904212925.GL3001@console-pimps.org>
	<CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A@mail.gmail.com>
	<20140905054749.GA4498@ad.chargestorm.se>
	<54095A5B.4030606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54095A5B.4030606-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 4, 2014 at 11:38 PM, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 09/05/14 07:47, Anders Darander wrote:
> In other words, the rounding up of the kernel will be undone in a
> "somewhat higher level" driver in the firmware, and the request size
> that reaches DiskIo (the "lowel level driver") remains the same.

Thanks for explanation.

Is there any way to check if EFI firmware have your fix from some calling?

Thanks

Yinghai
