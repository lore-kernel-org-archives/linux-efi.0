From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efibc: avoid stack overflow warning
Date: Sat, 30 Apr 2016 21:14:49 +0100
Message-ID: <20160430201449.GL2839@codeblueprint.co.uk>
References: <1461952128-2135409-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461952128-2135409-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Compostella, Jeremy" <jeremy.compostella@intel.com>, Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, 29 Apr, at 07:48:31PM, Arnd Bergmann wrote:
> gcc complains about a newly added file for the EFI Bootloader Control:
> 
> drivers/firmware/efi/efibc.c: In function 'efibc_set_variable':
> drivers/firmware/efi/efibc.c:53:1: error: the frame size of 2272 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> The problem is the declaration of a local variable of type
> struct efivar_entry, which is by itself larger than the warning
> limit of 1024 bytes.
> 
> We know that the reboot notifiers are not called from a deep stack,
> so this is not an actual bug, but we should still try to rework
> the code to avoid the warning. We also know that reboot notifiers
> are never run concurrently on multiple CPUs, so there is no problem
> in just making the variable 'static'.
 
I assumed reboot notifiers were guaranteed to be non-concurrent too
but having dug into the callers of kernel_reboot(), I couldn't find
any kind of mutual exclusion.

How/where is this guaranteed?
