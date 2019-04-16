Return-Path: <SRS0=bC01=SS=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A07C10F13
	for <linux-efi@archiver.kernel.org>; Tue, 16 Apr 2019 08:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B96320821
	for <linux-efi@archiver.kernel.org>; Tue, 16 Apr 2019 08:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555402849;
	bh=Fgqp50wzoMN/wPDFGd4giwXwxVX4UTerBJpnsEIC93U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fHNp9+0FWUkufGSutodbdLBaZUB0dxrqsVOxg0lchm/2U2/PZyALUjgxKdgf9W93R
	 TQPOpqDZx0xq49JiDnm2B3IQy4T6wbCn/gm93VgM4AY0mGMFN9ANl6F4vteVm+uWWo
	 QzqeyKsGRGutwUikoctyZBB3l3nAb+rKPbHw3bJo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfDPIUs (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:20:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33620 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfDPIUs (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 16 Apr 2019 04:20:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id q1so25733611wrp.0;
        Tue, 16 Apr 2019 01:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A/LQGl+57vb0DNBtCvhMhddw0SYTDbgAb9CDuz3nEDU=;
        b=NilpAz68ovtaOg5hMP+g+4C35gPQIIEddgT4G7gXfJOOpIOAVhgUFKlTQgX/P6N9Kz
         Tbm5U6/excnkBMMnujU+K4YWrmjLCzoUZxneDEqidY3Qw6uieZ0PPmigRhIB1BkqeUxH
         iufG2ZdRDUg0Qm5dnINMud/DsR4K/o4ShwV6XW3nTaR+MYErxIBg3bDag8AL5eg4FRUh
         71lkynoId1vHuRFI2UiC84pCcmtJvmFa6NwFSKMTFu7JMjzCRzgT8on1Y1kB8Hj8QalF
         CpYhLa3QNoVXuveNoYToHhCNqCq5W5p8mJm6QAvjCoEuhNzjYfO3jfzV37NmP1imeOSs
         OJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=A/LQGl+57vb0DNBtCvhMhddw0SYTDbgAb9CDuz3nEDU=;
        b=h9P7zIgU9QFL0rOABAvR4CuDA0MqbF1xRhO/NR8H2pU47LJ4/8klWXOAHuOvm1i0pD
         Psi+SctXCpn/4pe8K+1AHComfB8t3dDMTP4ee5Y2XQPL4kkXnSiQahe4XuhaR9hqhbgl
         SruXAIohuwEQPjnKacmSbn/BG5vTYDGHIEYOV8Pum+F0ur8tbFcLobgYnBH28qkG5dsQ
         K5tgyoGpdTM8iggHLh7/dSn1pobAJAu3eGVCiNN1s7NjGh6xcZt+9rZQLIYbYYucd3q4
         WMPVhaKpKWhYmVMWn5arF21tWZRZsjuA2CpT2KIk3SHfDC02mSmxQ7jjk2w5VwDH0xKL
         j0UQ==
X-Gm-Message-State: APjAAAX+L9zIhMC0n4rSJCyVnzdCCEOmRcQNfVXiJ3/bQpc2o+CogioI
        hRaXGQN0O7R/5OihJC4TEsQ=
X-Google-Smtp-Source: APXvYqwcBUsxHe4rv7UNbhkmIk6U7n+81AnsNjGloqRrJau9mi+uFQln9B3dx06uI0X6l7DzFgLWXQ==
X-Received: by 2002:adf:e9c1:: with SMTP id l1mr41120236wrn.270.1555402845910;
        Tue, 16 Apr 2019 01:20:45 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id 4sm17756809wmi.14.2019.04.16.01.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 01:20:45 -0700 (PDT)
Date:   Tue, 16 Apr 2019 10:20:42 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     peterz@infradead.org, bp@alien8.de, drake@endlessm.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, jian-hong@endlessm.com,
        matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, Len Brown <len.brown@intel.com>
Cc:     linux-tip-commits@vger.kernel.org
Subject: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent] x86/reboot,
 efi: Use EFI reboot for Acer TravelMate X514-51T)
Message-ID: <20190416082042.GA69717@gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com>
 <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190416082042.AufIaKGoG5jZQeyXwC2OgI2rLqilD7aSwjnGKn4ApgI@z>


(Cc:-ed EFI and ACPI folks.)

* tip-bot for Jian-Hong Pan <tipbot@zytor.com> wrote:

