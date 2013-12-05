From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Date: Thu, 05 Dec 2013 08:56:02 -0700
Message-ID: <1386258962.1791.268.camel@misato.fc.hp.com>
References: <1385445477-9665-8-git-send-email-dyoung@redhat.com>
	 <20131127140732.GD32267@pd.tnic>
	 <20131129091415.GH4186@dhcp-16-126.nay.redhat.com>
	 <1386023600.1791.201.camel@misato.fc.hp.com>
	 <1386034289.1791.210.camel@misato.fc.hp.com>
	 <20131203015613.GB3980@dhcp-16-126.nay.redhat.com>
	 <1386085140.1791.218.camel@misato.fc.hp.com>
	 <20131204024610.GA3764@dhcp-16-126.nay.redhat.com>
	 <1386175428.1791.225.camel@misato.fc.hp.com>
	 <20131205015615.GC3736@dhcp-16-126.nay.redhat.com>
	 <20131205115124.GC14407@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131205115124.GC14407-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-12-05 at 12:51 +0100, Borislav Petkov wrote:
> On Thu, Dec 05, 2013 at 09:56:15AM +0800, Dave Young wrote:
> > > The z420 firmware is based on some UEFI core that may be used by other
> > > vendors as well.  Since this handling is totally harmless (just
> > > redundant), I'd suggest not to have a platform check on this handling.
> > 
> > I have same worry as well, so I agree with you.
> 
> Btw, why does kexec need the ->smbios table at all? I see it being
> passed in efi_setup_data.

Hi Boris,

The smbios in efi_setup_data is necessary for kexec to pass the physical
address of the SMBIOS table from the 1st kernel to the 2nd kernel.

The kernel boot sequence proceeds in the following order.  Step 2
requires efi.smbios to be the physical address.  However, Dave found
that EFI system table has a virtual address of SMBIOS in step 1.  Hence,
he sets it back to the physical address with the smbios in
efi_setup_data.  (When it is still the physical address, it simply sets
the same value.)

1. efi_init() - Set efi.smbios from EFI system table
2. dmi_scan_machine() - Temporary map efi.smbios to access SMBIOS table
3. efi_enter_virtual_mode() - Map EFI ranges

Thanks,
-Toshi
