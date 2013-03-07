From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Thu, 07 Mar 2013 12:38:49 -0800
Message-ID: <5138FAD9.7050504@zytor.com>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362678017-2862-1-git-send-email-seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/07/2013 09:40 AM, Seth Forshee wrote:
> We know that with some firmware implementations writing too much data to
> UEFI variables can lead to bricking machines. Recent changes attempt to
> address this issue, but for some it may still be prudent to avoid
> writing large amounts of data until the solution has been proven on a
> wide variety of hardware.
> 
> Crash dumps or other data from pstore can potentially be a large data
> source. Add a new option, CONFIG_EFI_VARS_PSTORE, which can be set to N
> to avoid using efivars as a backend to pstore.

What about a command line option?

> -#ifdef CONFIG_PSTORE
> +#if defined(CONFIG_PSTORE) && defined(CONFIG_EFI_VARS_PSTORE)

Redundant.

	-hpa
