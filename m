From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI facilities
Date: Mon, 21 Jan 2013 14:42:03 -0600
Message-ID: <50FDA81B.9090602@zytor.com>
References: <1358800838-10459-1-git-send-email-matt@console-pimps.org> <1358800838-10459-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358800838-10459-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Gardner <rtg.canonical-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Langasek <steve.langasek-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Corentin Chary <corentincj-EjuBZuxMvz2sTnJN9+BGXg@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/21/2013 02:40 PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Originally 'efi_enabled' indicated whether a kernel was booted from
> EFI firmware. Over time its semantics have changed, and it now
> indicates whether or not we are booted on an EFI machine with
> bit-native firmware, e.g. 64-bit kernel with 64-bit firmware.
> 
> But users actually want to query 'efi_enabled' for different reasons -
> what they really want access to is the list of available EFI
> facilities.
> 
> For instance, the x86 reboot code needs to know whether it can invoke
> the ResetSystem() function provided by the EFI runtime services, while
> the ACPI OSL code wants to know whether the EFI config tables were
> mapped successfully. There are also checks in some of the platform
> driver code to simply see if they're running on an EFI machine (which
> would make it a bad idea to do BIOS-y things).
> 

Could you please explain as part of the checkin comment why this is
needed for urgent/stable?  I.e. what breaks *now*, as opposed to this
being a cleanup for the next merge window.

	-hpa
