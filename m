From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fix
Date: Fri, 20 Jun 2014 10:28:48 +0100
Message-ID: <20140620092848.GC23939@arm.com>
References: <20140620090008.GU24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140620090008.GU24049-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 20, 2014 at 10:00:08AM +0100, Matt Fleming wrote:
> Please pull the following compiler warning fix. Sorry, I've been pretty
> slow in getting this pull request sent. Multiple people have reported
> hitting it and I've now received 4 patches for the same warning,

BTW, one of them is not just a simple warning but a bug. Pointer to
"long" variable on the stack passed to a function that only takes a
pointer to "int". We are probably lucky that we don't hit the bug on
arm64.

Anyway, thanks for pushing the fix.

(and lesson learnt not to trust the ARM EFI_STUB developers, won't name
them, with properly testing their code ;))

-- 
Catalin
