From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fix
Date: Wed, 25 Jun 2014 21:42:27 +0100
Message-ID: <20140625204227.GD15494@console-pimps.org>
References: <20140620090008.GU24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140620090008.GU24049-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 20 Jun, at 10:00:08AM, Matt Fleming wrote:
> Guys,
> 
> Please pull the following compiler warning fix. Sorry, I've been pretty
> slow in getting this pull request sent. Multiple people have reported
> hitting it and I've now received 4 patches for the same warning,
> 
>   http://article.gmane.org/gmane.linux.kernel.efi/4024
>   http://article.gmane.org/gmane.linux.kernel.efi/4017
>   http://article.gmane.org/gmane.linux.kernel.efi/3957
>   http://article.gmane.org/gmane.linux.kernel.efi/3930
> 
> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 6fb8cc82c096fd5ccf277678639193cae07125a0:
> 
>   efi: Fix compiler warnings (unused, const, type) (2014-06-19 15:03:05 +0100)
> 
> ----------------------------------------------------------------
>  * Fix a few compiler warnings in the arm64 EFI code that lots of people
>    are running into and reporting - Catalin Marinas

Ping? This doesn't seem to have been picked up yet?

-- 
Matt Fleming, Intel Open Source Technology Center
