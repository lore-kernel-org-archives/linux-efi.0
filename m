From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 0/6] arm64/ARM pt dumper changes
Date: Tue, 26 Apr 2016 12:29:19 +0100
Message-ID: <20160426112918.GK27312@arm.com>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461343688-8552-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 22, 2016 at 06:48:02PM +0200, Ard Biesheuvel wrote:
> This series updates the kernel page table dumper to:
> - not initialize the vmemmap region markers dynamically
> - show region boundaries for the kasan shadow region
> - include the UEFI runtime services mappings

I've merged the first two patches of this series. I can take patch 4 too
if you can rebase onto for-next/core.

Cheers,

Will
