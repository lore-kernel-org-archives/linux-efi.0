From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] x86: efi: create memory map iteration helper
Date: Mon, 13 Jan 2014 14:40:30 +0000
Message-ID: <20140113144030.GD3256@console-pimps.org>
References: <1389210653-15271-1-git-send-email-msalter@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1389210653-15271-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, x86@kernel.org, leif.lindholm@linaro.org, Roy Franz <roy.franz@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 08 Jan, at 02:50:53PM, Mark Salter wrote:
> There are about a dozen places in the x86 EFI code which loop through
> the EFI memory map descriptors. All of these places use essentially
> the same for-loop code. This patch adds a for_each_efi_memory_desc()
> helper to clean up all of the duplicate code and make it available
> for other architectures to use.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c    | 48 +++++++++++++-----------------------------
>  arch/x86/platform/efi/efi_64.c |  5 +----
>  drivers/firmware/efi/efi.c     |  5 ++---
>  include/linux/efi.h            |  6 ++++++
>  4 files changed, 24 insertions(+), 40 deletions(-)

Thanks Mark, I like this. Applied.

-- 
Matt Fleming, Intel Open Source Technology Center
