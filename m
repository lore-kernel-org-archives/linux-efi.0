From: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/3 v2] xen: Implement EFI reset_system callback
Date: Tue, 2 May 2017 12:13:40 +0200
Message-ID: <aa878a86-42c9-7017-5f8d-71fff848c20b@suse.com>
References: <20170424175839.5262-1-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424175839.5262-1-julien.grall-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
Cc: sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24/04/17 19:58, Julien Grall wrote:
> Hi all,
> 
> This small patch series implements EFI reset_system callback when using EFI
> Xen. Without this, it will not be possible to reboot/power off ARM64 DOM0
> when using ACPI.
> 
> Cheers,
> 
> Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>

Series rebased and pushed to xen/tip for-linus-4.12b


Juergen
