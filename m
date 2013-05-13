From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efivarfs: Never return ENOENT from firmware again
Date: Mon, 13 May 2013 20:21:47 +0100
Message-ID: <51913D4B.2000606@intel.com>
References: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 05/10/2013 11:29 AM, Lingzhu Xiang wrote:
> Previously in 1fa7e69 efi_status_to_err() translated firmware status
> EFI_NOT_FOUND to -EIO instead of -ENOENT for efivarfs operations to
> avoid confusion. After refactoring in e14ab23, it is also used in other
> places where the translation may be unnecessary.
> 
> So move the translation to efivarfs specific code. Also return EOF
> for reading zero-length files, which is what users would expect.
> 
> Cc: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
> Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> This is to be applied against mainline or Matt Fleming's chainsaw branch.

Applied, thanks.

FYI, I rebased my 'urgent' branch on v3.10-rc1, so your patch now
applies there too.
