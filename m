From: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 00/16] Signature verification of hibernate snapshot
Date: Fri, 24 Jul 2015 19:08:18 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1507241527410.1141@pobox.suse.cz>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 16 Jul 2015, Lee, Chun-Yi wrote:

> This patchset is the implementation of signature verification of hibernate
> snapshot image. The origin idea is from Jiri Kosina: Let EFI bootloader
> generate key-pair in UEFI secure boot environment, then forward it to kernel
> for sign/verify hibernate image.

I've finally managed to fully go through the series and test it on my 
secure boot testing setup.

	Reviewed-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
	Tested-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>

for the whole series. Thanks,

-- 
Jiri Kosina
SUSE Labs
