From: Pekka Enberg <penberg-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Fri, 15 Nov 2013 10:36:37 +0200
Message-ID: <5285DD15.6080700@iki.fi>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com> <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com> <20131113224503.GB25344@anatevka.fc.hp.com> <52840206.5020006@zytor.com> <20131113235708.GC25344@anatevka.fc.hp.com> <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com> <20131114180455.GA32212@anatevka.fc.hp.com> <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com> <20131115005049.GJ5116@anatevka.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131115005049.GJ5116-dMAi7lA+vBPDUbYHzcRnttBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jerry.hoemann-VXdhtT5mjnY@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11/15/13 2:50 AM, jerry.hoemann-VXdhtT5mjnY@public.gmane.org wrote:
> One already has to specify command line arguments to enable kdump.

Yes, so what?

The problem with your patch is that now to enable kdump, I have to know 
that there's a second command line option and if my firmware is "broken" 
or not.  The former is already a problem (how do I even know such a 
thing exists?) but the latter is almost impossible to solve from user 
point of view. And if I have a "broken" firmware, kdump won't work no 
matter what options I pass.

I really don't see what's practical about that.

                         Pekka
