From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 06/16] x86/efi: Generating random HMAC key for siging
 hibernate image
Date: Fri, 31 Jul 2015 23:09:50 +0800
Message-ID: <20150731150950.GC2067@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-7-git-send-email-jlee@suse.com>
 <1438273246.11322.14.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438273246.11322.14.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 30, 2015 at 05:20:46PM +0100, Matt Fleming wrote:
> On Thu, 2015-07-16 at 22:25 +0800, Lee, Chun-Yi wrote:
> > This patch adds codes in EFI stub for generating and storing the
> > HMAC key in EFI boot service variable for signing hibernate image.
> > 
> > Per rcf2104, the length of HMAC-SHA1 hash result is 20 bytes, and
> > it recommended the length of key the same with hash rsult, means
> > also 20 bytes. Using longer key would not significantly increase
> > the function strength. Due to the nvram space is limited in some
> > UEFI machines, so using the minimal recommended length 20 bytes
> > key that will stored in boot service variable.
> > 
> > For generating a messy number as a 20 bytes key, the codes in EFI
> > stub gets u32 random number five time and every random number is
> > rolling that last u32 random number as entropy.
> > 
> > The HMAC key stored in EFI boot service variable, the GUID is
> > S4SignKey-fe141863-c070-478e-b8a3-878a5dc9ef21.
> 
> [...]
> 
> > @@ -1383,6 +1384,60 @@ free_mem_map:
> >  	return status;
> >  }
> >  
> > +#ifdef CONFIG_HIBERNATE_VERIFICATION
> > +#define SWSUSP_KEY \
> > +	((efi_char16_t [10]) { 'S', 'W', 'S', 'U', 'S', 'P', 'K', 'e', 'y', 0 })
> > +#define SWSUSP_KEY_ATTRIBUTE	(EFI_VARIABLE_NON_VOLATILE | \
> > +				EFI_VARIABLE_BOOTSERVICE_ACCESS)
> 
> You mean "SWSUSPKey" not "S4SignKey" right?
>

Oh! it's my fault. In 2013 PKI edition, there havse sign key and verify key.
The HMAC edition has only one SWSUSPKey. 

I will change the variable name in patch description.


Thanks a lot!
Joey Lee
