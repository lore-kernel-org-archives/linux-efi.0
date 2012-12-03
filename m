From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Heads up on EFI error status change
Date: Mon, 03 Dec 2012 13:05:40 +0000
Message-ID: <1354539940.2307.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I've been trying to iron out a couple of platform differences when
starting the LF preboot loader.  It basically wasn't working on the
latest version of the tianocore image, but was on the Intel reference
platform.  The reason for the discrepancy is that tianocore stopped
returning EFI_ACCESS_DENIED if the image wouldn't load and began
returning EFI_SECURITY_VIOLATION instead.

Fixing the check for failure to be

if (status == EFI_ACCESS_DENIED || status == EFI_SECURITY_VIOLATION)

worked for me.

James
