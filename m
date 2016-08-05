From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2] efi: capsule: allocate whole capsule into virtual
 memory
Date: Fri, 5 Aug 2016 12:46:53 +0100
Message-ID: <20160805114653.GP3636@codeblueprint.co.uk>
References: <1469741429-17606-1-git-send-email-austinwc@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469741429-17606-1-git-send-email-austinwc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Austin Christ <austinwc@codeaurora.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jbrasen@codeaurora.org
List-Id: linux-efi@vger.kernel.org

On Thu, 28 Jul, at 03:30:29PM, Christ, Austin wrote:
> According to UEFI 2.6 section 7.5.3, the capsule should be in contiguous
> virtual memory and firmware may consume the capsule immediately. To
> correctly implement this functionality, the kernel driver needs to vmap
> the entire capsule at the time it is made available to firmware.
> 
> The virtual allocation of the capsule update has been changed from kmap,
> which was only allocating the first page of the update, to vmap, and
> allocates the entire data payload.
> 
> Signed-off-by: Austin Christ <austinwc@codeaurora.org>
> Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
> Reviewed-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  drivers/firmware/efi/capsule-loader.c | 8 +++++---
>  drivers/firmware/efi/capsule.c        | 6 +++---
>  2 files changed, 8 insertions(+), 6 deletions(-)

Thanks, applied.
