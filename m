From: Jason Taylor <jason.taylor-RrviKlmTjidOSnsfY10OVw@public.gmane.org>
Subject: efi_printk
Date: Thu, 14 Apr 2016 19:25:54 +0000
Message-ID: <005f85571fda40a483f7a5b7438a738d@WB-SVT-EXBE03.simplivity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I'm not having luck finding the efi_printk output for compressed/eboot.c. I have tried adding "earlyprintk=efi,keep" to the boot params. Is there something special that I need to do to enable it? I didn't see a config option that seemed to enable/disable it. From some bug reports, it looks like these messages should possibly just be showing up in dmesg? I'm running as a guest on Hyper-V in case that makes a difference.

Thanks,
Jason
---------------------------------------------------------------------------------------
PRIVACY STATEMENT:
This message is a PRIVATE communication.  This message and all attachments are a private communication sent by SimpliVity and are considered to be confidential or protected by privilege. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution or use of the information contained in or attached to this message is strictly prohibited.  Please notify the sender of the delivery error by replying to this message, and then delete it from your system.
---------------------------------------------------------------------------------------
