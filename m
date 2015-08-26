From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] drivers/firmware: make efi/esrt.c driver explicitly
 non-modular
Date: Wed, 26 Aug 2015 18:11:28 +0100
Message-ID: <20150826171128.GA2837@codeblueprint.co.uk>
References: <1440543648-27328-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440543648-27328-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Peter Jones <pjones@redhat.com>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 25 Aug, at 07:00:48PM, Paul Gortmaker wrote:
> The Kconfig for this driver is currently hidden with:
> 
> config EFI_ESRT
>         bool
> 
> ...meaning that it currently is not being built as a module by anyone.
> Lets remove the modular code that is essentially orphaned, so that
> when reading the driver there is no doubt it is builtin-only.
> 
> Since module_init translates to device_initcall in the non-modular
> case, the init ordering remains unchanged with this commit.
> 
> We leave some tags like MODULE_AUTHOR for documentation purposes.
> 
> We don't replace module.h with init.h since the file already has that.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: linux-efi@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Looks good to me. I know Peter is on vacation right now, so I'm still
expecting a response from him. In the meantime, I'll queue this up in
the EFI 'next' branch. Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