> Commit-ID:  0082517fa4bce073e7cf542633439f26538a14cc
> Gitweb:     https://git.kernel.org/tip/0082517fa4bce073e7cf542633439f26538a14cc
> Author:     Jian-Hong Pan <jian-hong@endlessm.com>
> AuthorDate: Fri, 12 Apr 2019 16:01:53 +0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 16 Apr 2019 10:01:24 +0200
> 
> x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T
> 
> Upon reboot, the Acer TravelMate X514-51T laptop appears to complete the
> shutdown process, but then it hangs in BIOS POST with a black screen.
> 
> The problem is intermittent - at some points it has appeared related to
> Secure Boot settings or different kernel builds, but ultimately we have
> not been able to identify the exact conditions that trigger the issue to
> come and go.
> 
> Besides, the EFI mode cannot be disabled in the BIOS of this model.
> 
> However, after extensive testing, we observe that using the EFI reboot
> method reliably avoids the issue in all cases.
> 
> So add a boot time quirk to use EFI reboot on such systems.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=203119
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Signed-off-by: Daniel Drake <drake@endlessm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-efi@vger.kernel.org
> Cc: linux@endlessm.com
> Link: http://lkml.kernel.org/r/20190412080152.3718-1-jian-hong@endlessm.com
> [ Fix !CONFIG_EFI build failure, clarify the code and the changelog a bit. ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/reboot.c | 21 +++++++++++++++++++++
>  include/linux/efi.h      |  7 ++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 725624b6c0c0..8fd3cedd9acc 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -81,6 +81,19 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
>  	return 0;
>  }
>  
> +/*
> + * Some machines don't handle the default ACPI reboot method and
> + * require the EFI reboot method:
> + */
> +static int __init set_efi_reboot(const struct dmi_system_id *d)
> +{
> +	if (reboot_type != BOOT_EFI && !efi_runtime_disabled()) {
> +		reboot_type = BOOT_EFI;
> +		pr_info("%s series board detected. Selecting EFI-method for reboot.\n", d->ident);
> +	}
> +	return 0;
> +}
> +
>  void __noreturn machine_real_restart(unsigned int type)
>  {
>  	local_irq_disable();
> @@ -166,6 +179,14 @@ static const struct dmi_system_id reboot_dmi_table[] __initconst = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
>  		},
>  	},
> +	{	/* Handle reboot issue on Acer TravelMate X514-51T */
> +		.callback = set_efi_reboot,
> +		.ident = "Acer TravelMate X514-51T",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate X514-51T"),
> +		},
> +	},
>  
>  	/* Apple */
>  	{	/* Handle problems with rebooting on Apple MacBook5 */
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 54357a258b35..6ebc2098cfe1 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1611,7 +1611,12 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
>  			   struct screen_info *si, efi_guid_t *proto,
>  			   unsigned long size);
>  
> -bool efi_runtime_disabled(void);
> +#ifdef CONFIG_EFI
> +extern bool efi_runtime_disabled(void);
> +#else
> +static inline bool efi_runtime_disabled(void) { return true; }
> +#endif
> +

1)

Small build fix:

I added the efi.h bit to make it build on !CONFIG_EFI. Turns out 
efi_runtime_disabled() was already used in !CONFIG_EFI code, but its 
usage was masked by efi_reboot_required():

        if (!rv && efi_reboot_required() && !efi_runtime_disabled())


2)

I wanted to get a second opinion from the EFI folks for this whole 
concept. On x86 we default to ACPI reboot on modern systems, and we 
default to EFI reboot on modern EFI systems, via the 
efi_reboot_required() method which keys off on acpi_gbl_reduced_hardware 
to create a barrier for older ACPI systems.

It appears that Acer TravelMate X514-51T systems get marked as 
'acpi_gbl_reduced_hardware' which enables ACPI-reboot, but they require 
EFI-reboot.

Should we perhaps re-think the boundary between EFI-reboot and 
ACPI-reboot systems? I.e. if the EFI runtime is enabled, shouldn't we 
just use the EFI reboot method?

What does Windows do (which is really the standard test desktop PC makers 
use) - do they use the EFI reboot method unconditionally, or do they have 
more complex quirks as well?

Anyway, I applied the patch because it solves a spurious reboot hang bug 
on these systems, but wanted to raise this whole EFI reboot vs. ACPI 
reboot issue, as quirks are generally not overly precise in identifying 
the true scope of problems.

Thanks,

	Ingo
