From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] efivars: Fix check for
 CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
Date: Fri, 22 Mar 2013 21:11:03 +0100
Message-ID: <1363983063.1390.186.camel@x61.thuisdomein>
References: <1363982211.3728.38.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1363982211.3728.38.camel@deadeye.wl.decadent.org.uk>
Sender: stable-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-03-22 at 19:56 +0000, Ben Hutchings wrote:
> The 'CONFIG_' prefix is not implicit in IS_ENABLED().

    $ git grep -n "\bIS_ENABLED(" | grep -v "(CONFIG_"
    arch/arm/mach-clps711x/board-autcpu12.c:161:	if (IS_ENABLED(MTD_NAND_GPIO) && IS_ENABLED(GPIO_GENERIC_PLATFORM)) {
    arch/arm64/mm/mmu.c:264:	bool page64k = IS_ENABLED(ARM64_64K_PAGES);
    [...]

Did you check these other three (potential) problems too?


Paul Bolle
