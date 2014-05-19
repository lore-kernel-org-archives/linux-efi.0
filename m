From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v3.16
Date: Mon, 19 May 2014 11:51:29 +0100
Message-ID: <20140519105129.GF4798@console-pimps.org>
References: <20140503130447.GW26088@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140503130447.GW26088-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 03 May, at 02:04:47PM, Matt Fleming wrote:
> Folks, please queue the following change for v3.16 from Borislav that
> uses the more strict kernel_fpu_{begin,end}() instead of the __*
> verisons that won't catch buggy use in interrupt context.
> 
> The following changes since commit e33655a386ed3b26ad36fb97a47ebb1c2ca1e928:
> 
>   efivars: Add compatibility code for compat tasks (2014-04-17 13:53:53 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to baa916f39b50ad91661534652110df40396acda0:
> 
>   x86/efi: Check for unsafe dealing with FPU state in irq ctxt (2014-05-03 06:39:25 +0100)
> 
> ----------------------------------------------------------------
>  * Use the more strict FPU handling functions before invoking EFI
>    services to catch misuse in irq context - Borislav Petkov

Ping?

-- 
Matt Fleming, Intel Open Source Technology Center
