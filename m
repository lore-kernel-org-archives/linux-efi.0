From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/4] x86/efi: show actual ending addresses in
 efi_print_memmap
Date: Mon, 21 Dec 2015 15:50:38 +0000
Message-ID: <20151221155038.GD4227@codeblueprint.co.uk>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-2-git-send-email-elliott@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450402114-3606-2-git-send-email-elliott@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Elliott <elliott@hpe.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 17 Dec, at 07:28:31PM, Robert Elliott wrote:
> Adjust efi_print_memmap to print the real end address of each
> range, not 1 byte beyond. This matches other prints like those for
> SRAT and nosave memory.
> 
> Change the closing ) to ] to match the opening [.
> 
> old:
>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c80000000) (16384MB)
> 
> new:
>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16384MB)
> 
> Example other address range prints:
>     SRAT: Node 1 PXM 1 [mem 0x480000000-0x87fffffff]
>     PM: Registered nosave memory: [mem 0x880000000-0xc7fffffff]
> 
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> ---
>  arch/x86/platform/efi/efi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Is this change purely for aesthetic reasons? We're usually not in the
habit of changing the output of print messages without a good reason
because people downstream do rely on them being consistent.
