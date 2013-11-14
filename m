From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Thu, 14 Nov 2013 10:24:17 +0200
Message-ID: <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
	<d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
	<20131113224503.GB25344@anatevka.fc.hp.com>
	<52840206.5020006@zytor.com>
	<20131113235708.GC25344@anatevka.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131113235708.GC25344-dMAi7lA+vBPDUbYHzcRnttBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jerry Hoemann <jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:DOCUMENTATION <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:MEMORY MANAGEMENT <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>," <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Jerry,

On Thu, Nov 14, 2013 at 1:57 AM,  <jerry.hoemann-VXdhtT5mjnY@public.gmane.org> wrote:
> I will still point out that as currently used, efi_reserve_boot_services
> is wrong.  A work around for firmware bugs on one platform shouldn't be
> breaking platforms that don't have that bug.  Its just much less likely
> to cause problems with higher crash kernel allocation.

Wrong in what way exactly?

We need efi_reserve_boot_services on _some_ platforms and it's only practical
to do it on all platforms to be able to boot a generic kernel.  Likewise, it
would be more practical to fix crashkernel on all platforms instead of adding a
new code path in the kernel that won't receive as much testing coverage (we
need to reserve boot services by default).

And frankly, I don't understand why 'violating the UEFI specification' is even
brought up.  It's shipped firmware that matters here no matter how broken it
is.  As long as there's a reasonable solution for crashkernel that works on all
platforms, we should go for it instead of special-casing for 'proper firmware'
because it makes testing the kernel more difficult.

                        Pekka
