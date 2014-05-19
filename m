From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for arm64
Date: Mon, 19 May 2014 11:50:42 +0100
Message-ID: <20140519105042.GE4798@console-pimps.org>
References: <20140430200332.GO26088@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140430200332.GO26088-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 30 Apr, at 09:03:32PM, Matt Fleming wrote:
> Hi folks,
> 
> I pulled the arm64 EFI changes into the following topic branch. Catalin
> was happy for this to go through tip, which definitely makes things
> easier for the next merge window because of the dependency these patches
> have on tip/x86/efi.
> 
> The following changes since commit e33655a386ed3b26ad36fb97a47ebb1c2ca1e928:
> 
>   efivars: Add compatibility code for compat tasks (2014-04-17 13:53:53 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git arm64-efi
> 
> for you to fetch changes up to 345c736edd07b657a8c48190baed2719b85d0938:
> 
>   efi/arm64: ignore dtb= when UEFI SecureBoot is enabled (2014-04-30 19:57:06 +0100)

Ping?

-- 
Matt Fleming, Intel Open Source Technology Center
