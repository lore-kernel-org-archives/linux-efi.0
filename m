From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Wed, 13 Nov 2013 14:49:42 -0800
Message-ID: <52840206.5020006@zytor.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com> <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com> <20131113224503.GB25344@anatevka.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131113224503.GB25344-dMAi7lA+vBPDUbYHzcRnttBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Cc: rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/13/2013 02:45 PM, jerry.hoemann-VXdhtT5mjnY@public.gmane.org wrote:
> 
> The changes in 3.9 to allow crash kernel to be allocated high helps. 
> But as you say, the default is still to allocate crash kernel low and
> still susceptible to this problem.  So, a kdump expert can work around it.
> But, not everyone is a kdump expert.
> 
> So, we can work to change the default, or encourage the distros
> to always allocate high.  Or, we change the call to efi_reserve_boot_services
> not apply to all platforms.
> 
> The problems for pre 3.9 based distros is worse as they don't have
> ability to allocate crash kernel high.
> 

But they won't have your new option, either, and that is still horribly
manual and system-dependent.

In other words, allocating the crashkernel high has ALL the advantages,
plus a few more, and NONE of the disadvantages.

	-hpa
