From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Thu, 14 Nov 2013 20:44:04 +0200
Message-ID: <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
	<d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
	<20131113224503.GB25344@anatevka.fc.hp.com>
	<52840206.5020006@zytor.com>
	<20131113235708.GC25344@anatevka.fc.hp.com>
	<CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
	<20131114180455.GA32212@anatevka.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131114180455.GA32212-dMAi7lA+vBPDUbYHzcRnttBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jerry Hoemann <jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:DOCUMENTATION <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:MEMORY MANAGEMENT <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>," <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 14, 2013 at 8:04 PM,  <jerry.hoemann-VXdhtT5mjnY@public.gmane.org> wrote:
> Making this issue a quirk will be a lot more practical.  Its a small, focused
> change whose implications are limited and more easily understood.

There's nothing practical with requiring users to pass a kernel option
to make kdump work.  It's a workaround, sure, but it's not a proper
fix.

And once you add whitelisting to make it practical, implications are
no longer limited nor easily understood nor actually testable unless
you happen to have access every single firmware out there.

Yes, we have plenty of quirks in the x86 boot code but that doesn't
mean it's a good idea to add more of the unless we absolutely must.

                                Pekka
