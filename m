From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] UEFI: Don't use UEFI time services on 32-bit
Date: Tue, 10 Dec 2013 14:54:18 -0800
Message-ID: <52A79B9A.7080004@zytor.com>
References: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com> <52994324.4000404@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52994324.4000404-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/29/2013 05:45 PM, H. Peter Anvin wrote:
> 
> Does the Dell Venue have either an ACPI TAD or one of the PNP0B0x
> devices exposed?
> 

Ping on this?

Either way, I maintain what I have said in the past:

Unless we find evidence to the contrary, we should probably do:

ACPI TAD > PNP0B0x > EFI > hard probing

It might even be that the EFI can't be trusted enough to be in the list
at all.

	-hpa
