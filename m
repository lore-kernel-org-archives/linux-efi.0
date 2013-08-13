From: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 05/16] rename __get_map() to efi_get_memory_map(), add
 parameter to optionally return mmap key. The mmap key is required to exit
 EFI boot services, and allows efi_get_memory_map() to be used for getting
 final memory map.
Date: Tue, 13 Aug 2013 09:57:02 -0400
Message-ID: <1376402222.27484.16.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-6-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376090777-20090-6-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)

Tested on arm64.

Acked-by: Mark Salter <msalter@redhat.com>
