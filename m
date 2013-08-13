From: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 06/16] Enforce minimum alignment of 1 page on
 allocations. The efi_high_alloc() and efi_low_alloc() functions use the
 EFI_ALLOCATE_ADDRESS option to the EFI function allocate_pages(), which
 requires a minimum of page alignment, and rejects all other requests.
Date: Tue, 13 Aug 2013 09:57:08 -0400
Message-ID: <1376402228.27484.17.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-7-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376090777-20090-7-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> The existing code could fail to allocate depending
> on allocation size, as although repeated allocation
> attempts were made, none were guaranteed to be page
> aligned.
> 
> 
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---

Tested on arm64.

Acked-by: Mark Salter <msalter@redhat.com>
