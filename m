From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 00/16] Signature verification of hibernate snapshot
Date: Sat, 25 Jul 2015 22:32:03 +0800
Message-ID: <20150725143203.GA19009@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <alpine.LNX.2.00.1507241527410.1141@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1507241527410.1141-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Jiri,

On Fri, Jul 24, 2015 at 07:08:18PM +0200, Jiri Kosina wrote:
> On Thu, 16 Jul 2015, Lee, Chun-Yi wrote:
> 
> > This patchset is the implementation of signature verification of hibernate
> > snapshot image. The origin idea is from Jiri Kosina: Let EFI bootloader
> > generate key-pair in UEFI secure boot environment, then forward it to kernel
> > for sign/verify hibernate image.
> 
> I've finally managed to fully go through the series and test it on my 
> secure boot testing setup.
> 
> 	Reviewed-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
> 	Tested-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
> 
> for the whole series. Thanks,
> 
> -- 
> Jiri Kosina
> SUSE Labs

Thanks for your review and test.

Joey Lee
