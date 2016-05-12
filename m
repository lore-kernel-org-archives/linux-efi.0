From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Thu, 12 May 2016 11:04:10 +0100
Message-ID: <20160512100410.GA2728@codeblueprint.co.uk>
References: <1462523526-3172-1-git-send-email-zhaoshenglong@huawei.com>
 <20160511122730.GU2839@codeblueprint.co.uk>
 <57333533.2030206@linaro.org>
 <20160511232444.GY2839@codeblueprint.co.uk>
 <5733E8CF.3070004@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5733E8CF.3070004-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, stefano-yd54mjeZNzVBDgjK7y7TUQ@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 12 May, at 10:22:07AM, Shannon Zhao wrote:
> 
> As said above, I will rebase this patch on top of the EFI next branch.

OK thanks.

Note that it is not possible to escape merge conflicts, since there
are changes in the xen tip tree that are not in the EFI next branch
and vice versa.

For example these commits from xen/linux-next look relevant,

  8e147fcc3ffa ("FDT: Add a helper to get the subnode by given name")
  37060935dc04 ("ARM64: XEN: Add a function to initialize Xen specific UEFI runtime services")
  acb2c923a860 ("XEN: EFI: Move x86 specific codes to architecture directory")
  055be2d42408 ("ARM: Xen: Document UEFI support on Xen ARM virtual platforms")
  3915fea959b6 ("ARM: XEN: Move xen_early_init() before efi_init()")

Linus, Stefano, tip-folks: I'm soliciting opinions on the correct way
to handle this inter-tree dependency where we've got changes to EFI
code in two separate trees and Shannon wants to write patches on top
of both.

I'm guessing the best solution is to merge xen/linux-next and efi/next
into a topic branch either in the EFI tree or Xen tree, but I want to
be cautious of the branch history that will create.

(In hindsight all of these change should have probably gone via the
EFI tree.)
