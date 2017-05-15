From: Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH 08/10] efi/x86: Move EFI BGRT init code to early init code
Date: Mon, 15 May 2017 15:44:26 +0200
Message-ID: <20170515134426.GC1068@bistromath.localdomain>
References: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485868902-20401-9-git-send-email-ard.biesheuvel@linaro.org>
 <20170513231827.GA1068@bistromath.localdomain>
 <20170515083740.GA30363@dhcp-128-65.nay.redhat.com>
 <20170515111037.GB1068@bistromath.localdomain>
 <20170515131835.GA5708@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170515131835.GA5708@dhcp-128-65.nay.redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

2017-05-15, 21:18:35 +0800, Dave Young wrote:
> On 05/15/17 at 01:10pm, Sabrina Dubroca wrote:
> > 2017-05-15, 16:37:40 +0800, Dave Young wrote:
> > > diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> > > index 04ca876..b986e26 100644
> > > --- a/arch/x86/platform/efi/efi-bgrt.c
> > > +++ b/arch/x86/platform/efi/efi-bgrt.c
> > > @@ -36,6 +36,9 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
> > >  	if (acpi_disabled)
> > >  		return;
> > >  
> > > +	if (!efi_enabled(EFI_CONFIG_TABLES))
> 
> A better version should be checking EFI_BOOT, could you retest with
> below instead? If it works I can send a patch with your Tested-by:
> if (!efi_enabled(EFI_BOOT))

Yes, that works. Thanks for the fix :)

> > > +		return;
> > > +
> > >  	if (table->length < sizeof(bgrt_tab)) {
> > >  		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
> > >  		       table->length, sizeof(bgrt_tab));
> > > 
> > 
> > -- 
> > Sabrina
> 
> Thanks
> Dave

-- 
Sabrina
