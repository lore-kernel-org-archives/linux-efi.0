From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Date: Wed, 27 Aug 2014 10:13:22 -0700
Message-ID: <CAE9FiQWrPtEe3tkJjgOzyJJPPzX=AtMYgR4c91pDHL3q3ZLLKQ@mail.gmail.com>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
	<20140827105901.GC28116@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140827105901.GC28116-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 27, 2014 at 3:59 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Tue, 26 Aug, at 02:45:44PM, Yinghai Lu wrote:
> The reason I suggested introducing some kind of kernel parameter to
> allow loading above 4G is because if Mantas loads a 5GB initrd with your
> patch, his machine is still going to hang, with no indication of why it
> hung.
>
> At least with a kernel paramter, by default we can try to load under 4G,
> and if that fails because the file is too big we can print something
> along the lines of,
>
>   "initramfs file too large: try booting with efi=file-max"
>
> No, it's not ideal, but I think it's a worthwhile compromise because
> you're only going to run into this issue when loading a huge initramfs
> with the EFI boot stub.

I would like to avoid adding more kernel parameter.

How about adding more info print out like:
  "Try to load initrd file to higher address..."

Thanks

Yinghai
