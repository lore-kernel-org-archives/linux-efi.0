From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 1/4] efi: Convert runtime services function ptrs
Date: Thu, 6 Jun 2013 11:07:45 +0100
Message-ID: <20130606100745.GF30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-2-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370177770-26661-2-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>, X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Sun, 02 Jun, at 02:56:07PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> ... to void * like the boot services and lose all the void * casts. No
> functionality change.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/boot/compressed/eboot.c |  2 +-
>  arch/x86/include/asm/efi.h       | 28 ++++++++++++++--------------
>  include/linux/efi.h              | 28 ++++++++++++++--------------
>  3 files changed, 29 insertions(+), 29 deletions(-)

Thanks! I've chucked this into my 'urgent' queue because it's a pretty
straight forward cleanup and there's no point in allowing it to bitrot
any further (the change to eboot.c is already stale).

-- 
Matt Fleming, Intel Open Source Technology Center
