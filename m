From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Wed, 02 Jan 2013 07:26:32 +0000
Message-ID: <1357111592.27261.19.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE03D8.9030902@zytor.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE2EED.9030608@zytor.com> <1357094751.6113.253.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357094751.6113.253.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-01-02 at 10:45 +0800, joeyli wrote:
> I didn't find the EFI RTC problem on Asus from google. 
> Could you please share what's the situation on ASUS hardware?

It's mentioned in the following commit (which has since been reverted in
Linus' tree),

commit 185034e72d591f9465e5e18f937ed642e7ea0070
Author: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Sep 7 18:28:04 2012 +0100

    x86, efi: 1:1 pagetable mapping for virtual EFI calls
    
    Some firmware still needs a 1:1 (virt->phys) mapping even after we've
    called SetVirtualAddressMap(). So install the mapping alongside our
    existing kernel mapping whenever we make EFI calls in virtual mode.
    
    This bug was discovered on ASUS machines where the firmware
    implementation of GetTime() accesses the RTC device via physical
    addresses, even though that's bogus per the UEFI spec since we've
    informed the firmware via SetVirtualAddressMap() that the boottime
    memory map is no longer valid.
    
    This bug seems to be present in a lot of consumer devices, so there's
    not a lot we can do about this spec violation apart from workaround
    it.
    

The bug was originally mentioned here,

	https://lkml.org/lkml/2012/3/12/214
