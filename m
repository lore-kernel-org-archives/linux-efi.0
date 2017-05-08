From: Russ Anderson <rja-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Correct ident mapping of efi old_map when
        kalsr enabled
Date: Sun, 7 May 2017 22:18:23 -0500
Message-ID: <20170508031823.GA5280@hpe.com>
References: <1493294823-9315-1-git-send-email-bhe@redhat.com> <20170505204214.GB5225@codeblueprint.co.uk> <20170505233620.eka5md5mmnp4ituz@pd.tnic>
Reply-To: Russ Anderson <rja-ZPxbGqLxI0U@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170505233620.eka5md5mmnp4ituz-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, May 06, 2017 at 01:36:20AM +0200, Borislav Petkov wrote:
> On Fri, May 05, 2017 at 09:42:14PM +0100, Matt Fleming wrote:
> > (Including the folks from SGI since this was hit on a UV system)
> 
> Wasn't there a BIOS fix supplied at some point which obviated the need
> to boot with efi=old_map on SGI boxes?

Yes, and other fixes to get new and old mapping working (except
for UV1 hardware).  The kaslr patchset broke booting with old
mapping.  That is the issue Baoquan, Bhupesh, and legacy SGI
engineers are trying to fix.


For those that want a more detailed summary:

In early 2014 upstream EFI changed the mapping, which lead to setting EFI_OLD_MEMMAP on all UV systems.

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a5d90c923bcfb9632d998ed06e9569216ad695f3

Later upstream fixes, plus a bios fix, got new mapping working.
Here are a couple of the fixes.

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=08914f436bdd2ed60923f49cbc402307aba20fe4
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/x86/platform/uv/bios_uv.c?id=f72075c9eda8a43aeea2f9dbb8d187afd4a76f0b

This patch enabled new EFI mapping on UV2+ platforms (all but UV1).
Note this is not bios version checking, it is hardware platform checking.

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/x86/platform/efi/quirks.c?id=d394f2d9d8e1e7b4959819344baf67b5995da9b0

One of the fixes to get new map to work broke old map.  This patch fixed it.

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/x86/platform/uv/bios_uv.c?id=caef78b6cdeddf4ad364f95910bba6b43b8eb9bf

So upstream with recent bios works on UV2, UV3, and UV4 hardware platforms,
both old and new mapping, with new mapping being the default.

Thanks.
-- 
Russ Anderson,  Hawks 2 Linux Kernel Group Manager
HPE - Hewlett Packard Enterprise (formerly SGI)  rja-ZPxbGqLxI0U@public.gmane.org  (rja-sJ/iWh9BUns@public.gmane.org)
