From: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 26/27] efi: Add an EFI_SECURE_BOOT flag to indicate secure
 boot mode
Date: Sat, 21 Oct 2017 06:19:19 +0400 (+04)
Message-ID: <alpine.LFD.2.20.1710210618180.22771@t440>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842483172.7923.2791223614506312745.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <150842483172.7923.2791223614506312745.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Oct 2017, David Howells wrote:

> +	if (efi_enabled(EFI_BOOT)) {
> +		switch (mode) {
> +		case efi_secureboot_mode_disabled:
> +			pr_info("Secure boot disabled\n");
> +			break;
> +		case efi_secureboot_mode_enabled:
> +			set_bit(EFI_SECURE_BOOT, &efi.flags);
> +			pr_info("Secure boot enabled\n");
> +			break;
> +		default:
> +			pr_info("Secure boot could not be determined\n");

Perhaps make this pr_warning and include the unknown mode value?

-- 
James Morris
<james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
